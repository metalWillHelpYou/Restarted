//
//  Game.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.05.2024.
//

import Foundation
import SwiftData

struct GameUD: Identifiable, Codable, Equatable {
    var title: String
    var genre: Genre
    
    var id: String {
        title
    }
}

enum Genre: String, CaseIterable, Identifiable, Codable {
    case action = "Action"
    case adventure = "Adventure"
    case rpg = "RPG"
    case simulator = "Simulator"
    case strategy = "Strategy"
    
    var id: String { self.rawValue }
}

extension UserDefaults {
    private enum Keys {
        static let games = "games"
    }
    
    func saveGames(_ games: [GameUD]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(games) {
            set(encoded, forKey: Keys.games)
        }
    }
    
    func loadGames() -> [GameUD] {
        if let savedGames = data(forKey: Keys.games) {
            let decoder = JSONDecoder()
            if let loadedGames = try? decoder.decode([GameUD].self, from: savedGames) {
                return loadedGames
            }
        }
        return []
    }
}
