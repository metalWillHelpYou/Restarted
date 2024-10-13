//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitVm: HabitViewModel
    @State private var showHabitSheet: Bool = false
    @State private var selectedHabit: Habit? = nil
    @State private var showDeleteDialog: Bool = false
    @State private var sheetModel = HabitSheetModel(
        titleText: "",
        goalText: "",
        buttonLabel: "",
        buttonType: .add
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                if habitVm.savedHabits.isEmpty {
                    HStack{
                        Text("Create your new habit")
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: habitVm.savedHabits.isEmpty)
                        addButton
                    }
                } else {
                    List {
                        ForEach(habitVm.savedHabits) { habit in
                            habitRow(for: habit)
                        }
                        .listRowSeparatorTint(Color.highlight)
                    }
                }
            }
            .navigationTitle("Available Habits")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(PlainListStyle())
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar { if !habitVm.savedHabits.isEmpty {addButton} }
            .sheet(isPresented: $showHabitSheet) {
                HabitSheetView(sheetModel: $sheetModel)
            }
            .confirmationDialog("Are you sure?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
                deleteConfirmationButtons
            }
            
        }
    }
}

// MARK: - Additional UI components and logic
extension HabitListView {
    private func habitRow(for habit: Habit) -> some View {
        HStack {
            Text(habit.title ?? "")
            Spacer()
            habitStatus(for: habit)
        }
        .listRowBackground(Color.background)
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            deteleHabitFromSavings(habit)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            editHabit(habit)
        }
    }
    
    private func habitStatus(for habit: Habit) -> some View {
        if habitVm.activeHabits.contains(habit) {
            return AnyView(
                Text("Active")
                    .foregroundColor(Color.highlight)
            )
        } else {
            return AnyView(
                Button(action: {
                    habitVm.addHabitToActive(habit)
                }) {
                    Text("Add to Active")
                }
            )
        }
    }
    
    private var addButton: some View {
        Button(action: {
            prepareForAddingHabit()
            showHabitSheet.toggle()
        }) {
            PlusButton()
        }
    }
    
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                if let habitToDelete = selectedHabit {
                    habitVm.deleteHabit(habitToDelete)
                    habitVm.removeHabitFromActive(habitToDelete)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func deteleHabitFromSavings(_ habit: Habit?) -> some View {
        Button("Delete") {
            selectedHabit = habit
            showDeleteDialog.toggle()
        }
        .tint(.red)
    }
    
    private func editHabit(_ habit: Habit) -> some View {
        Button("Edit") {
            prepareForEditingHabit(habit)
            showHabitSheet.toggle()
        }
        .tint(.orange)
    }
    
    private func prepareForAddingHabit() {
        sheetModel = HabitSheetModel(
            titleText: HabitSheetTitle.addButtonLabel.rawValue,
            goalText: HabitSheetTitle.addGoalLabel.rawValue,
            buttonLabel: HabitSheetTitle.addButtonLabel.rawValue,
            buttonType: .add
        )
    }
    
    private func prepareForEditingHabit(_ habit: Habit) {
        sheetModel = HabitSheetModel(
            habit: habit,
            titleText: HabitSheetTitle.editTextFieldText.rawValue,
            goalText: HabitSheetTitle.editGoalLabel.rawValue,
            buttonLabel: HabitSheetTitle.editButtonLabel.rawValue,
            buttonType: .edit
        )
    }
}

#Preview {
    HabitListView()
        .environmentObject(HabitViewModel())
}
