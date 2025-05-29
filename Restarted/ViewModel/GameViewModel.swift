//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import SwiftUI
import Combine

// Manages games list, presets list and sorting logic
@MainActor
final class GameViewModel: ObservableObject {
    // Games displayed in UI
    @Published var savedGames: [GameFirestore] = []
    // Presets for selected game
    @Published var savedPresets: [TimePresetFirestore] = []
    // Text field binding for new game title
    @Published var gameTitleHandler: String = ""
    // Currently selected game ID triggers presets listener
    @Published var selectedGameId: String? {
        didSet {
            guard let gameId = selectedGameId else {
                presetManager.stopListeningToPresets()
                savedPresets = []
                return
            }
            presetManager.startListeningToPresets(forGameId: gameId)
        }
    }
    
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue
    
    // Firestore managers
    private let gameManager = GameManager.shared
    private let presetManager = GamePresetManager.shared
    // Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // Current sorting preference
    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue)! }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    // Subscribes to games and presets streams
    init() {
        gameManager.$games
            .receive(on: RunLoop.main)
            .sink { [weak self] newGames in
                guard let self = self else { return }
                self.savedGames = newGames
                self.applyCurrentSort()
                if self.selectedGameId == nil, let firstGame = newGames.first {
                    self.selectedGameId = firstGame.id
                }
            }
            .store(in: &cancellables)
        
        presetManager.$gamePresets
            .receive(on: RunLoop.main)
            .sink { [weak self] newPresets in
                self?.savedPresets = newPresets
            }
            .store(in: &cancellables)
    }
    
    // Applies stored sort option after updates
    private func applyCurrentSort() {
        switch currentSortType {
        case .byTitle:
            savedGames.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .byDateAdded:
            savedGames.sort {
                guard let firstDate = $0.dateAdded, let secondDate = $1.dateAdded else {
                    return $0.dateAdded != nil
                }
                return firstDate < secondDate
            }
        case .byTime:
            savedGames.sort { $0.seconds > $1.seconds }
        }
    }

    // Listeners
    func startObservingGames() { gameManager.startListeningToGames() }
    func stopObservingGames() {
        gameManager.stopListeningToGames()
        presetManager.stopListeningToPresets()
    }
    
    // Game management
    func addGame(with title: String) async {
        do {
            try await gameManager.addGame(withTitle: title)
            gameTitleHandler = ""
        } catch {
            print("Error adding game: \(error.localizedDescription)")
        }
    }

    func editGame(gameId: String, title: String) async throws {
        do {
            try await gameManager.editGame(gameId: gameId, title: title)
            gameTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deleteGame(with id: String) async {
        do {
            try await gameManager.deleteGame(gameId: id)
            if selectedGameId == id {
                selectedGameId = savedGames.first?.id
            }
        } catch {
            print("Error deleting game: \(error.localizedDescription)")
        }
    }

    func addTimeTo(gameId: String, time: Int) async {
        Task {
            do {
                try await gameManager.updateGameTime(for: gameId, elapsedTime: time)
            } catch {
                print("Error adding extra time to game: \(error.localizedDescription)")
            }
        }
    }
    
    func deletePreset(with id: String, for gameId: String) async {
        do {
            try await presetManager.deletePreset(forGameId: gameId, presetId: id)
        } catch {
            print("Error deleting preset: \(error.localizedDescription)")
        }
    }

    func sortByTitle() {
        savedGames.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        currentSortType = .byTitle
    }

    func sortByDateAdded() {
        savedGames.sort {
            guard let firstDate = $0.dateAdded, let secondDate = $1.dateAdded else {
                return $0.dateAdded != nil
            }
            return firstDate < secondDate
        }
        currentSortType = .byDateAdded
    }

    func sortByTime() {
        savedGames.sort { $0.seconds > $1.seconds }
        currentSortType = .byTime
    }
}
