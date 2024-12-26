//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class GameViewModel: ObservableObject {
    @Published var savedGames: [GameFirestore] = []
    @Published var gameTitleHandler: String = ""
    
    func fetchGames() async {
        savedGames = await GameManager.shared.fetchGames()
    }
    
    func addGame(_ game: String) async {
        do {
            savedGames = try await GameManager.shared.addGame(withTitle: game)
            await fetchGames()
            gameTitleHandler = ""
        } catch {
            print("Error adding game: \(error.localizedDescription)")
        }
    }
    
    func editGame(gameId: String, title: String) async throws {
        do {
            try await GameManager.shared.editGame(gameId: gameId, title: title)
            await fetchGames()
            gameTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }
    
    func deleteGame(with id: String) async {
        do {
            try await GameManager.shared.deleteGame(gameId: id)
            await fetchGames()
        } catch {
            print("Error deleting game: \(error.localizedDescription)")
        }
    }
}
