//
//  ContentView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @AppStorage("activeTab") private var storedActiveTab: String = Tab.home.rawValue
    @State private var allTabs: [AnimatedTab] = Tab.allCases.map { AnimatedTab(tab: $0) }
    @State private var showSignInView: Bool = false

    private var activeTab: Binding<Tab> {
        Binding(
            get: {Tab(rawValue: storedActiveTab) ?? .home },
            set: { newTab in storedActiveTab = newTab.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: activeTab) {
                    NavigationView {
                        HabitsMainScreenView()
                    }
                    .setupTab(.home)

                    NavigationView {
                        ArticleMainScreenView()
                    }
                    .setupTab(.articles)

                    NavigationView {
                        GamesMainScreenView()
                    }
                    .setupTab(.games)

                    NavigationView {
                        StatsMainView()
                    }
                    .setupTab(.stats)

                    NavigationView {
                        ProfileMainScreenView(showSigInView: $showSignInView)
                    }
                    .setupTab(.profile)
                }

                CustomTabBar(activeTab: activeTab, allTabs: $allTabs)
            }
        }
        .onAppear {
            let authUser = try? AuthenticaitionManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            AuthenticationView(showSignInView: $showSignInView)
        })
    }
}

#Preview {
    ContentView()
        .environmentObject(HabitViewModel())
        .environmentObject(ArticleViewModel())
        .environmentObject(GameViewModel())
        .environmentObject(AlertsManager())
        .environmentObject(TimerViewModel())
        .environmentObject(LocalNotificationManager())
}
