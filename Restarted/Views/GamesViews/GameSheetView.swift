//
//  GameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI

struct GameSheetView: View {
    @EnvironmentObject var gameVm: GameViewModel
    @Binding var gameTitle: String
    @Binding var sheetModel: GameSheetModel
    @State private var showAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            CustomTextField(placeholder: sheetModel.textFieldText, text: $gameTitle)
                .padding(.horizontal)
            
            Spacer()
            mainButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .onAppear { initializeFields() }
    }
}

extension GameSheetView {
    private var mainButton: some View {
        Button(action: {
            gameVm.handleButtonAction(
                sheetModel: sheetModel,
                gameTitle: gameTitle,
                dismiss: {
                    gameTitle = ""
                    dismiss()
                }
            )
        }, label: {
            Text(sheetModel.buttonLabel)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(gameTitle.isEmpty ? Color.gray : Color.highlight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
        })
        .disabled(gameTitle.isEmpty)
    }
}

extension GameSheetView {
    private func initializeFields() {
        gameTitle = sheetModel.game?.title ?? ""
    }
}

#Preview {
    GameSheetView(gameTitle: .constant(""), sheetModel: .constant(GameSheetModel(textFieldText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(GameViewModel())
}
