//
//  PresetModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 28.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Firestore representation of a single timer preset
struct TimePresetFirestore: Codable, Identifiable, Equatable {
    let id: String
    let seconds: Int
    
    // Designated initializer
    init(id: String = UUID().uuidString, seconds: Int) {
        self.id = id
        self.seconds = seconds
    }
    
    // Maps Swift properties to Firestore field names
    enum CodingKeys: String, CodingKey {
        case id = "preset_id"
        case seconds = "preset_seconds"
    }
}

// Provides real‑time sync and CRUD operations for presets of a specific game
final class GamePresetManager {
    // Singleton instance
    static let shared = GamePresetManager()
    // Reactive cache powering the UI
    @Published var gamePresets: [TimePresetFirestore] = []
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    private init() { }
    
    // Firestore path helpers
    private func presetCollection(forGameId gameId: String) -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("games").document(gameId).collection("presets")
    }
    
    // Returns reference to a single preset document
    private func presetDocument(forGameId gameId: String, presetId: String) -> DocumentReference? {
        guard let collection = presetCollection(forGameId: gameId) else { return nil }
        return collection.document(presetId)
    }
    
    // Real‑time updates
    func startListeningToPresets(forGameId gameId: String) {
        guard let collection = presetCollection(forGameId: gameId) else {
            print("Error: Invalid game ID or user is not authenticated.")
            return
        }
        
        listener = collection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error listening to preset changes: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents in presets collection.")
                self?.gamePresets = []
                return
            }
            
            self?.gamePresets = documents.compactMap { doc -> TimePresetFirestore? in
                let data = doc.data()
                return self?.parsePreset(from: data)
            }
        }
    }
    
    // Detaches the listener
    func stopListeningToPresets() {
        listener?.remove()
        listener = nil
    }
    
    // Safely converts Firestore data into a `TimePresetFirestore` instance
    private func parsePreset(from data: [String: Any]) -> TimePresetFirestore? {
        guard
            let id = data[TimePresetFirestore.CodingKeys.id.rawValue] as? String,
            let seconds = data[TimePresetFirestore.CodingKeys.seconds.rawValue] as? Int
        else {
            return nil
        }
        
        return TimePresetFirestore(id: id, seconds: seconds)
    }
    
    // Converts a preset into a Firestore dictionary
    private func createPresetData(from preset: TimePresetFirestore) -> [String: Any] {
        [
            TimePresetFirestore.CodingKeys.id.rawValue: preset.id,
            TimePresetFirestore.CodingKeys.seconds.rawValue: preset.seconds
        ]
    }
    
    // CRUD
    func addPreset(forGameId gameId: String, seconds: Int) async throws {
        guard let collection = presetCollection(forGameId: gameId) else {
            throw NSError(domain: "GamePresetManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid game ID or user is not authenticated."])
        }
        
        let newPreset = TimePresetFirestore(seconds: seconds)
        let presetData = createPresetData(from: newPreset)
        
        do {
            let snapshot = try await collection.getDocuments()
            let existingPresets = snapshot.documents.compactMap { doc -> TimePresetFirestore? in
                parsePreset(from: doc.data())
            }
            
            if existingPresets.contains(where: { $0.seconds == seconds }) {
                print("Preset with \(seconds) seconds already exists for game \(gameId).")
                return
            }
            
            try await collection.document(newPreset.id).setData(presetData)
            print("Preset successfully added with ID: \(newPreset.id)")
        } catch {
            print("Error adding preset: \(error)")
            throw error
        }
    }
    
    // Deletes a preset document
    func deletePreset(forGameId gameId: String, presetId: String) async throws {
        guard let presetDoc = presetDocument(forGameId: gameId, presetId: presetId) else {
            throw NSError(domain: "GamePresetManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid preset document reference."])
        }
        
        do {
            try await presetDoc.delete()
            print("Preset with ID \(presetId) deleted successfully.")
        } catch {
            print("Error deleting preset: \(error)")
            throw error
        }
    }
}
