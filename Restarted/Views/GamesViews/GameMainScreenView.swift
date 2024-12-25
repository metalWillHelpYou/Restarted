//
//  GameMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GameMainScreenView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @State private var showNewGameSheet: Bool = false
    @State private var showEditGameSheet: Bool = false
    @State private var selectedGame: GameFirestore?
    
    var body: some View {
        NavigationStack {
            VStack {
                if lnManager.isGranted {
                    if !viewModel.savedGames.isEmpty {
                        List {
                            ForEach(viewModel.savedGames) { game in
                                HStack {
                                    Text(game.title)
                                    Spacer()
                                    NavigationLink(destination: SetUpTimerView(game: game)) {}
                                }
                                .listRowBackground(Color.background)
                                .padding(.vertical, 8)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button("Edit") {
                                        selectedGame = game
                                        showEditGameSheet.toggle()
                                    }
                                    .tint(.yellow)

                                }
                            }
                            .listRowSeparatorTint(Color.highlight)
                        }
                        .toolbar { addGameButton }
                        .listStyle(PlainListStyle())
                    } else {
                        HStack {
                            Text("Time is your most valuable resource")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            addGameButton
                        }
                    }
                } else {
                    enableNotifiationsButton
                }
            }
            .navigationTitle("Games")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .sheet(isPresented: $showNewGameSheet) {
                AddGameSheetView()
                    .presentationDetents([.medium])
            }
            .task {
                try? await lnManager.requestAuthorization()
                await lnManager.getCurrentSettings()
            }
            .task {
                await viewModel.fetchGames()
            }
        }
    }
}

extension GameMainScreenView {
    private var addGameButton: some View {
        Button(action: {
            showNewGameSheet.toggle()
        }, label: {
            PlusButton()
        })
    }
    
    private var editGameButton: some View {
        Button("Edit") {
            showEditGameSheet.toggle()
           }
           .tint(.red)
    }
}

struct AddGameSheetView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("New name", text: $viewModel.gameTitleHandler)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    await viewModel.addGame(viewModel.gameTitleHandler)
                }
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text)
                    .strokeBackground(Color.highlight)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
    }
}

struct EditGameSheetView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newTitle: String = ""
    
    let game: GameFirestore
    
    var body: some View {
        VStack {
            TextField("New title", text: $viewModel.gameTitleHandler)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    viewModel.gameTitleHandler = newTitle
                    await viewModel.editGame(game)
                }
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text)
                    .strokeBackground(Color.highlight)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
        .onDisappear {
            viewModel.gameTitleHandler = ""
        }
    }
}

extension GameMainScreenView {
    private var enableNotifiationsButton: some View {
        Button("Enable Notifications") { lnManager.openSettings() }
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity)
            .padding()
            .strokeBackground(Color.highlight)
            .padding(.horizontal)
    }
}

#Preview {
    GameMainScreenView()
        .environmentObject(GameViewModel())
        .environmentObject(LocalNotificationManager())
}
