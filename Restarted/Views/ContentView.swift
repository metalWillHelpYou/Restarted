//
//  ContentView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    NavigationView {
                        HomeView()
                    }
                    .tabItem {
                        Image(systemName: "list.bullet")
                            .foregroundStyle(.blue)
                        Text("Home")
                    }
                    
                    NavigationView{
                        ArticleMainScreenView()
                    }
                    .tabItem {
                        Image(systemName: "doc.plaintext")
                        Text("Articles")
                    }
                    
                    NavigationView{
                        GamesMainScreenView()
                    }
                    .tabItem {
                        Image(systemName: "gamecontroller")
                        Text("Games")
                    }
                    
                    NavigationView{
                        DiaryView()
                    }
                    .tabItem {
                        Image(systemName: "book")
                        Text("Diary")
                    }
                    
                    NavigationView{
                        ProfileMainScreenView()
                    }
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.highlight, for: .tabBar)
                .toolbarColorScheme(userTheme == .light ? .dark : .light, for: .tabBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
