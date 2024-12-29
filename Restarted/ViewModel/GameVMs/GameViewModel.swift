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
    enum SortType: String {
        case none
        case byTitle
        case byDateAdded
        case byTime
    }

    @Published var savedGames: [GameFirestore] = []
    @Published var savedPresets: [TimePresetFirestore] = []
    @Published var gameTitleHandler: String = ""
    @AppStorage("currentSortType") private var currentSortTypeRawValue: String = SortType.none.rawValue

    private var currentSortType: SortType {
        get { SortType(rawValue: currentSortTypeRawValue) ?? .none }
        set { currentSortTypeRawValue = newValue.rawValue }
    }

    // MARK: - Game Logic
    func fetchGames() async {
        savedGames = await GameManager.shared.fetchGames()
        applyCurrentSort()
    }

    func addGame(_ game: String) async {
        do {
            savedGames = try await GameManager.shared.addGame(withTitle: game)
            await fetchGames()
            gameTitleHandler = ""
        } catch {
            print("Error adding game: \(error.localizedDescription)")
        }
    }

    func editGame(gameId: String, title: String) async throws {
        do {
            try await GameManager.shared.editGame(gameId: gameId, title: title)
            await fetchGames()
            gameTitleHandler = ""
        } catch {
            print("Error editing title: \(error.localizedDescription)")
        }
    }

    func deleteGame(with id: String) async {
        do {
            try await GameManager.shared.deleteGame(gameId: id)
            await fetchGames()
        } catch {
            print("Error deleting game: \(error.localizedDescription)")
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

    private func applyCurrentSort() {
        switch currentSortType {
        case .none: break
        case .byTitle: sortByTitle()
        case .byDateAdded: sortByDateAdded()
        case .byTime: sortByTime()
        }
    }

    // MARK: - Preset Logic
    func fetchPresets(for gameId: String) async {
        savedPresets =  await GamePresetManager.shared.fetchPresets(forGameId: gameId)
    }

    func deletePreset(with id: String, for gameId: String) async {
        do {
            try await GamePresetManager.shared.deletePreset(forGameId: gameId, presetId: id)
            await fetchPresets(for: id)
        } catch {
            print("Error deleting preset: \(error.localizedDescription)")
        }
    }
}
