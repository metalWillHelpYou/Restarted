//
//  Habit.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id: UUID
    let title: String
    let imageName: String
    
//    let description: String?
//    let frequency: String?
    
    init(id: UUID = UUID(), title: String, imageName: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
//        self.description = description
//        self.frequency = frequency
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageName
        case description
        case frequency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.imageName = try container.decode(String.self, forKey: .imageName)
//        self.description = try container.decodeIfPresent(String.self, forKey: .description)
//        self.frequency = try container.decodeIfPresent(String.self, forKey: .frequency)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(imageName, forKey: .imageName)
//        try container.encode(description, forKey: .description)
//        try container.encode(frequency, forKey: .frequency)
    }
}

enum UnitOfMeasure: String, CaseIterable, Identifiable {
    case m = "m"
    case km = "km"
    case sec = "sec"
    case min = "min"
    case hr = "hr"
    
    var id: String { self.rawValue }
}
