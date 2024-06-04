//
//  HabitList.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitList: View {
    @StateObject private var loadFromJSON = DataLoaderFromJSON<Habit>(filename: "habits")
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(loadFromJSON.items) { habit in
                    HabitView(habit: habit)
                }
                .padding(.horizontal)
            }
            .themedModifiers()
        }
    }
}

#Preview {
    HabitList()
}
