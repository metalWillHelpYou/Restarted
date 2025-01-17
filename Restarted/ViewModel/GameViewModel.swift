//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class GameViewModel: ObservableObject {
    @Published var savedGames: [GameFirestore] = []
    @Published var savedPresets: [TimePresetFirestore] = []
    @Published var selectedGameId: String? {
        didSet {
            updatePresetListener()
        }
    }
    @Published var gameTitleHandler: String = ""
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.byDateAdded.rawValue

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue)! }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(gamesDidChange), name: .gamesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presetsDidChange), name: .gamePresetsDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .gamesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .gamePresetsDidChange, object: nil)
        GamePresetManager.shared.stopListeningToPresets()
    }
    
    @objc private func gamesDidChange() {
        DispatchQueue.main.async {
            self.savedGames = GameManager.shared.games
            self.applyCurrentSort()
            if self.selectedGameId == nil, let firstGame = self.savedGames.first {
                self.selectedGameId = firstGame.id
            }
        }
    }
    
    @objc private func presetsDidChange() {
        DispatchQueue.main.async {
            self.savedPresets = GamePresetManager.shared.gamePresets
        }
    }
    
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

    // MARK: - Listeners
    
    func startListening() {
        GameManager.shared.startListeningToGames()
    }
    
    func stopListening() {
        GameManager.shared.stopListeningToGames()
        GamePresetManager.shared.stopListeningToPresets()
    }
    
    private func updatePresetListener() {
        guard let gameId = selectedGameId else {
            GamePresetManager.shared.stopListeningToPresets()
            savedPresets = []
            print("Preset listener stopped: No game selected.")
            return
        }
        
        print("Starting preset listener for game ID: \(gameId)")
        GamePresetManager.shared.startListeningToPresets(forGameId: gameId)
    }

    // MARK: - Game Management

    func addGame(with title: String) async {
        do {
            try await GameManager.shared.addGame(withTitle: title)
            gameTitleHandler = ""
        } catch {
            print("Error adding game: \(error.localizedDescription)")
        }
    }

    func editGame(gameId: String, title: String) async throws {
        do {
            try await GameManager.shared.editGame(gameId: gameId, title: title)
            gameTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deleteGame(with id: String) async {
        do {
            try await GameManager.shared.deleteGame(gameId: id)
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
                try await GameManager.shared.updateGameTime(for: gameId, elapsedTime: time)
            } catch {
                print("Error adding extra time to game: \(error.localizedDescription)")
            }
        }
    }
    
    func deletePreset(with id: String, for gameId: String) async {
        do {
            try await GamePresetManager.shared.deletePreset(forGameId: gameId, presetId: id)
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
