//
//  GameSheetsModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.08.2024.
//

import Foundation

struct GameSheetModel: Identifiable {
    let id = UUID().uuidString
    var game: Game?
    
    let textFieldText: String
    let buttonLabel: String
    let buttonType: SheetButtonType
}

enum GameSheetTitle: String {
    case addTextFieldText = "Enter title..."
    case addButtonLabel = "Add game"
    
    case editTextFieldText = "Edit title..."
    case editButtonLabel = "Edit game"
}

enum SheetButtonType {
    case add
    case edit
}
