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
    @Environment(\.dismiss) var dismiss
    
    @State private var showNewGameSheet: Bool = false
    @State private var showEditGameSheet: Bool = false
    @State private var showAddTime: Bool = false
    @State private var selectedGame: GameFirestore? = nil
    @State private var showDeleteDialog: Bool = false
    
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
                                    Button("Add time") {
                                        selectedGame = game
                                        showAddTime.toggle()
                                    }
                                    .tint(.gray)
                                    
                                    Button("Edit") {
                                        selectedGame = game
                                        showEditGameSheet.toggle()
                                    }
                                    .tint(.orange)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete") {
                                        HapticManager.instance.notification(type: .warning)
                                        selectedGame = game
                                        showDeleteDialog.toggle()
                                    }
                                    .tint(.red)
                                }
                            }
                            .listRowSeparatorTint(Color.highlight)
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                addGameButton
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                sortGames
                            }
                        }
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
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEditGameSheet) {
                if let game = selectedGame {
                    EditGameSheetView(game: game)
                        .presentationDetents([.fraction(0.2)])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showAddTime, content: {
                AddTimeView { seconds in
                    if let game = selectedGame {
                        Task {
                            await viewModel.addTimeTo(gameId: game.id, time: seconds)
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            })
            .task {
                try? await lnManager.requestAuthorization()
                await lnManager.getCurrentSettings()
            }
            .onAppear { viewModel.startObservingGames() }
            .onDisappear { viewModel.stopObservingGames() }
            .onChange(of: selectedGame) { newValue, _ in
                print("gameToEdit changed to: \(String(describing: newValue))")
            }
            .confirmationDialog("Are you sure?", isPresented: $showDeleteDialog) {
                if let game = selectedGame {
                    Button("Delete", role: .destructive) {
                        Task {
                            await viewModel.deleteGame(with: game.id)
                        }
                    }
                }
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
    
    private var sortGames: some View {
        Menu {
            Button("Sort by Name") {
                viewModel.sortByTitle()
                HapticManager.instance.impact(style: .soft)
            }

            Button("Sort by Date") {
                viewModel.sortByDateAdded()
                HapticManager.instance.impact(style: .soft)
            }

            Button("Sort by Time") {
                viewModel.sortByTime()
                HapticManager.instance.impact(style: .soft)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundStyle(Color.highlight)
                .frame(width: 30, height: 30)
        }
    }
    
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
