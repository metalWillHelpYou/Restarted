//
//  GameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI

struct GameSheetView: View {
    @EnvironmentObject var gameEntityVm: GameEntityViewModel
    @EnvironmentObject var alerts: AlertsManager
    @Binding var gameTitle: String
    @Binding var sheetModel: GameSheetModel
    @State private var showAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            gameData
            Spacer()
            mainButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .alert(isPresented: $showAlert) {
            alerts.getNoTitleAlert()
        }
    }
}

extension GameSheetView {
    private var gameData: some View {
        TextField(sheetModel.textFieldText, text: $gameTitle)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemGray3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var mainButton: some View {
        Button(action: handleButtonAction, label: {
            Text(sheetModel.buttonLabel)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.highlight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
        })
    }
    
    private func handleButtonAction() {
        switch sheetModel.buttonType {
        case .add:
            if gameTitle.isEmpty {
                showAlert.toggle()
            } else {
                gameEntityVm.addGame(gameTitle)
                gameTitle = ""
                dismiss()
            }
        case .edit:
            if let game = sheetModel.game, !gameTitle.isEmpty {
                gameEntityVm.editGame(entity: game, newTitle: gameTitle)
                dismiss()
            } else {
                showAlert.toggle()
            }
        }
    }
}

#Preview {
    GameSheetView(gameTitle: .constant(""), sheetModel: .constant(GameSheetModel(textFieldText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(GameEntityViewModel())
        .environmentObject(AlertsManager())
}
