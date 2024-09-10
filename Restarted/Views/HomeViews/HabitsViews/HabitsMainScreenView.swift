//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    @State private var showHabitListView: Bool = false
    @State private var selectedHabit: Habit? = nil
    @State private var showDeleteDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    habitListSection
                    
                    Spacer()
                }
                .navigationTitle("Active Habits")
                .toolbar {
                    NavigationLink(destination: HabitListView()) { PlusButton() }
                }
                .confirmationDialog("Are you sure?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
                    deleteConfirmationButtons
                }
            }
        }
    }
}

extension HabitsMainScreenView {
    private var timeSection: some View {
        VStack {
            Circle()
                .stroke(Color.highlight, lineWidth: 4)
                .padding(40)
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
    
    private var habitListSection: some View {
        VStack {
            if habitVm.activeHabits.isEmpty {
                Text("No active habits. Add new ones!")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits.isEmpty)
            } else {
                List {
                    ForEach(habitVm.activeHabits) { habit in
                        HStack {
                            Text(habit.title ?? "")
                            Spacer()
                            Text("\(habit.goal)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            deteleHabitFromActive(habit)
                        }
                        .listRowBackground(Color.background)
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .listStyle(PlainListStyle())
                .transition(.opacity) // Анимация появления списка
                .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits)
            }
        }
    }
}

extension HabitsMainScreenView {
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                if let habitToDelete = selectedHabit {
                    habitVm.removeHabitFromActive(habitToDelete)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

extension HabitsMainScreenView {
    private func deteleHabitFromActive(_ habit: Habit?) -> some View {
        Button("Delete") {
            selectedHabit = habit
            showDeleteDialog.toggle()
        }
        .tint(.red)
    }
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitEntityViewModel())
}
