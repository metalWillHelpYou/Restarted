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
    
    @StateObject var habitEntityVm = HabitEntityViewModel()
    
    @StateObject var articleEntityVm = ArticleEntityViewModel()
    
    @StateObject var gameEntityVm = GameEntityViewModel()
    @StateObject var gameSheetVm = AlertsManager()
    @StateObject var timerVm = TimerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(habitEntityVm)
                .environmentObject(articleEntityVm)
                .environmentObject(gameEntityVm)
                .environmentObject(gameSheetVm)
                .environmentObject(timerVm)
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
