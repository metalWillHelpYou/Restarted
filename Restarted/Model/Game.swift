//
//  Game.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.05.2024.
//

import Foundation

class Game {
    var title: String
//    var genre: String
    
    init(title: String) {
        self.title = title
//        self.genre = genre
    }
}

enum Genre: String, CaseIterable {
    case action = "Action"
    case adventure = "Adventure"
    case rpg = "RPG"
    case simulator = "Simulator"
    case strategy = "Strategy"
}
