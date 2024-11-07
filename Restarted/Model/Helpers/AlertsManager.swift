//
//  AlertsManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.08.2024.
//

import Foundation
import SwiftUI

final class AlertsManager: ObservableObject {
    func getNoTitleAlert() -> Alert {
        Alert(
            title: Text("Empty Field."),
            message: Text("Please enter a title for the game."),
            dismissButton: .default(Text("Ok"))
        )
    }
    
    func getSuccsesSaving() -> Alert {
        Alert(
            title: Text("Success!"),
            message: Text("You saved the data successfully."),
            dismissButton: .default(Text("Nice"))
        )
    }
}
