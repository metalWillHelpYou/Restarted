//
//  PracticeViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.09.2024.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class PracticeViewModel: ObservableObject {
    @Published var savedPractices: [PracticeFirestore] = []
    @Published var activePractices: [PracticeFirestore] = []
    @Published var selectedPractice: PracticeFirestore? = nil
    @Published var showDeleteDialog: Bool = false
    @Published var practiceTitleHandler: String = ""
    @Published var elapsedTime: Int = 0
    @AppStorage("isNotificationsOn") var isPracticeActive: Bool = false
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue
    @Published var totalTime: Int = 0

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue) ?? .byDateAdded }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(practicesDidChange), name: .practicesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .practicesDidChange, object: nil)
    }
    
    @objc private func practicesDidChange() {
        DispatchQueue.main.async {
            self.savedPractices = PracticeManager.shared.practices
        }
    }
    
    func startListening() {
        PracticeManager.shared.startListeningToPractices()
    }
    
    func stopListening() {
        PracticeManager.shared.stopListeningToPractices()
    }
    
    func addPractice(with title: String) async {
        do {
            try await PracticeManager.shared.addPractice(title: title)
            practiceTitleHandler = ""
        } catch {
            print("Error adding practice: \(error.localizedDescription)")
        }
    }

    func editPractice(_ practiceId: String, title: String) async {
        do {
            try await PracticeManager.shared.editPractice(practiceId: practiceId, title: title)
            practiceTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deletePractice(with id: String) async {
        do {
            try await PracticeManager.shared.deletePractice(practiceId: id)
        } catch {
            print("Error deleting practice: \(error.localizedDescription)")
        }
    }

    func addTimeTo(practiceId: String, time: Int) async {
        Task {
            do {
                try await PracticeManager.shared.updatePracticeTime(for: practiceId, elapsedTime: time)
            } catch {
                print("Error adding extra time to practice: \(error.localizedDescription)")
            }
        }
    }
    
    func sortByTitle() {
        savedPractices.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        currentSortType = .byTitle
    }

    func sortByDateAdded() {
        savedPractices.sort {
            guard let firstDate = $0.dateAdded, let secondDate = $1.dateAdded else {
                return $0.dateAdded != nil
            }
            return firstDate < secondDate
        }
        currentSortType = .byDateAdded
    }

    func sortByTime() {
        savedPractices.sort { $0.seconds > $1.seconds }
        currentSortType = .byTime
    }

    private func applyCurrentSort() {
        switch currentSortType {
        case .byTitle: sortByTitle()
        case .byDateAdded: sortByDateAdded()
        case .byTime: sortByTime()
        }
    }
    
    func sendElapsedTimeToPracticeManager(for practiceId: String) async {
        guard elapsedTime > 0 else { return }
        
        do {
            try await PracticeManager.shared.updatePracticeTime(for: practiceId, elapsedTime: elapsedTime)
            print("Updated practice time successfully!")
        } catch {
            print("Error updating practice time: \(error)")
        }
    }
    
    func calculatePracticeTime() {
        totalTime = PracticeManager.shared.practices.reduce(0) { $0 + $1.seconds }
    }
}
