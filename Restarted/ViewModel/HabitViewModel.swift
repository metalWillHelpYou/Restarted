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
    @Published var elapsedTime: Int = 0
    @AppStorage("isNotificationsOn") var isHabitActive: Bool = false
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue
    @Published var totalTime: Int = 0

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue) ?? .byDateAdded }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(habitsDidChange), name: .habitsDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .habitsDidChange, object: nil)
    }
    
    @objc private func habitsDidChange() {
        DispatchQueue.main.async {
            self.savedHabits = HabitManager.shared.habits
        }
    }
    
    func startListening() {
        HabitManager.shared.startListeningToHabits()
    }
    
    func stopListening() {
        HabitManager.shared.stopListeningToHabits()
    }
    
    func addHabit(with title: String) async {
        do {
            try await HabitManager.shared.addHabit(title: title)
            habitTitleHandler = ""
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
        }
    }

    func editHabit(_ habitId: String, title: String) async {
        do {
            try await HabitManager.shared.editHabit(habitId: habitId, title: title)
            habitTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deleteHabit(with id: String) async {
        do {
            try await HabitManager.shared.deleteHabit(habitId: id)
        } catch {
            print("Error deleting habit: \(error.localizedDescription)")
        }
    }

    func addTimeTo(habitId: String, time: Int) async {
        Task {
            do {
                try await HabitManager.shared.updateHabitTime(for: habitId, elapsedTime: time)
            } catch {
                print("Error adding extra time to habit: \(error.localizedDescription)")
            }
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
        savedHabits.sort { $0.seconds > $1.seconds }
        currentSortType = .byTime
    }

    private func applyCurrentSort() {
        switch currentSortType {
        case .byTitle: sortByTitle()
        case .byDateAdded: sortByDateAdded()
        case .byTime: sortByTime()
        }
    }
    
    func sendElapsedTimeToHabitManager(for habitId: String) async {
        guard elapsedTime > 0 else { return }
        
        do {
            try await HabitManager.shared.updateHabitTime(for: habitId, elapsedTime: elapsedTime)
            print("Updated habit time successfully!")
        } catch {
            print("Error updating habit time: \(error)")
        }
    }
    
    func calculateHabitTime() {
        totalTime = HabitManager.shared.habits.reduce(0) { $0 + $1.seconds }
    }
}
