//
//  RestartedApp.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI
import SwiftData

@main
struct RestartedApp: App {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
