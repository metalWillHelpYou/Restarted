//
//  HabitViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.09.2024.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class HabitViewModel: ObservableObject {
    @Published var savedHabits: [HabitFirestore] = []
    @Published var activeHabits: [HabitFirestore] = []
    @Published var selectedHabit: HabitFirestore? = nil
    @Published var showDeleteDialog: Bool = false
    @Published var habitTitleHandler: String = ""
    @AppStorage("isNotificationsOn") var isHabitActive: Bool = false
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue) ?? .byDateAdded }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    func fetchHabits() async {
        savedHabits = await HabitManager.shared.fetchHabits()
        applyCurrentSort()
    }
    
    func addHabit(with title: String, and time: Int) async {
        do {
            savedHabits = try await HabitManager.shared.addHabit(title: title, time: time)
            await fetchHabits()
            habitTitleHandler = ""
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
        }
    }
    
    func editHabit(_ habitId: String, title: String) async throws {
        do {
            try await HabitManager.shared.editHabit(habitId: habitId, title: title)
            await fetchHabits()
            habitTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }
    
    func deleteHabit(with id: String) async {
        do {
            try await HabitManager.shared.deleteHabit(habitId: id)
            await fetchHabits()
        } catch {
            print("Error deleting habit: \(error.localizedDescription)")
        }
    }
    
    func addHabitToActive(habitId: String) async {
        
        do {
            try await HabitManager.shared.addHabitToActive(with: habitId)
        } catch {
            print("Error adding habit to active: \(error.localizedDescription)")
        }
    }
    
    func removeHabitFromActive(habitId: String) async {
        
        do {
            try await HabitManager.shared.removeHabitFromActive(with: habitId)
            await fetchHabits()
        } catch {
            print("Error removing habit from active: \(error.localizedDescription)")
        }
    }
    
    func markAsDone(_ habitId: String) async {
        do {
            try await HabitManager.shared.markAsDone(habitId: habitId)
            await fetchHabits()
        } catch {
            print("Error marking habit as done: \(error.localizedDescription)")
        }
    }
    
    func sortByTitle() {
        savedHabits.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        currentSortType = .byTitle
    }

    func sortByDateAdded() {
        savedHabits.sort {
            guard let firstDate = $0.dateAdded, let secondDate = $1.dateAdded else {
                return $0.dateAdded != nil
            }
            return firstDate < secondDate
        }
        currentSortType = .byDateAdded
    }

    func sortByTime() {
        savedHabits.sort { $0.time > $1.time }
        currentSortType = .byTime
    }

    private func applyCurrentSort() {
        switch currentSortType {
        case .byTitle: sortByTitle()
        case .byDateAdded: sortByDateAdded()
        case .byTime: sortByTime()
        }
    }
}
