//
//  GameModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Firestore representation of a single game
struct GameFirestore: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let seconds: Int
    let dateAdded: Date?
    let sessionCount: Int
    
    // Designated initializer
    init(
        id: String,
        title: String,
        seconds: Int,
        dateAdded: Date?,
        sessionCount: Int
    ) {
        self.id = id
        self.title = title
        self.seconds = seconds
        self.dateAdded = dateAdded
        self.sessionCount = sessionCount
    }
    
    // Maps Swift properties to Firestore fields.
    enum CodingKeys: String, CodingKey {
        case id = "game_id"
        case title = "game_title"
        case seconds
        case dateAdded = "date_game_added"
        case sessionCount = "session_count"
    }
}

// Manages real-time synchronization and CRUD operations for the user's games
final class GameManager {
    // Singleton instance
    static let shared = GameManager()
    // Reactive cache that drives UI updates
    @Published var games: [GameFirestore] = []
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    private init() { }
    
    // Firestore path helpers
    private func userGameCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        
        return db.collection("users").document(userId).collection("games")
    }
    
    // Returns reference to a single game document
    private func gameDocument(gameId: String) -> DocumentReference? {
        guard let gameCollection = userGameCollection() else { return nil }
        return gameCollection.document(gameId)
    }
    
    // Real-time updates
    func startListeningToGames() {
        guard let gameCollection = userGameCollection() else {
            print("Error: User is not authenticated or collection is unavailable.")
            return
        }
        
        listener = gameCollection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error listening to game changes: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents in games collection.")
                self?.games = []
                return
            }
            
            self?.games = documents.compactMap { doc -> GameFirestore? in
                let data = doc.data()
                return self?.parseGame(from: data)
            }
        }
    }
    
    // Detaches the snapshot listener
    func stopListeningToGames() {
        listener?.remove()
        listener = nil
    }
    
    // Safely converts Firestore data into a `GameFirestore` instance
    private func parseGame(from data: [String: Any]) -> GameFirestore? {
        guard
            let id = data[GameFirestore.CodingKeys.id.rawValue] as? String,
            let title = data[GameFirestore.CodingKeys.title.rawValue] as? String,
            let seconds = data[GameFirestore.CodingKeys.seconds.rawValue] as? Int
        else {
            return nil
        }
        
        let dateAdded = (data[GameFirestore.CodingKeys.dateAdded.rawValue] as? Timestamp)?.dateValue()
        let sessionCount = data[GameFirestore.CodingKeys.sessionCount.rawValue] as? Int ?? 0
        
        return GameFirestore(id: id, title: title, seconds: seconds, dateAdded: dateAdded, sessionCount: sessionCount)
    }
    
    // CRUD
    func addGame(withTitle title: String) async throws {
        guard let gameCollection = userGameCollection() else {
            throw NSError(domain: "GameManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }
        
        let newGameId = UUID().uuidString
        let newGame = GameFirestore(id: newGameId, title: title, seconds: 0, dateAdded: Date(), sessionCount: 0)
        let gameData = createGameData(from: newGame)
        
        do {
            try await gameCollection.document(newGameId).setData(gameData)
            print("Game successfully added with ID: \(newGameId)")
        } catch {
            print("Error adding game: \(error)")
            throw error
        }
    }
    
    // Converts a `GameFirestore` instance into a Firestore dictionary
    private func createGameData(from game: GameFirestore) -> [String: Any] {
        [
            GameFirestore.CodingKeys.id.rawValue: game.id,
            GameFirestore.CodingKeys.title.rawValue: game.title,
            GameFirestore.CodingKeys.seconds.rawValue: game.seconds,
            GameFirestore.CodingKeys.dateAdded.rawValue: game.dateAdded.map { Timestamp(date: $0) } ?? FieldValue.serverTimestamp(),
            GameFirestore.CodingKeys.sessionCount.rawValue: game.sessionCount
        ]
    }
    
    // Updates the title field of an existing game
    func editGame(gameId: String, title: String) async throws {
        guard gameDocument(gameId: gameId) != nil else {
            print("Error: Unable to get reference to user game document.")
            throw URLError(.badURL)
        }
        
        try await updateGameField(
            gameId: gameId,
            field: GameFirestore.CodingKeys.title.rawValue,
            value: title
        )
    }
    
    // Adds `elapsedTime` seconds to the stored time
    func updateGameTime(for gameId: String, elapsedTime: Int) async throws {
        guard let gameDoc = gameDocument(gameId: gameId) else {
            throw NSError(domain: "GameManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid game document reference."])
        }
        
        do {
            let document = try await gameDoc.getDocument()
            guard let data = document.data() else {
                throw NSError(domain: "GameManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Game data not found."])
            }
            
            if let existingSeconds = data[GameFirestore.CodingKeys.seconds.rawValue] as? Int {
                let updatedSeconds = existingSeconds + elapsedTime
                try await updateGameField(gameId: gameId, field: GameFirestore.CodingKeys.seconds.rawValue, value: updatedSeconds)
                print("Updated game time successfully for game ID: \(gameId)")
            } else {
                throw NSError(domain: "GameManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid format for seconds field."])
            }
        } catch {
            print("Failed to update game time: \(error)")
            throw error
        }
    }
    
    // Increments the session counter for a game
    func incrementSessionCount(for gameId: String) async throws {
        guard let gameDoc = gameDocument(gameId: gameId) else {
            throw NSError(domain: "GameManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid game document reference."])
        }
        
        do {
            let document = try await gameDoc.getDocument()
            guard let data = document.data() else {
                throw NSError(domain: "GameManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Game data not found."])
            }
            
            let currentCount = data[GameFirestore.CodingKeys.sessionCount.rawValue] as? Int ?? 0
            let newCount = currentCount + 1
            
            try await updateGameField(gameId: gameId, field: GameFirestore.CodingKeys.sessionCount.rawValue, value: newCount)
            print("Incremented session count successfully for game ID: \(gameId)")
        } catch {
            print("Failed to increment session count: \(error)")
            throw error
        }
    }
    
    // Deletes a game document
    func deleteGame(gameId: String) async throws {
        guard gameDocument(gameId: gameId) != nil else {
            print("Error: Unable to get reference to user game document.")
            throw URLError(.badURL)
        }
        
        try await gameDocument(gameId: gameId)?.delete()
        print("Game with ID \(gameId) deleted successfully.")
    }
    
    // Generic wrapper around `updateData` for single-field updates
    private func updateGameField(gameId: String, field: String, value: Any) async throws {
        guard let gameDoc = gameDocument(gameId: gameId) else {
            throw NSError(domain: "GameManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid game document reference."])
        }
        
        let data: [String: Any] = [field: value]
        try await gameDoc.updateData(data)
    }
    
    // Returns total seconds accumulated across all user's games
    func sumSecondsForUserGames() async throws -> Int {
        guard let collection = userGameCollection() else {
            throw NSError(domain: "AppError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"])
        }
        
        let snapshot = try await collection.getDocuments()
        let documents = snapshot.documents
        
        let totalSeconds = documents.reduce(0) { partialSum, document in
            let seconds = document.data()["seconds"] as? Int ?? 0
            return partialSum + seconds
        }
        
        return totalSeconds
    }
}
