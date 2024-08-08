//
//  AddGameView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI
import SwiftData

struct AddGameView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: GameEntityViewModel
    
    @Binding var gameTitle: String
    
    var body: some View {
        VStack {
            Spacer()
            
            gameData
            
            Spacer()
            
            addGameButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    AddGameView(vm: GameEntityViewModel(), gameTitle: .constant(""))
}

extension AddGameView {
    private var gameData: some View {
        TextField("Enter title...", text: $gameTitle)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemGray3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var addGameButton: some View {
        Button(action: {
            guard !gameTitle.isEmpty else { return }
            vm.addGame(gameTitle)
            dismiss()
            gameTitle = ""
        }, label: {
            Text("Add Game")
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
