//
//  GameModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct GameFirestore: Codable, Identifiable {
    let id: String
    let title: String
    let seconds: Int
    let dateAdded: Date?
    
    init(
        id: String,
        title: String,
        seconds: Int,
        dateAdded: Date?
    ) {
        self.id = id
        self.title = title
        self.seconds = seconds
        self.dateAdded = dateAdded
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "game_id"
        case title = "game_title"
        case seconds = "seconds"
        case dateAdded = "date_game_added"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.seconds, forKey: .seconds)
        try container.encodeIfPresent(self.dateAdded, forKey: .dateAdded)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.seconds = try container.decode(Int.self, forKey: .seconds)
        self.dateAdded = try container.decodeIfPresent(Date.self, forKey: .dateAdded)
    }
}

final class GameManager {
    static let shared = GameManager()
    private init() { }
    
    private let db = Firestore.firestore()
    var games: [GameFirestore] = []
    
    private func userGameCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        
        return db.collection("users").document(userId).collection("games")
    }
    
    private func gameDocument(gameId: String) -> DocumentReference? {
        guard let gameCollection = userGameCollection() else { return nil }
        return gameCollection.document(gameId)
    }
    
    func fetchGames() async -> [GameFirestore] {
        guard let gameCollection = userGameCollection() else { return [] }
        
        do {
            let snapshot = try await gameCollection.getDocuments()
            let games = snapshot.documents.compactMap { doc -> GameFirestore? in
                guard let jsonData = try? JSONSerialization.data(withJSONObject: doc.data()) else { return nil }
                return try? JSONDecoder().decode(GameFirestore.self, from: jsonData)
            }
            self.games = games
            return games
        } catch {
            print("Error loading or parsing user games: \(error)")
            return []
        }
    }
    
    func addGame(withTitle title: String) async throws -> [GameFirestore] {
        guard let gameCollection = userGameCollection() else {
            throw NSError(domain: "GameManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }

        let newGameId = UUID().uuidString
        let newGame = GameFirestore(
            id: newGameId,
            title: title,
            seconds: 0,
            dateAdded: Date()
        )

        do {
            let jsonData = try JSONEncoder().encode(newGame)
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                throw NSError(domain: "GameManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert game to dictionary."])
            }

            try await gameCollection.document(newGameId).setData(jsonDict)
            print("Game successfully added with ID: \(newGameId)")
            
            return await fetchGames()
        } catch {
            print("Error adding game: \(error)")
            throw error
        }
    }
    
    func editGame(gameId: String, title: String) async throws {
        guard let gameDocument = gameDocument(gameId: gameId) else {
            print("Error: Unable to get reference to user game document.")
            throw URLError(.badURL)
        }
        
        try await updateGameField(
            gameId: gameId,
            field: GameFirestore.CodingKeys.title.rawValue,
            value: title)
    }
    
    private func updateGameField(gameId: String, field: String, value: Any) async throws {
        guard let gameDoc = gameDocument(gameId: gameId) else {
            throw NSError(domain: "GameManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid game document reference."])
        }
        
        let data: [String: Any] = [field: value]
        try await gameDoc.updateData(data)
    }
}
