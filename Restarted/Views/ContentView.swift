//
//  ContentView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var activeTab: Tab = .home
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab ->
        AnimatedTab? in
        return .init(tab: tab)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $activeTab) {
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
                        DiaryView()
                    }
                    .setupTab(.diary)
                    
                    NavigationView {
                        ProfileMainScreenView()
                    }
                    .setupTab(.profile)
                }
                
                CustomTabBar(activeTab: $activeTab, allTabs: $allTabs)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HabitViewModel())
        .environmentObject(HabitEntityViewModel())
        .environmentObject(ArticleEntityViewModel())
        .environmentObject(GameEntityViewModel())
        .environmentObject(AlertsManager())
        .environmentObject(TimerViewModel())
}
