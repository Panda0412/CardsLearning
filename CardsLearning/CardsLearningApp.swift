//
//  CardsLearningApp.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 07.07.2024.
//

import SwiftUI

@main
struct CardsLearningApp: App {
    @StateObject private var manager: DataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
