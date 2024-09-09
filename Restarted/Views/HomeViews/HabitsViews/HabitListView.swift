//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    @State private var showSetHabitView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                List {
                    ForEach(habitVm.savedHabits) { habit in
                        HStack {
                            Text(habit.title ?? "")
                            Spacer()
                            if habitVm.activeHabits.contains(habit) {
                                Text("Active")
                                    .foregroundColor(.green)
                            } else {
                                Button(action: {
                                    habitVm.addHabitToActive(habit)
                                }) {
                                    Text("Add to Active")
                                }
                            }
                        }
                        .listRowBackground(Color.background)
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .navigationTitle("Available Habits")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle())
                .toolbar {
                    Button(action: {
                        showSetHabitView.toggle()
                    }) {
                        PlusButton()
                    }
                }
                .sheet(isPresented: $showSetHabitView) {
                    SetHabitView()
                }
            }
        }
    }
}

#Preview {
    HabitListView()
        .environmentObject(HabitEntityViewModel())
}
