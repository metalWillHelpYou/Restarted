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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct RestartedApp: App {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var habitVm = HabitViewModel()
    
    @StateObject var articleVm = ArticleViewModel()
    
    @StateObject var gameVm = GameViewModel()
    @StateObject var gameSheetVm = AlertsManager()
    @StateObject var timerVm = TimerViewModel()
    @StateObject var lnManager = LocalNotificationManager()
    @StateObject private var profileVm = ProfileViewModel()
    
    @StateObject var rootVm = RootViewModel()
    
    //    init(){
    //        // write for db here
    //      // gpt write to firestore db
    //
    //    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(habitVm)
                .environmentObject(articleVm)
                .environmentObject(gameVm)
                .environmentObject(gameSheetVm)
                .environmentObject(timerVm)
                .environmentObject(lnManager)
                .environmentObject(profileVm)
                .environmentObject(rootVm)
                .preferredColorScheme(userTheme.setTheme)
        }
    }
}
