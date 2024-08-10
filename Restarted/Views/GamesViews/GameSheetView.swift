//
//  GameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI
import SwiftData

struct GameSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: GameEntityViewModel
    @Binding var gameTitle: String
    
    @Binding var sheetModel: GameSheetModel
    
    var body: some View {
        VStack {
            Spacer()
            
            gameData
            
            Spacer()
            
            mainButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .onAppear {
            if sheetModel.buttonType == .edit, let game = sheetModel.game {
                gameTitle = game.title ?? ""
            }
        }
    }
}

#Preview {
    GameSheetView(vm: GameEntityViewModel(), gameTitle: .constant(""), sheetModel: .constant(GameSheetModel(textFieldText: "Enter title...", buttonLabel: "Add Game", buttonType: .add)))
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
                guard !gameTitle.isEmpty else { return }
                vm.addGame(gameTitle)
                gameTitle = ""
            case .edit:
                guard let game = sheetModel.game, !gameTitle.isEmpty else { return }
                vm.editGame(entity: game, newTitle: gameTitle)
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
