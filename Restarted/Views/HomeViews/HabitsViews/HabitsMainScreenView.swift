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
    @State private var isHabitComplete: Bool = false
    
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
                    if !habitVm.activeHabits.isEmpty {
                        NavigationLink(destination: HabitListView()) { PlusButton() }
                    }
                }
                .confirmationDialog("Are you sure?", isPresented: $habitVm.showDeleteDialog, titleVisibility: .visible) {
                    deleteConfirmationButtons
                }
            }
        }
    }
}

// MARK: - Additional UI components and logic
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
            if habitVm.activeHabits.isEmpty {
                HStack {
                    Text("Your new life starts here")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits.isEmpty)
                    NavigationLink(destination: HabitListView()) { PlusButton() }
                }
            } else {
                List {
                    ForEach(habitVm.activeHabits) { habit in
                        HStack {
                            Button(action: {
                                
                                
                                withAnimation(.easeInOut) {
                                    isHabitComplete.toggle()
                                }
                            }, label: {
                                Image(systemName: isHabitComplete ? "checkmark.circle" : "circle")
                            })
                            
                            Text(habit.title ?? "")
                                .strikethrough(isHabitComplete)
                            Spacer()
                            Text("\(habit.goal)")
                                .strikethrough(isHabitComplete)
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
                .animation(.easeInOut(duration: 0.3), value: habitVm.activeHabits)
            }
        }
    }
    
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
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitViewModel())
}
