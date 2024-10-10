//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var habitVm: HabitViewModel
    @State private var showHabitListView: Bool = false
    @State private var selectedHabit: Habit? = nil
    @State private var showDeleteDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    timeSection   // Display time section with circle
                    
                    Spacer()
                    
                    habitListSection   // Display list of active habits
                    
                    Spacer()
                }
                .navigationTitle("Active Habits")
                .toolbar {
                    // Show "plus" button to add new habit if there are active habits
                    if !habitVm.activeHabits.isEmpty {
                        NavigationLink(destination: HabitListView()) { PlusButton() }
                    }
                }
                .confirmationDialog("Are you sure?", isPresented: $habitVm.showDeleteDialog, titleVisibility: .visible) {
                    deleteConfirmationButtons  // Delete confirmation dialog buttons
                }
            }
        }
    }
}

// MARK: - Additional UI components and logic
extension HabitsMainScreenView {

    // Display the section with a circle representing the current time
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
    
    // Section showing either a list of active habits or a prompt to add a new one
    private var habitListSection: some View {
        VStack {
            if habitVm.activeHabits.isEmpty {
                // If there are no active habits, display a message and an add button
                HStack {
                    Text("Add new active habits")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits.isEmpty)
                    NavigationLink(destination: HabitListView()) { PlusButton() }
                }
            } else {
                // Display the list of active habits
                List {
                    ForEach(habitVm.activeHabits) { habit in
                        HStack {
                            Text(habit.title ?? "")
                            Spacer()
                            Text("\(habit.goal)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            habitVm.deleteButton(for: habit)  // Swipe action to delete a habit
                        }
                        .listRowBackground(Color.background)
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .listStyle(PlainListStyle())
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits)
            }
        }
    }
    
    // Buttons for the delete confirmation dialog
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                habitVm.performDelete()
            }
            Button("Cancel", role: .cancel) {
                habitVm.cancelDelete()
            }
        }
    }
    
    // Button to add the first game if no habits are present
    private var addFirstGameButton: some View {
        Button(action: {
        }, label: {
            HStack {
                Text("Add your first game ->")
                    .padding(.horizontal, 2)
                PlusButton()
            }
            .foregroundStyle(Color.text)
        })
    }
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitViewModel())
}
