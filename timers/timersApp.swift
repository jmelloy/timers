//
//  timersApp.swift
//  timers
//
//  Created by Jeffrey Melloy on 1/25/23.
//

import SwiftUI

@main
struct timersApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
