//
//  Game.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.05.2024.
//

import Foundation

struct Game: Identifiable, Codable {
    var id: UUID
    let title: String
    let imageName: String
    
    init(id: UUID = UUID(), title: String, imageName: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.imageName = try container.decode(String.self, forKey: .imageName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(imageName, forKey: .imageName)
    }
}
