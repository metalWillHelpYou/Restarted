//
//  HabitSheetModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import Foundation

struct HabitSheetModel: Identifiable {
    let id = UUID().uuidString
    var habit: Habit?
    
    let titleText: String
    let goalText: String
    let buttonLabel: String
    let buttonType: SheetButtonType
}

enum HabitSheetTitle: String {
    case addTextFieldText = "Enter title..."
    case addButtonLabel = "Add habit"
    case addGoalLabel = "Enter your goal"
    
    case editTextFieldText = "Edit title..."
    case editButtonLabel = "Edit habit"
    case editGoalLabel = "Enter your new goal"
}
