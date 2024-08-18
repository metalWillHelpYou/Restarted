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
    @StateObject var gameEntityVm = GameEntityViewModel()
    @StateObject var gameSheetVm = GameSheetViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameEntityVm)
                .environmentObject(gameSheetVm)
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
