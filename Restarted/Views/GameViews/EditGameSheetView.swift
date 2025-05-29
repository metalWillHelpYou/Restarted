//
//  EditGameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.05.2025.
//

import SwiftUI

struct EditGameSheetView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var game: GameFirestore
    
    var body: some View {
        VStack {
            TextField("New title", text: $viewModel.gameTitleHandler)
                .withTextFieldModifires()
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.editGame(gameId: game.id, title: viewModel.gameTitleHandler)
                        HapticManager.instance.notification(type: .success)
                        dismiss()
                    } catch {
                        print("Error updating game: \(error)")
                    }
                }
            }, label: {
                Text("Save")
                    .withAnimatedButtonFormatting(viewModel.gameTitleHandler.isEmpty)
            })
            .disabled(viewModel.gameTitleHandler.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
    }
}
