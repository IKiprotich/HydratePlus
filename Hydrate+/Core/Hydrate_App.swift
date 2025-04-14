//
//  Hydrate_App.swift
//  Hydrate+
//
//  Created by Ian   on 08/04/2025.
//

import SwiftUI
import Firebase



@main
struct Hydrate_App: App {
    @StateObject var authViewModel = AuthViewModel()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
