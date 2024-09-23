//
//  Better_AnkiApp.swift
//  Better Anki
//
//  Created by Anastasiia Bugaeva on 07.07.2024.
//

import SwiftUI

@main
struct Better_AnkiApp: App {

    @StateObject private var manager: DataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
