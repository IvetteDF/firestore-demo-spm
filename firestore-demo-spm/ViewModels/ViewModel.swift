//
//  ViewModel.swift
//  firestore-demo-spm
//
//  Created by Ivette Fernandez on 1/24/22.
//

import Foundation
import Firebase
import CoreLocation
import Foundation

class ViewModel: ObservableObject {
    @Published var list = [Todo]()
    
    func updateData(todoToUpdate: Todo, updatedName: String, updatedNotes: String) {
        print("In updateData")
        // get a ref to the db
        let db = Firestore.firestore()
        
        //set the data to update
        //have to update both, merge not doing what we THOUGHT
        db.collection("todos").document(todoToUpdate.id).setData(["name":updatedName, "notes":updatedNotes], merge: true) { error in
            
            //check for errors
            if error == nil {
                // get the new data
                self.getData()
            }
        }
    }
    
    func deleteData(todoToDelete: Todo) {
        // get a reference to the db
        let db = Firestore.firestore()
        // specify the document to delete
        db.collection("todos").document(todoToDelete.id).delete { error in
            // check for errors
            if error == nil {
                // no errors
                // update the UI from the main thread
                DispatchQueue.main.async {
                    // remove the Todo that was just deleted
                    self.list.removeAll { todo in
                        // check for the Todo to remove
                        return todo.id == todoToDelete.id
                    }
                }
            }
        }
    }
    
    func addData(name: String, notes: String) {
        // get a reference to the database
        let db = Firestore.firestore()
        // add a document to a collection
        db.collection("todos").addDocument(data: ["name":name, "notes":notes]) { error in
            //check for errors
            if error == nil {
                // no errors
                // call getData to retrieve latest data
                self.getData()
            } else {
                // handle the error
            }
        }
    }
    
    func getData() {
        // get a ref to teh db
        let db = Firestore.firestore()
        // read the docs at a specific path
        db.collection("todos").getDocuments { snapshot, error in
            // check for errors
            if error == nil {
                // no errors
                if let snapshot = snapshot {
                    // update the list property in teh main thread
                    DispatchQueue.main.async {
                        // get all the docs and create Todos
                        // could use for loop
                        self.list = snapshot.documents.map { d in
                            // create a Todo item for each document returned
                            return Todo(id: d.documentID, name: d["name"] as? String ?? "", notes: d["notes"] as? String ?? "")
                        }
                    }
                }
            } else {
                //handle error
            }
        }
        
    }
}
