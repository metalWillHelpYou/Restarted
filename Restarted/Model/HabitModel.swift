//
//  HabitModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct HabitFirestore: Codable, Identifiable, Equatable {
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
        case id = "habit_id"
        case title = "habit_title"
        case dateAdded = "habit_date"
        case streak = "streak"
        case seconds = "seconds"
        case sessionCount = "session_count"
    }
}

final class HabitManager {
    static let shared = HabitManager()
    private init() { }
    
    private let db = Firestore.firestore()
    var habits: [HabitFirestore] = []
    
    private func userHabitCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        
        return db.collection("users").document(userId).collection("habits")
    }
    
    private func habitDocument(habitId: String) -> DocumentReference? {
        guard let habitCollection = userHabitCollection() else { return nil }
        return habitCollection.document(habitId)
    }
    
    func fetchHabits() async -> [HabitFirestore] {
        guard let habitCollection = userHabitCollection() else { return [] }
        
        do {
            let snapshot = try await habitCollection.getDocuments()
            let habits = snapshot.documents.compactMap { doc -> HabitFirestore? in
                let data = doc.data()
                return parseHabit(from: data)
            }
            self.habits = habits
            return habits
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    private func parseHabit(from data: [String: Any]) -> HabitFirestore? {
        guard
            let id = data[HabitFirestore.CodingKeys.id.rawValue] as? String,
            let title = data[HabitFirestore.CodingKeys.title.rawValue] as? String,
            let dateAdded = (data[HabitFirestore.CodingKeys.dateAdded.rawValue] as? Timestamp)?.dateValue()
        else {
            return nil
        }
        
        let streak = data[HabitFirestore.CodingKeys.streak.rawValue] as? Int ?? 0
        let seconds = data[HabitFirestore.CodingKeys.seconds.rawValue] as? Int ?? 0
        let sessionCount = data[HabitFirestore.CodingKeys.sessionCount.rawValue] as? Int ?? 1
        
        return HabitFirestore(id: id, title: title, dateAdded: dateAdded, streak: streak, seconds: seconds, sessionCount: sessionCount)
    }
    
    func addHabit(title: String) async throws -> [HabitFirestore] {
        guard let habitCollection = userHabitCollection() else {
            throw NSError(domain: "HabitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }

        let newHabitId = UUID().uuidString
        let newHabit = HabitFirestore(id: newHabitId, title: title, dateAdded: Date(), streak: 0, seconds: 0, sessionCount: 0)
        let habitData = createHabitData(from: newHabit)

        do {
            let snapshot = try await habitCollection.getDocuments()
            if snapshot.isEmpty {
                print("Creating habits collection for user...")
            }

            try await habitCollection.document(newHabitId).setData(habitData)
            print("Habit successfully added with ID: \(newHabitId)")
            
            return await fetchHabits()
        } catch {
            print("Error adding habit: \(error)")
            throw error
        }
    }

    private func createHabitData(from habit: HabitFirestore) -> [String: Any] {
        [
            HabitFirestore.CodingKeys.id.rawValue: habit.id,
            HabitFirestore.CodingKeys.title.rawValue: habit.title,
            HabitFirestore.CodingKeys.dateAdded.rawValue: habit.dateAdded ?? Date(),
            HabitFirestore.CodingKeys.streak.rawValue: habit.streak,
            HabitFirestore.CodingKeys.seconds.rawValue: habit.seconds,
            HabitFirestore.CodingKeys.sessionCount.rawValue: habit.sessionCount
        ]
    }

    
    func editHabit(habitId: String, title: String) async throws {
        guard habitDocument(habitId: habitId) != nil else {
            print("Error: Unable to get reference to user habit document.")
            throw URLError(.badURL)
        }
        
        try await updateHabitField(
            habitId: habitId,
            field: HabitFirestore.CodingKeys.title.rawValue,
            value: title
        )
    }
    
    func deleteHabit(habitId: String) async throws {
        guard habitDocument(habitId: habitId) != nil else {
            print("Error: Unable to get reference to user habit document.")
            throw URLError(.badURL)
        }
        
        try await habitDocument(habitId: habitId)?.delete()
        print("Habit with ID \(habitId) deleted successfully.")
    }
    
    func updateHabitTime(for habitId: String, elapsedTime: Int) async throws {
            guard let habitDoc = habitDocument(habitId: habitId) else {
                throw NSError(domain: "HabitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid habit document reference."])
            }

            do {
                let document = try await habitDoc.getDocument()
                guard let data = document.data() else {
                    throw NSError(domain: "HabitManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit data not found."])
                }

                if let existingSeconds = data["seconds"] as? Int {
                    let updatedSeconds = existingSeconds + elapsedTime
                    try await habitDoc.updateData(["seconds": updatedSeconds])
                    print("Habit time updated to \(updatedSeconds) seconds.")
                } else {
                    throw NSError(domain: "HabitManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid format for seconds field."])
                }
            } catch {
                print("Failed to update habit time: \(error)")
                throw error
            }
        }

        func incrementSessionCount(for habitId: String) async throws {
            guard let habitDoc = habitDocument(habitId: habitId) else {
                throw NSError(domain: "HabitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid habit document reference."])
            }

            do {
                let document = try await habitDoc.getDocument()
                guard let data = document.data() else {
                    throw NSError(domain: "HabitManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit data not found."])
                }

                let currentSessions = data["sessionCount"] as? Int ?? 0
                try await habitDoc.updateData(["sessionCount": currentSessions + 1])
                print("Incremented session count for habit ID: \(habitId)")
            } catch {
                print("Failed to increment session count: \(error)")
                throw error
            }
        }
    
    
    private func updateHabitField(habitId: String, field: String, value: Any) async throws {
        guard userHabitCollection() != nil else {
            throw NSError(domain: "HabitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }
        
        guard let habitDoc = habitDocument(habitId: habitId) else {
            throw NSError(domain: "HabitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid habit document reference."])
        }
        
        let data: [String: Any] = [field: value]
        try await habitDoc.updateData(data)
    }
}
