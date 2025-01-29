//
//  GameEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.08.2024.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published var savedGames: [GameFirestore] = []
    @Published var savedPresets: [TimePresetFirestore] = []
    @Published var gameTitleHandler: String = ""
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
    
    private let gameManager = GameManager.shared
    private let presetManager = GamePresetManager.shared
    private var cancellables = Set<AnyCancellable>()

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue)! }
        set { currentSortTypeRawValue = newValue.rawValue }
    }
    
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
    
    @objc private func gamesDidChange() {
        DispatchQueue.main.async {
            self.savedGames = self.gameManager.games
            self.applyCurrentSort()
            if self.selectedGameId == nil, let firstGame = self.savedGames.first {
                self.selectedGameId = firstGame.id
            }
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
        gameManager.startListeningToGames()
    }
    
    func stopListening() {
        gameManager.stopListeningToGames()
        presetManager.stopListeningToPresets()
    }
    
    private func updatePresetListener() {
        guard let gameId = selectedGameId else {
            presetManager.stopListeningToPresets()
            savedPresets = []
            print("Preset listener stopped: No game selected.")
            return
        }
        
        print("Starting preset listener for game ID: \(gameId)")
        presetManager.startListeningToPresets(forGameId: gameId)
    }

    // MARK: - Game Management

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
