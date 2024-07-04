//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(HabitData.habits) { habit in
                    NavigationLink(destination: SetHabitView()) {
                        HabitView(habit: habit)
                    }
                }
            }
            .navigationTitle("Choose new habit")
            .padding(.horizontal)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
    }
}

#Preview {
    HabitListView()
}
