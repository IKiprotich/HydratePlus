//
//  Hydrate_App.swift
//  Hydrate+
//
//  Created by Ian   on 08/04/2025.
//

import SwiftUI
import Firebase
import GoogleSignIn



@main
struct Hydrate_App: App {
    @StateObject var authViewModel = AuthViewModel()
    init(){
        FirebaseApp.configure()
        
        // Configure Google Sign-In
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
