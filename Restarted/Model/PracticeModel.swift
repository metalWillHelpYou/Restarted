//
//  PracticeModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Encapsulates a single user practice stored in Firestore
struct Practice: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let dateAdded: Date?
    var streak: Int
    var seconds: Int
    var sessionCount: Int
    
    init(
        id: String,
        title: String,
        dateAdded: Date,
        streak: Int,
        seconds: Int,
        sessionCount: Int
    ) {
        self.id = id
        self.title = title
        self.dateAdded = dateAdded
        self.streak = streak
        self.seconds = seconds
        self.sessionCount = sessionCount
    }
    
    // Maps Swift property names to Firestore field keys
    enum CodingKeys: String, CodingKey {
        case id = "practice_id"
        case title = "practice_title"
        case dateAdded = "practice_date"
        case streak
        case seconds
        case sessionCount = "session_count"
    }
}

// Provides real-time synchronisation and CRUD operations for the current user's practices
final class PracticeManager: ObservableObject {
    // Singleton accessor
    static let shared = PracticeManager()
    // Local cache that drives UI updates
    @Published var practices: [Practice] = []
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    private init() { }
    
    // Firestore path helpers
    private func userPracticeCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("practices")
    }
    
    // Returns a reference to a single practice document within the user's collection
    private func practiceDocument(practiceId: String) -> DocumentReference? {
        guard let practiceCollection = userPracticeCollection() else { return nil }
        return practiceCollection.document(practiceId)
    }
    
    // Real-time updates
    func startObservingPractices() {
        guard let practiceCollection = userPracticeCollection() else {
            print("Error: User is not authenticated or collection is unavailable.")
            return
        }
        
        listener = practiceCollection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error listening to practice changes: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents in practices collection.")
                self?.practices = []
                return
            }
            
            self?.practices = documents.compactMap { doc -> Practice? in
                let data = doc.data()
                return self?.decodePractice(from: data)
            }
        }
    }
    
    // Detaches the Firestore snapshot listener
    func stopObservingPractices() {
        listener?.remove()
        listener = nil
    }
    
    // CRUD
    func addPractice(title: String) async throws {
        guard let practiceCollection = userPracticeCollection() else {
            throw NSError(domain: "PracticeManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }
        
        let newPracticeId = UUID().uuidString
        let newPractice = Practice(
            id: newPracticeId,
            title: title,
            dateAdded: Date(),
            streak: 0,
            seconds: 0,
            sessionCount: 0
        )
        
        let practiceData = encodePractice(newPractice)
        
        do {
            let snapshot = try await practiceCollection.getDocuments()
            if snapshot.isEmpty {
                print("Creating practices collection for user…")
            }
            
            try await practiceCollection.document(newPracticeId).setData(practiceData)
            print("Practice successfully added with ID: \(newPracticeId)")
        } catch {
            print("Error adding practice: \(error)")
            throw error
        }
    }
    
    func editPractice(practiceId: String, title: String) async throws {
        guard practiceDocument(practiceId: practiceId) != nil else {
            print("Error: Unable to get reference to user practice document.")
            throw URLError(.badURL)
        }
        
        try await updatePracticeField(
            practiceId: practiceId,
            field: Practice.CodingKeys.title.rawValue,
            value: title
        )
    }
    
    func deletePractice(practiceId: String) async throws {
        guard practiceDocument(practiceId: practiceId) != nil else {
            print("Error: Unable to get reference to user practice document.")
            throw URLError(.badURL)
        }
        
        try await practiceDocument(practiceId: practiceId)?.delete()
        print("Practice with ID \(practiceId) deleted successfully.")
    }
    
    // Adds `elapsedTime` to the stored seconds counter for a practice
    func updatePracticeTime(for practiceId: String, elapsedTime: Int) async throws {
        guard let practiceDoc = practiceDocument(practiceId: practiceId) else {
            throw NSError(domain: "PracticeManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid practice document reference."])
        }
        
        do {
            let document = try await practiceDoc.getDocument()
            guard let data = document.data() else {
                throw NSError(domain: "PracticeManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Practice data not found."])
            }
            
            if let existingSeconds = data[Practice.CodingKeys.seconds.rawValue] as? Int {
                let updatedSeconds = existingSeconds + elapsedTime
                try await practiceDoc.updateData([Practice.CodingKeys.seconds.rawValue: updatedSeconds])
                print("Practice time updated to \(updatedSeconds) seconds.")
            } else {
                throw NSError(domain: "PracticeManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid format for seconds field."])
            }
        } catch {
            print("Failed to update practice time: \(error)")
            throw error
        }
    }
    
    // Increments the session counter for a practice
    func incrementSessionCount(for practiceId: String) async throws {
        guard let practiceDoc = practiceDocument(practiceId: practiceId) else {
            throw NSError(domain: "PracticeManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid practice document reference."])
        }
        
        do {
            let document = try await practiceDoc.getDocument()
            guard let data = document.data() else {
                throw NSError(domain: "PracticeManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Practice data not found."])
            }
            
            let currentSessions = data[Practice.CodingKeys.sessionCount.rawValue] as? Int ?? 0
            try await practiceDoc.updateData([
                Practice.CodingKeys.sessionCount.rawValue: currentSessions + 1
            ])
            print("Incremented session count for practice ID: \(practiceId)")
        } catch {
            print("Failed to increment session count: \(error)")
            throw error
        }
    }
    
    // Returns the total seconds accumulated across all practices for the user
    func sumSecondsForUserPractices() async throws -> Int {
        guard let collection = userPracticeCollection() else {
            throw NSError(domain: "AppError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"])
        }
        
        let snapshot = try await collection.getDocuments()
        let documents = snapshot.documents
        
        let totalSeconds = documents.reduce(0) { partial, document in
            let seconds = document.data()[Practice.CodingKeys.seconds.rawValue] as? Int ?? 0
            return partial + seconds
        }
        
        return totalSeconds
    }
    
    // Safely converts Firestore data into a `Practice` instance
    private func decodePractice(from data: [String: Any]) -> Practice? {
        guard
            let id = data[Practice.CodingKeys.id.rawValue] as? String,
            let title = data[Practice.CodingKeys.title.rawValue] as? String,
            let dateAdded = (data[Practice.CodingKeys.dateAdded.rawValue] as? Timestamp)?.dateValue()
        else {
            return nil
        }
        
        let streak = data[Practice.CodingKeys.streak.rawValue] as? Int ?? 0
        let seconds = data[Practice.CodingKeys.seconds.rawValue] as? Int ?? 0
        let sessionCount = data[Practice.CodingKeys.sessionCount.rawValue] as? Int ?? 1
        
        return Practice(
            id: id,
            title: title,
            dateAdded: dateAdded,
            streak: streak,
            seconds: seconds,
            sessionCount: sessionCount
        )
    }
    
    // Converts a `Practice` instance into a Firestore dictionary
    private func encodePractice(_ practice: Practice) -> [String: Any] {
        [
            Practice.CodingKeys.id.rawValue: practice.id,
            Practice.CodingKeys.title.rawValue: practice.title,
            Practice.CodingKeys.dateAdded.rawValue: practice.dateAdded ?? Date(),
            Practice.CodingKeys.streak.rawValue: practice.streak,
            Practice.CodingKeys.seconds.rawValue: practice.seconds,
            Practice.CodingKeys.sessionCount.rawValue: practice.sessionCount
        ]
    }
    
    // Generic wrapper around `updateData` for single-field updates
    private func updatePracticeField(practiceId: String, field: String, value: Any) async throws {
        guard let practiceDoc = practiceDocument(practiceId: practiceId) else {
            throw NSError(domain: "PracticeManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid practice document reference."])
        }
        
        try await practiceDoc.updateData([field: value])
    }
}
