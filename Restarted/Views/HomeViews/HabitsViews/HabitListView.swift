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
                
                // If no saved habits, display a prompt to create a new one
                if habitVm.savedHabits.isEmpty {
                    HStack{
                        Text("Create your new habit")
                        addButton  // Button to add a new habit
                    }
                } else {
                    // Display a list of saved habits
                    List {
                        ForEach(habitVm.savedHabits) { habit in
                            habitRow(for: habit)  // Row for each habit with swipe actions
                        }
                        .listRowSeparatorTint(Color.highlight)
                    }
                }
            }
            .navigationTitle("Available Habits")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(PlainListStyle())
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar { if !habitVm.savedHabits.isEmpty {addButton} }  // Show "plus" button in toolbar
            .sheet(isPresented: $showHabitSheet) {
                HabitSheetView(sheetModel: $sheetModel)  // Display habit sheet
            }
            .confirmationDialog("Are you sure?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
                deleteConfirmationButtons  // Delete confirmation dialog
            }
            
        }
    }
}

// MARK: - Additional UI components and logic
extension HabitListView {

    // Create a row for each habit in the list
    private func habitRow(for habit: Habit) -> some View {
        HStack {
            Text(habit.title ?? "")
            Spacer()
            habitStatus(for: habit)  // Show habit status or "Add to Active" button
        }
        .listRowBackground(Color.background)
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            deteleHabitFromSavings(habit)  // Swipe to delete the habit
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            editHabit(habit)  // Swipe to edit the habit
        }
    }

    // Determine habit status - "Active" or show option to add to active habits
    private func habitStatus(for habit: Habit) -> some View {
        if habitVm.activeHabits.contains(habit) {
            return AnyView(
                Text("Active")
                    .foregroundColor(Color.highlight)
            )
        } else {
            return AnyView(
                Button(action: {
                    habitVm.addHabitToActive(habit)  // Add habit to active habits
                }) {
                    Text("Add to Active")
                }
            )
        }
    }
    
    // Button to add a new habit
    private var addButton: some View {
        Button(action: {
            prepareForAddingHabit()  // Prepare sheet model for adding
            showHabitSheet.toggle()  // Show the habit sheet
        }) {
            PlusButton()
        }
    }
    
    // Delete confirmation buttons
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                if let habitToDelete = selectedHabit {
                    habitVm.deleteHabit(habitToDelete)  // Delete habit from saved habits
                    habitVm.removeHabitFromActive(habitToDelete)  // Also remove from active habits
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    // Swipe action for deleting a habit
    private func deteleHabitFromSavings(_ habit: Habit?) -> some View {
        Button("Delete") {
            selectedHabit = habit  // Store selected habit for deletion
            showDeleteDialog.toggle()  // Show delete confirmation dialog
        }
        .tint(.red)
    }
    
    // Swipe action for editing a habit
    private func editHabit(_ habit: Habit) -> some View {
        Button("Edit") {
            prepareForEditingHabit(habit)  // Prepare sheet model for editing
            showHabitSheet.toggle()  // Show the habit sheet
        }
        .tint(.orange)
    }
    
    // Prepare the sheet for adding a new habit
    private func prepareForAddingHabit() {
        sheetModel = HabitSheetModel(
            titleText: HabitSheetTitle.addButtonLabel.rawValue,
            goalText: HabitSheetTitle.addGoalLabel.rawValue,
            buttonLabel: HabitSheetTitle.addButtonLabel.rawValue,
            buttonType: .add
        )
    }
    
    // Prepare the sheet for editing an existing habit
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
