//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @EnvironmentObject var gameEntityVm: GameEntityViewModel
    @EnvironmentObject var gameSheetVm: AlertsManager
    
    @State private var gameTitle: String = ""
    @State private var showDeleteDialog: Bool = false
    @State private var selectedGame: Game? = nil
    @State private var selectedModel = GameSheetModel(
        textFieldText: "",
        buttonLabel: "",
        buttonType: .add
    )
    @State private var showGameSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                content
                    .navigationTitle("Games")
                    .frame(maxWidth: .infinity)
                    .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
                    .toolbar { addGameToolbarButton }
                    .sheet(isPresented: $showGameSheet) {
                        GameSheetView(
                            gameEntityVm: _gameEntityVm,
                            gameTitle: $gameTitle,
                            sheetModel: $selectedModel
                        )
                        .presentationDetents([.fraction(0.2)])
                        .presentationDragIndicator(.visible)
                    }
                    .confirmationDialog(
                        "Are you sure?",
                        isPresented: $showDeleteDialog,
                        titleVisibility: .visible
                    ) {
                        deleteConfirmationButtons
                    }
            }
        }
    }
    
    private var content: some View {
        VStack {
            if !gameEntityVm.savedEntities.isEmpty {
                gameList
            } else {
                addFirstGameButton
            }
        }
    }
    
    private var gameList: some View {
        List {
            ForEach(gameEntityVm.savedEntities) { game in
                HStack {
                    Text(game.title ?? "")
                    Spacer()
                    NavigationLink(destination: SetUpTimerView(game: game)) { }
                }
                .listRowBackground(Color.background)
                .padding(.vertical, 8)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    editGameButton(game)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    deleteGameButton(game: game)
                }
            }
            .listRowSeparatorTint(Color.highlight)
        }
        .listStyle(PlainListStyle())
    }
    
    private var addGameToolbarButton: some View {
        gameEntityVm.savedEntities.isEmpty
        ? AnyView(EmptyView())
        : AnyView(
            Button(action: {
                prepareForAddingGame()
                showGameSheet.toggle()
            }, label: {
                PlusButton()
            })
        )
    }
    
    private var addFirstGameButton: some View {
        Button(action: {
            prepareForAddingGame()
            showGameSheet.toggle()
        }, label: {
            HStack {
                Text("Add your first game ->")
                    .padding(.horizontal, 2)
                PlusButton()
            }
            .foregroundStyle(Color.text)
        })
    }
    
    private var deleteConfirmationButtons: some View {
        Group {
            Button("Delete", role: .destructive) {
                if let gameToDelete = selectedGame {
                    gameEntityVm.deleteGame(gameToDelete)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func editGameButton(_ game: Game) -> some View {
        Button("Edit") {
            prepareForEditingGame(game)
            showGameSheet.toggle()
        }
        .tint(.orange)
    }
    
    private func deleteGameButton(game: Game?) -> some View {
        Button("Delete") {
            selectedGame = game
            showDeleteDialog.toggle()
        }
        .tint(.red)
    }
    
    private func prepareForAddingGame() {
        selectedModel = GameSheetModel(
            textFieldText: GameSheetTitle.addButtonLabel.rawValue,
            buttonLabel: GameSheetTitle.addButtonLabel.rawValue,
            buttonType: .add
        )
    }
    
    private func prepareForEditingGame(_ game: Game) {
        selectedModel = GameSheetModel(
            game: game,
            textFieldText: GameSheetTitle.editTextFieldText.rawValue,
            buttonLabel: GameSheetTitle.editButtonLabel.rawValue,
            buttonType: .edit
        )
    }
}

#Preview {
    GamesMainScreenView()
        .environmentObject(GameEntityViewModel())
        .environmentObject(AlertsManager())
}
