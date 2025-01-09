//
//  StatisticsViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.01.2025.
//

import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var fetchedGames: [GameFirestore] = []
    @Published var fetchedHabits: [HabitFirestore] = []

    func fetchGames() async {
        fetchedGames = await GameManager.shared.fetchGames()
    }
    
    func hasSufficientGameData() -> Bool {
        fetchedGames.count >= 3 && fetchedGames.contains(where: { $0.sessionCount > 0 || $0.seconds > 0 })
    }
    
    func hasSufficientHabitData() -> Bool {
        fetchedHabits.count >= 3 && fetchedHabits.contains(where: { $0.amountOfComletion > 0 || $0.streak > 0 })
    }
    
    func findTheLargestNumberOfGameLaunches(of games: [GameFirestore]) -> [GameFirestore] {
        Array(games.sorted { $0.sessionCount > $1.sessionCount }.prefix(3))
    }
    
    func findTheLargestNumberOfGameTime(of games: [GameFirestore]) -> [GameFirestore] {
        Array(games.sorted { $0.seconds > $1.seconds }.prefix(3))
    }
    
    func findAverageGameSessionTime(in game: GameFirestore) -> String {
        guard game.seconds != 0, game.sessionCount != 0 else { return "00:00" }
        let average = Double(game.seconds) / Double(game.sessionCount)
        let hours = Int(average) / 3600
        let minutes = (Int(average) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func fetchHabits() async {
        fetchedHabits = await HabitManager.shared.fetchHabits()
    }
    
    func findMostComplietableHabits(of habits: [HabitFirestore]) -> [HabitFirestore] {
        Array(habits.sorted { $0.amountOfComletion > $1.amountOfComletion }.prefix(3))
    }
    
    func findLargestStreaks(of habits: [HabitFirestore]) -> [HabitFirestore] {
        Array(habits.sorted { $0.streak > $1.streak }.prefix(3))
    }
}

