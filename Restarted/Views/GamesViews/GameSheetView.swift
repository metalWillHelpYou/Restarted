//
//  GameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI

struct GameSheetView: View {
    @StateObject var gameSheetVm = GameSheetViewModel()
    @ObservedObject var gameEntityVm: GameEntityViewModel
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
            gameSheetVm.getAlert()
        }
    }
}

#Preview {
    GameSheetView(gameEntityVm: GameEntityViewModel(), gameTitle: .constant(""), sheetModel: .constant(GameSheetModel(textFieldText: "Enter title...", buttonLabel: "Add Game", buttonType: .add)))
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
        Button(action: {
            switch sheetModel.buttonType {
            case .add:
                guard !gameTitle.isEmpty else {
                    showAlert.toggle()
                    return
                }
                gameEntityVm.addGame(gameTitle)
                gameTitle = ""
            case .edit:
                guard let game = sheetModel.game, !gameTitle.isEmpty else {
                    showAlert.toggle()
                    return
                }
                gameEntityVm.editGame(entity: game, newTitle: gameTitle)
            }
            
            dismiss()
        }, label: {
            Text(sheetModel.buttonLabel)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.highlight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        })
    }
}
