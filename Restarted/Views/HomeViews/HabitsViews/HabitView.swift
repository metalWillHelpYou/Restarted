//
//  HabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.09.2024.
//

import SwiftUI

struct HabitView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    
    @State private var habitTitle: String = ""
    @State private var showDeleteDialog: Bool = false
    @State private var selectedhabit: Habit? = nil
    
    var body: some View {
        List {
            ForEach(habitVm.savedHabits) { habit in
                HStack {
                    Text(habit.title ?? "Unknown")
                    
                }
                .listRowBackground(Color.background)
                .padding(.vertical, 8)
            }
            .listRowSeparatorTint(Color.highlight)
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    HabitView()
        .environmentObject(HabitEntityViewModel())
}
