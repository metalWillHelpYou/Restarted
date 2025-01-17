//
//  PresetModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 28.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TimePresetFirestore: Codable, Identifiable, Equatable {
    let id: String
    let seconds: Int
    
    init(id: String = UUID().uuidString, seconds: Int) {
        self.id = id
        self.seconds = seconds
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "preset_id"
        case seconds = "preset_seconds"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.seconds, forKey: .seconds)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.seconds = try container.decode(Int.self, forKey: .seconds)
    }
}


final class GamePresetManager {
    static let shared = GamePresetManager()
    private init() { }
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    var gamePresets: [TimePresetFirestore] = [] {
        didSet {
            NotificationCenter.default.post(name: .gamePresetsDidChange, object: nil)
        }
    }
    
    private func presetDocument(forGameId gameId: String, presetId: String) -> DocumentReference? {
        guard let presetCollection = presetCollection(forGameId: gameId) else { return nil }
        return presetCollection.document(presetId)
    }
    
    private func presetCollection(forGameId gameId: String) -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("games").document(gameId).collection("presets")
    }
    
    func startListeningToPresets(forGameId gameId: String) {
        guard let collection = presetCollection(forGameId: gameId) else {
            print("Error: Invalid game ID or user is not authenticated.")
            return
        }
        
        // Устанавливаем слушатель
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
    
    func stopListeningToPresets() {
        listener?.remove()
        listener = nil
    }
    
    private func parsePreset(from data: [String: Any]) -> TimePresetFirestore? {
        guard
            let id = data[TimePresetFirestore.CodingKeys.id.rawValue] as? String,
            let seconds = data[TimePresetFirestore.CodingKeys.seconds.rawValue] as? Int
        else {
            return nil
        }
        
        return TimePresetFirestore(id: id, seconds: seconds)
    }
    
    func addPreset(forGameId gameId: String, seconds: Int) async throws {
        guard let presetCollection = presetCollection(forGameId: gameId) else {
            throw NSError(domain: "GamePresetManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid game ID or user is not authenticated."])
        }
        
        let newPreset = TimePresetFirestore(seconds: seconds)
        let presetData = createPresetData(from: newPreset)
        
        do {
            let snapshot = try await presetCollection.getDocuments()
            let existingPresets = snapshot.documents.compactMap { doc -> TimePresetFirestore? in
                let data = doc.data()
                return parsePreset(from: data)
            }

            if existingPresets.contains(where: { $0.seconds == seconds }) {
                print("Preset with \(seconds) seconds already exists for game \(gameId).")
                return
            }
            
            try await presetCollection.document(newPreset.id).setData(presetData)
            print("Preset successfully added with ID: \(newPreset.id)")
        } catch {
            print("Error adding preset: \(error)")
            throw error
        }
    }
    
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
    
    private func createPresetData(from preset: TimePresetFirestore) -> [String: Any] {
        [
            TimePresetFirestore.CodingKeys.id.rawValue: preset.id,
            TimePresetFirestore.CodingKeys.seconds.rawValue: preset.seconds
        ]
    }
}
