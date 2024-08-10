//
//  GameSheetsModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.08.2024.
//

import Foundation

struct GameSheetModel: Identifiable {
    let id = UUID().uuidString
    
    let textFieldText: String
    let buttonLabel: String
    let buttonType: GameSheetButtonType
}

enum GameSheetTitle: String {
    case addTextFieldText = "Enter title..."
    case addButtonLabel = "Add game"
    
    case editTextFieldText = "Edit title..."
    case editButtonLabel = "Edit game"
}

enum GameSheetButtonType {
    case add
    case edit
}
