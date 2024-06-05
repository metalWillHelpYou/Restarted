//
//  HabitList.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitList: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @StateObject private var loadFromJSON = DataLoaderFromJSON<Habit>(filename: "habits")
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(loadFromJSON.items) { habit in
                        HabitView(habit: habit)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Choose new habit")
            .background(Color.background)
            .preferredColorScheme(userTheme.setTheme)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
    }
}

#Preview {
    HabitList()
}
