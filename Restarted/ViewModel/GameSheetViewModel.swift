//
//  GameSheetViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.08.2024.
//

import Foundation
import SwiftUI

class GameSheetViewModel: ObservableObject {
    func getAlert() -> Alert {
        Alert(
            title: Text("Empty Field."),
            message: Text("Please enter a title for the game."),
            dismissButton: .default(Text("Ok"))
        )
    }
}
