//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var habitVm: HabitViewModel
    @EnvironmentObject var habitEntityVm: HabitEntityViewModel
    @State private var showHabitListView: Bool = false
    @State private var selectedHabit: Habit? = nil
    @State private var showDeleteDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    timeSection
                    
                    Spacer()
                    
                    habitListSection
                    
                    Spacer()
                }
                .navigationTitle("Active Habits")
                .toolbar {
                    NavigationLink(destination: HabitListView()) { PlusButton() }
                }
                .confirmationDialog("Are you sure?", isPresented: $habitVm.showDeleteDialog, titleVisibility: .visible) {
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
                .frame(width: 300, height: 300)
                .padding()
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
    
    private var habitListSection: some View {
        VStack {
            if habitEntityVm.activeHabits.isEmpty {
                Text("No active habits. Add new ones!")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: $habitEntityVm.activeHabits.isEmpty)
            } else {
                List {
                    ForEach(habitEntityVm.activeHabits) { habit in
                        HStack {
                            Text(habit.title ?? "")
                            Spacer()
                            Text("\(habit.goal)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            habitVm.deleteButton(for: habit)
                        }
                        .listRowBackground(Color.background)
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .listStyle(PlainListStyle())
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: habitEntityVm.activeHabits)
            }
        }
    }
    
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                habitVm.performDelete(habitVm: habitEntityVm)
            }
            Button("Cancel", role: .cancel) {
                habitVm.cancelDelete()
            }
        }
    }
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitViewModel())
        .environmentObject(HabitEntityViewModel())
}
