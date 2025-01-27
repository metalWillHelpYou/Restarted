//
//  ContentView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @AppStorage("activeTab") private var storedActiveTab: String = Tab.practice.rawValue
    @State private var allTabs: [AnimatedTab] = Tab.allCases.map { AnimatedTab(tab: $0) }

    private var activeTab: Binding<Tab> {
        Binding(
            get: {Tab(rawValue: storedActiveTab) ?? .practice },
            set: { newTab in storedActiveTab = newTab.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: activeTab) {
                    NavigationView {
                        PracticeMainScreenView()
                    }
                    .setupTab(.practice)

                    NavigationView {
                        ArticleMainScreenView()
                    }
                    .setupTab(.articles)

                    NavigationView {
                        GameMainScreenView()
                    }
                    .setupTab(.games)

                    NavigationView {
                        StatisticsView()
                    }
                    .setupTab(.stats)

                    NavigationView {
                        ProfileMainScreenView(activeTab: activeTab)
                    }
                    .setupTab(.profile)
                }

                CustomTabBar(activeTab: activeTab, allTabs: $allTabs)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PracticeViewModel())
        .environmentObject(ArticleViewModel())
        .environmentObject(GameViewModel())
        .environmentObject(TimerViewModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(RootViewModel())
        .environmentObject(LocalNotificationManager())
}
