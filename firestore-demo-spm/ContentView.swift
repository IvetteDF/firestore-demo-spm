//
//  ContentView.swift
//  firestore-demo-spm
//
//  Created by Ivette Fernandez on 1/24/22.
// adding this comment to test committing to github
//

import SwiftUI
import Firebase
import CoreLocationUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    @ObservedObject private var locationStuff = LocationStuff()
//    @StateObject var closestStopState = ""
    
    @State var name = ""
    @State var notes = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                LocationButton(.currentLocation) {
                    locationStuff.requestAllowOnceLocationPermission()
                }
                Text(locationStuff.closestStop)
                List (model.list) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        //update button
                        NavigationLink(destination: EditView(todo: item)) {
                            Image(systemName: "pencil")
                                .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        //delete button
//                        Button(action: {
//                            model.deleteData(todoToDelete: item)
//                        }, label: {
//                            Image(systemName: "minus.circle")
//                        })

                    }
                
                }
                VStack(spacing: 5) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Notes", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button ( action: {
                        // call addData
                        model.addData(name: name, notes: notes)
                        // clear text fields
                        name = ""
                        notes = ""
                    }, label: {
                        Text("Add Todo Item")
                    })
                }
            }
            .navigationTitle("To Dos")
        }
    }
    
    init () {
        model.getData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class LocationStuff: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    @Published var closestStop: String = ""
    
    let locationManager = CLLocationManager()
    
    override init () {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            //error handling
            return
        }
        
        DispatchQueue.main.async {
            // set user location to latestLocation
            self.userLocation = latestLocation
            // call findClosestStop in the previous closure, assign it to a variable
            // and then use it to set the attribute here
            self.closestStop = self.findClosestStop(userLocation: latestLocation)
//            closestStopState = self.closestStop
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func findClosestStop(userLocation: CLLocation) -> String {
        let twoStops: [String:CLLocation] = [
            "18th":CLLocation(latitude: 41.857908, longitude: 87.669147),
            "Thorndale":CLLocation(latitude: 41.990259, longitude: -87.659076)]
        
        var twoStopsDistances: [String:Double] = [:]
        var minDistance: Double = 180
        
        twoStops.forEach { stop, coords in
            //calculate distance
            let distance: Double = sqrt(pow((coords.coordinate.latitude - userLocation.coordinate.latitude), 2) + pow((coords.coordinate.longitude - userLocation.coordinate.longitude), 2))
            //check for min distance
            if distance < minDistance {
                minDistance = distance
                closestStop = stop
            }
            //add to twoStopsDistances
            twoStopsDistances[stop] = distance
        }
        
        return closestStop
    }
}
