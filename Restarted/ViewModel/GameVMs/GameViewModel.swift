//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

@MainActor
final class GameViewModel: ObservableObject {
    //let container: NSPersistentContainer
    @Published var savedEntities: [Game] = []
    @Published var gameTitleHandler: String = ""
    @Published var savedGames: [GameFirestore] = []
    
    
    func fetchGames() async {
        savedGames = await GameManager.shared.fetchGames()
    }
    
    func addGame(_ game: String) async {
        do {
            savedGames = try await GameManager.shared.addGame(withTitle: game)
            gameTitleHandler = ""
        } catch {
            print("Error adding game: \(error.localizedDescription)")
        }
    }
    
    func editGame(_ game: GameFirestore) async {
        guard !gameTitleHandler.isEmpty, gameTitleHandler != game.title else {
            print("No changes to update or title is empty.")
            return
        }

        do {
            try await GameManager.shared.editGame(gameId: game.id, title: gameTitleHandler)
            print("Game successfully updated.")
            await fetchGames()
            gameTitleHandler = ""
        } catch {
            print("Error editing game: \(error.localizedDescription)")
        }
    }
}
