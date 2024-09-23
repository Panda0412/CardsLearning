//
//  DataManager.swift
//  Better Anki
//
//  Created by Anastasiia Bugaeva on 22.08.2024.
//

import CoreData
import Foundation

class DataManager: NSObject, ObservableObject {
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "Model")

    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
