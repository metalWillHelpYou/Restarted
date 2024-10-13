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
    
    @StateObject var habitVm = HabitViewModel()
    
    @StateObject var articleVm = ArticleViewModel()
    
    @StateObject var gameVm = GameViewModel()
    @StateObject var gameSheetVm = AlertsManager()
    @StateObject var timerVm = TimerViewModel()
    @StateObject var lnManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(habitVm)
                .environmentObject(articleVm)
                .environmentObject(gameVm)
                .environmentObject(gameSheetVm)
                .environmentObject(timerVm)
                .environmentObject(lnManager)
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
