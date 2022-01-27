//
//  EditView.swift
//  firestore-demo-spm
//
//  Created by Ivette Fernandez on 1/25/22.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var model = ViewModel()

    var todo: Todo
    
    @State var updatedName = ""
    @State var updatedNotes = ""
    
    var body: some View {
        TextField("Updated name", text: $updatedName)
            .padding(.leading)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Updated notes", text: $updatedNotes)
            .padding(.leading)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        Button {
            model.updateData(todoToUpdate: todo, updatedName: updatedName, updatedNotes: updatedNotes)
        } label: {
            Text("Update Todo")
        }

    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
