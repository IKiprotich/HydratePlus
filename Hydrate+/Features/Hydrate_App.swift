//
//  Hydrate_App.swift
//  Hydrate+
//
//  Created by Ian   on 08/04/2025.
//

import SwiftUI

@main
struct Hydrate_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
