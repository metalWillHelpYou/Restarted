//
//  Habit.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import Foundation

struct Habit: Identifiable, Codable {
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
    static let habits: [Habit] = [
        Habit(title: "Breathing", imageName: "Breathing"),
        Habit(title: "Contact a friend", imageName: "Contact a friend"),
        Habit(title: "Cycling", imageName: "Cycling"),
        Habit(title: "Meditation", imageName: "Meditation"),
        Habit(title: "Reading", imageName: "Reading"),
        Habit(title: "Swimming", imageName: "Swimming"),
        Habit(title: "Walking", imageName: "Walking"),
    ]
}
