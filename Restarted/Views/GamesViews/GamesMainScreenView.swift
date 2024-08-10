//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @StateObject var gameEntityVm = GameEntityViewModel()
    @State private var gameTitle: String = ""
    
    @State private var selectedModel = GameSheetModel(textFieldText: "", buttonLabel: "", buttonType: .add)
    @State private var showGameSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    if !gameEntityVm.savedEntities.isEmpty {
                        List {
                            ForEach(gameEntityVm.savedEntities) { game in
                                Text(game.title ?? "")
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        editGameButton(game)
                                    }
                            }
                            .onDelete(perform: gameEntityVm.deleteGame)
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        addFirstGameButton
                    }
                }
            }
            .navigationTitle("Games")
            .frame(maxWidth: .infinity)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar {
                if !gameEntityVm.savedEntities.isEmpty {
                    addGameButton
                }
            }
            .sheet(isPresented: $showGameSheet, content: {
                GameSheetView(gameEntityVm: gameEntityVm, gameTitle: $gameTitle, sheetModel: $selectedModel)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            })
        }
    }
}

#Preview {
    GamesMainScreenView()
}

extension GamesMainScreenView {
    private var addGameButton: some View {
        Button(action: {
            selectedModel = GameSheetModel(
                textFieldText: GameSheetTitle.addButtonLabel.rawValue,
                buttonLabel: GameSheetTitle.addButtonLabel.rawValue,
                buttonType: .add)
            
            showGameSheet.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.highlight, lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                Image(systemName: "plus")
                    .foregroundColor(Color.highlight)
                    .font(.system(size: 20))
            }
        })
    }
    
    private func editGameButton(_ game: Game) -> some View {
        Button("Edit") {
            selectedModel = GameSheetModel(
                game: game,
                textFieldText: GameSheetTitle.editTextFieldText.rawValue,
                buttonLabel: GameSheetTitle.editButtonLabel.rawValue,
                buttonType: .edit
            )
            showGameSheet.toggle()
        }
        .tint(.orange)
    }
    
    private var addFirstGameButton: some View {
        Button(action: {
            showGameSheet.toggle()
        }, label: {
            HStack {
                Text("Add your first game ->")
                    .padding(.horizontal, 2)
                
                addGameButton
            }
        })
    }
}
