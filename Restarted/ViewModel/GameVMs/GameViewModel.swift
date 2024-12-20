//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import Foundation
import CoreData

@MainActor
final class GameViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [Game] = []
    
    init() {
        container = NSPersistentContainer(name: "GameModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        fetchGames()
    }
    
    func fetchGames() {
        let request = NSFetchRequest<Game>(entityName: "Game")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func addGame(_ game: String) {
        let newGame = Game(context: container.viewContext)
        newGame.title = game
        
        saveData()
    }
    
    func editGame(entity: Game, newTitle: String) {
        entity.title = newTitle
        
        saveData()
    }
    
    func deleteGame(_ game: Game) {
        container.viewContext.delete(game)
        saveData()
    }
    
    func updateGameTime(game: Game, seconds: Int32) {
        game.seconds = seconds
        
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchGames()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func handleButtonAction(sheetModel: GameSheetModel, gameTitle: String, dismiss: () -> Void) {
        switch sheetModel.buttonType {
        case .add:
            if !gameTitle.isEmpty {
                addGame(gameTitle)
                dismiss()
            }
        case .edit:
            if let game = sheetModel.game, !gameTitle.isEmpty {
                editGame(entity: game, newTitle: gameTitle)
                dismiss()
            }
        }
    }
}
