//
//  PracticeModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
    
    enum CodingKeys: String, CodingKey {
        case id = "practice_id"
        case title = "practice_title"
        case dateAdded = "practice_date"
        case streak = "streak"
        case seconds = "seconds"
        case sessionCount = "session_count"
    }
}

final class PracticeManager {
    static let shared = PracticeManager()
    private init() { }
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var practices: [Practice] = [] {
        didSet {
            NotificationCenter.default.post(name: .practicesDidChange, object: nil)
        }
    }
    
    // MARK: - Firestore references
    
    private func userPracticeCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("practices")
    }
    
    private func practiceDocument(practiceId: String) -> DocumentReference? {
        guard let practiceCollection = userPracticeCollection() else { return nil }
        return practiceCollection.document(practiceId)
    }
    
    // MARK: - Реальное время (наблюдение за изменениями)
    
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
    
    func stopObservingPractices() {
        listener?.remove()
        listener = nil
    }
    
    // MARK: - CRUD
    
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
                print("Creating practices collection for user...")
            }
            
            try await practiceCollection.document(newPracticeId).setData(practiceData)
            print("Practice successfully added with ID: \(newPracticeId)")
        } catch {
            print("Error adding practice: \(error)")
            throw error
        }
    }
    
    func editPractice(practiceId: String, title: String) async throws {
        guard let _ = practiceDocument(practiceId: practiceId) else {
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
        guard let _ = practiceDocument(practiceId: practiceId) else {
            print("Error: Unable to get reference to user practice document.")
            throw URLError(.badURL)
        }
        
        try await practiceDocument(practiceId: practiceId)?.delete()
        print("Practice with ID \(practiceId) deleted successfully.")
    }
    
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
    
    func sumSecondsForUserPractices() async throws -> Int {
        guard let collection = userPracticeCollection() else {
            throw NSError(domain: "AppError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"])
        }
        
        let snapshot = try await collection.getDocuments()
        let documents = snapshot.documents
        
        let totalSeconds = documents.reduce(0) { partialSum, document in
            let seconds = document.data()[Practice.CodingKeys.seconds.rawValue] as? Int ?? 0
            return partialSum + seconds
        }
        
        return totalSeconds
    }
    
    // MARK: - Вспомогательные методы (encode/decode)
    
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
    
    private func updatePracticeField(practiceId: String, field: String, value: Any) async throws {
        guard let practiceDoc = practiceDocument(practiceId: practiceId) else {
            throw NSError(domain: "PracticeManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid practice document reference."])
        }
        
        let data: [String: Any] = [field: value]
        try await practiceDoc.updateData(data)
    }
}
