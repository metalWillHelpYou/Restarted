//
//  RestartedApp.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

// Initialize Firebase SDK
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

// SwiftUI root of the application
@main
struct RestartedApp: App {
    // Persistent user-selected color scheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    // Bridges UIKit life-cycle callbacks to SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // View-models kept alive for the entire session.
    @StateObject var practiceVm = PracticeViewModel()
    @StateObject var articleVm = ArticleViewModel()
    @StateObject var gameVm = GameViewModel()
    @StateObject var timerVm = TimerViewModel()
    @StateObject var lnManager = LocalNotificationManager()
    @StateObject private var profileVm = ProfileViewModel()
    @StateObject private var languageSettings = LanguageManager()
    @StateObject var rootVm = RootViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(practiceVm)
                .environmentObject(articleVm)
                .environmentObject(gameVm)
                .environmentObject(timerVm)
                .environmentObject(lnManager)
                .environmentObject(profileVm)
                .environmentObject(rootVm)
                .environmentObject(languageSettings)
                .environment(\.locale, languageSettings.locale)
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
