//
//  AddGameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.05.2025.
//

import SwiftUI

struct AddGameSheetView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("New name", text: $viewModel.gameTitleHandler)
                .withTextFieldModifires()
            
            Button(action: {
                Task {
                    await viewModel.addGame(with: viewModel.gameTitleHandler)
                }
                HapticManager.instance.notification(type: .success)
                dismiss()
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
