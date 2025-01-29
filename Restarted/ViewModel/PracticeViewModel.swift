//
//  PracticeViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.09.2024.
//

import SwiftUI
import Combine

@MainActor
final class PracticeViewModel: ObservableObject {
    @Published var savedPractices: [Practice] = []
    private let manager = PracticeManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedPractice: Practice? = nil
    @Published var showDeleteDialog: Bool = false
    @Published var practiceTitleInput: String = ""
    @Published var elapsedTime: Int = 0
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue
    @Published var totalTime: Int = 0

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue) ?? .byDateAdded }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    init() {
        manager.$practices
            .receive(on: RunLoop.main)
            .sink { [weak self] newPractices in
                self?.savedPractices = newPractices
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Observing
    
    func startObserving() {
        manager.startObservingPractices()
    }
    
    func stopObserving() {
        manager.stopObservingPractices()
    }
    
    // MARK: - CRUD
    
    func addPractice(with title: String) async {
        do {
            try await manager.addPractice(title: title)
            practiceTitleInput = ""
        } catch {
            print("Error adding practice: \(error.localizedDescription)")
        }
    }

    func editPractice(_ practiceId: String, title: String) async {
        do {
            try await manager.editPractice(practiceId: practiceId, title: title)
            practiceTitleInput = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deletePractice(with id: String) async {
        do {
            try await manager.deletePractice(practiceId: id)
        } catch {
            print("Error deleting practice: \(error.localizedDescription)")
        }
    }
    
    func addTimeTo(practiceId: String, time: Int) async {
        do {
            try await manager.updatePracticeTime(for: practiceId, elapsedTime: time)
        } catch {
            print("Error adding extra time to practice: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sorting
    
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
        case .byTitle:
            sortByTitle()
        case .byDateAdded:
            sortByDateAdded()
        case .byTime:
            sortByTime()
        }
    }
    
    // MARK: - Extra
    
    func sendElapsedTimeToPracticeManager(for practiceId: String) async {
        guard elapsedTime > 0 else { return }
        
        do {
            try await manager.updatePracticeTime(for: practiceId, elapsedTime: elapsedTime)
            print("Updated practice time successfully!")
        } catch {
            print("Error updating practice time: \(error)")
        }
    }
    
    func calculatePracticeTime() {
        totalTime = manager.practices.reduce(0) { $0 + $1.seconds }
    }
}
