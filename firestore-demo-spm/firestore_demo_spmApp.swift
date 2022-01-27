//
//  firestore_demo_spmApp.swift
//  firestore-demo-spm
//
//  Created by Ivette Fernandez on 1/24/22.
//

import SwiftUI
import Firebase

@main
struct firestore_demo_spmApp: App {
    init () {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
