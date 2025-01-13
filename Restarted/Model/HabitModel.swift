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
    let isActive: Bool
    let isCompleted: Bool
    var streak: Int
    var amountOfComletion: Int
    var time: Int

    init(
        id: String,
        title: String,
        dateAdded: Date,
        isActive: Bool,
        isCompleted: Bool,
        streak: Int,
        amountOfComletion: Int,
        time: Int
    ) {
        self.id = id
        self.title = title
        self.dateAdded = dateAdded
        self.isActive = isActive
        self.isCompleted = isCompleted
        self.streak = streak
        self.amountOfComletion = amountOfComletion
        self.time = time
    }

    enum CodingKeys: String, CodingKey {
        case id = "habit_id"
        case title = "habit_title"
        case dateAdded = "habit_date"
        case isActive = "is_active"
        case isCompleted = "is_completed"
        case streak = "streak"
        case amountOfComletion = "amount_of_comletion"
        case time = "time"
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.dateAdded, forKey: .dateAdded)
        try container.encodeIfPresent(self.isActive, forKey: .isActive)
        try container.encodeIfPresent(self.isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(self.streak, forKey: .streak)
        try container.encodeIfPresent(self.amountOfComletion, forKey: .amountOfComletion)
        try container.encodeIfPresent(self.time, forKey: .time)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        self.isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
        self.streak = try container.decode(Int.self, forKey: .streak)
        self.amountOfComletion = try container.decode(Int.self, forKey: .amountOfComletion)
        self.time = try container.decodeIfPresent(Int.self, forKey: .time) ?? 0
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
        
        let isActive = data[HabitFirestore.CodingKeys.isActive.rawValue] as? Bool ?? false
        let isCompleted = data[HabitFirestore.CodingKeys.isCompleted.rawValue] as? Bool ?? false
        let streak = data[HabitFirestore.CodingKeys.streak.rawValue] as? Int ?? 0
        let amountOfComletion = data[HabitFirestore.CodingKeys.amountOfComletion.rawValue] as? Int ?? 0
        let time = data[HabitFirestore.CodingKeys.time.rawValue] as? Int ?? 0 // Новый параметр
        
        return HabitFirestore(id: id, title: title, dateAdded: dateAdded, isActive: isActive, isCompleted: isCompleted, streak: streak, amountOfComletion: amountOfComletion, time: time)
    }
    
    func addHabit(title: String) async throws -> [HabitFirestore] {
        guard let habitCollection = userHabitCollection() else {
            throw NSError(domain: "HabitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }

        let newHabitId = UUID().uuidString
        let newHabit = HabitFirestore(id: newHabitId, title: title, dateAdded: Date(), isActive: false, isCompleted: false, streak: 0, amountOfComletion: 0, time: 0)
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
            HabitFirestore.CodingKeys.isActive.rawValue: habit.isActive,
            HabitFirestore.CodingKeys.isCompleted.rawValue: habit.isCompleted,
            HabitFirestore.CodingKeys.streak.rawValue: habit.streak,
            HabitFirestore.CodingKeys.amountOfComletion.rawValue: habit.amountOfComletion,
            HabitFirestore.CodingKeys.time.rawValue: habit.time
        ]
    }

    
    func editHabit(habitId: String, title: String) async throws {
        guard habitDocument(habitId: habitId) != nil else {
            print("Error: Unable to get reference to user habit document.")
            throw URLError(.badURL)
        }
        
        try await updatehabitField(
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
    
    func addHabitToActive(with habitId: String) async throws {
        guard habitDocument(habitId: habitId) != nil else {
            print("Error: Unable to get reference to user habit document.")
            throw URLError(.badURL)
        }
        
        try await updatehabitField(
            habitId: habitId,
            field: HabitFirestore.CodingKeys.isActive.rawValue,
            value: true
        )
    }
    
    func removeHabitFromActive(with habitId: String) async throws {
        guard habitDocument(habitId: habitId) != nil else {
            print("Error: Unable to get reference to user habit document.")
            throw URLError(.badURL)
        }
        
        try await updatehabitField(
            habitId: habitId,
            field: HabitFirestore.CodingKeys.isActive.rawValue,
            value: false
        )
    }
    
    func markAsDone(habitId: String) async throws {
        guard let habitDoc = habitDocument(habitId: habitId) else {
            throw NSError(domain: "HabitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid habit document reference."])
        }
        
        do {
            let document = try await habitDoc.getDocument()
            guard let data = document.data() else {
                throw NSError(domain: "HabitManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit data not found."])
            }
            
            let currentAmount = data[HabitFirestore.CodingKeys.amountOfComletion.rawValue] as? Int ?? 0
            let newAmountOfComletion = currentAmount + 1
            
            try await updatehabitField(
                habitId: habitId,
                field: HabitFirestore.CodingKeys.amountOfComletion.rawValue,
                value: newAmountOfComletion
            )
        } catch {
            print("Failed to increment habit count: \(error)")
            throw error
        }
    }
    
    private func updatehabitField(habitId: String, field: String, value: Any) async throws {
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
