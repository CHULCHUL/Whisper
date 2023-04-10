//
//  WhisperApp.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import SwiftUI

@main
struct WhisperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
