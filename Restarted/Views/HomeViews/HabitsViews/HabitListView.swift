//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            deteleHabitFromSavings(habit)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            editHabit(habit)
                        }
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .navigationTitle("Available Habits")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle())
                .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
                .toolbar {
                    Button(action: {
                        prepareForAddingHabit()
                        showHabitSheet.toggle()
                    }) {
                        PlusButton()
                    }
                }
                .sheet(isPresented: $showHabitSheet) {
                    SetHabitView(sheetModel: $sheetModel)
                }
                .confirmationDialog("Are you sure?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
                    deleteConfirmationButtons
                }
            }
        }
    }
}

extension HabitListView {
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                if let habitToDelete = selectedHabit {
                    habitVm.deleteHabit(habitToDelete)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

extension HabitListView {
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
            buttonType: .add)
    }
    
    private func prepareForEditingHabit(_ habit: Habit) {
        sheetModel = HabitSheetModel(
            titleText: HabitSheetTitle.editTextFieldText.rawValue,
            goalText: HabitSheetTitle.editGoalLabel.rawValue,
            buttonLabel: HabitSheetTitle.editButtonLabel.rawValue,
            buttonType: .edit)
    }
}

#Preview {
    HabitListView()
        .environmentObject(HabitEntityViewModel())
}
