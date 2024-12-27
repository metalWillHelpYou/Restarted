//
//  GameModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct GameFirestore: Codable, Identifiable, Equatable {
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
                let data = doc.data()
                return parseGame(from: data)
            }
            self.games = games
            return games
        } catch {
            print("Error fetching games: \(error)")
            return []
        }
    }

    private func parseGame(from data: [String: Any]) -> GameFirestore? {
        guard
            let id = data[GameFirestore.CodingKeys.id.rawValue] as? String,
            let title = data[GameFirestore.CodingKeys.title.rawValue] as? String,
            let seconds = data[GameFirestore.CodingKeys.seconds.rawValue] as? Int
        else {
            return nil
        }
        
        let dateAdded = (data[GameFirestore.CodingKeys.dateAdded.rawValue] as? Timestamp)?.dateValue()
        return GameFirestore(id: id, title: title, seconds: seconds, dateAdded: dateAdded)
    }

    func addGame(withTitle title: String) async throws -> [GameFirestore] {
        guard let gameCollection = userGameCollection() else {
            throw NSError(domain: "GameManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }

        let newGameId = UUID().uuidString
        let newGame = GameFirestore(id: newGameId, title: title, seconds: 0, dateAdded: Date())
        let gameData = createGameData(from: newGame)

        do {
            let snapshot = try await gameCollection.getDocuments()
            if snapshot.isEmpty {
                print("Creating games collection for user...")
            }

            try await gameCollection.document(newGameId).setData(gameData)
            print("Game successfully added with ID: \(newGameId)")
            
            return await fetchGames()
        } catch {
            print("Error adding game: \(error)")
            throw error
        }
    }

    private func createGameData(from game: GameFirestore) -> [String: Any] {
        [
            GameFirestore.CodingKeys.id.rawValue: game.id,
            GameFirestore.CodingKeys.title.rawValue: game.title,
            GameFirestore.CodingKeys.seconds.rawValue: game.seconds,
            GameFirestore.CodingKeys.dateAdded.rawValue: game.dateAdded.map { Timestamp(date: $0) } ?? FieldValue.serverTimestamp()
        ]
    }
    
    func editGame(gameId: String, title: String) async throws {
        guard gameDocument(gameId: gameId) != nil else {
            print("Error: Unable to get reference to user game document.")
            throw URLError(.badURL)
        }
        
        try await updateGameField(
            gameId: gameId,
            field: GameFirestore.CodingKeys.title.rawValue,
            value: title)
    }
    
    func deleteGame(gameId: String) async throws {
        guard gameDocument(gameId: gameId) != nil else {
            print("Error: Unable to get reference to user game document.")
            throw URLError(.badURL)
        }
        
        try await gameDocument(gameId: gameId)?.delete()
        print("Game with ID \(gameId) deleted successfully.")
    }
    
    private func updateGameField(gameId: String, field: String, value: Any) async throws {
        guard let gameDoc = gameDocument(gameId: gameId) else {
            throw NSError(domain: "GameManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid game document reference."])
        }
        
        let data: [String: Any] = [field: value]
        try await gameDoc.updateData(data)
    }
}
