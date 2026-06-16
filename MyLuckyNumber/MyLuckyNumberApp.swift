//
//  MyLuckyNumberApp.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 07/06/26.
//

import SwiftUI
import SwiftData

@main
struct MyLuckyNumberApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            LuckyNumberRecord.self,
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
            WelcomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
