//
//  NC2_NotificationApp.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI
import SwiftData

@main
struct NC2_NotificationApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Quiz.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
