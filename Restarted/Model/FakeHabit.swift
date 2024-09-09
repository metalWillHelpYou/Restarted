//
//  Habit.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import Foundation

struct FakeHabit: Identifiable, Codable {
    let title: String
    let imageName: String
    
    var id: String {
        title + imageName
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

struct HabitData {
    static let habits: [FakeHabit] = [
        FakeHabit(title: "Breathing", imageName: "Breathing"),
        FakeHabit(title: "Contact a friend", imageName: "Contact a friend"),
        FakeHabit(title: "Cycling", imageName: "Cycling"),
//        FakeHabit(title: "Meditation", imageName: "Meditation"),
//        FakeHabit(title: "Reading", imageName: "Reading"),
//        FakeHabit(title: "Swimming", imageName: "Swimming"),
//        FakeHabit(title: "Walking", imageName: "Walking"),
    ]
}
