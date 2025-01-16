//
//  StatisticsViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.01.2025.
//

import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var games: [GameFirestore] = []
    @Published var habits: [HabitFirestore] = []
    
    // MARK: - Load Data
    
//    func loadGames() async {
//        games = await GameManager.shared.fetchGames()
//    }
    
//    func loadHabits() async {
//        habits = await HabitManager.shared.fetchHabits()
//    }
    
    // MARK: - Games Statistics
    
    func hasEnoughGameData() -> Bool {
        games.count >= 3 && games.contains {
            $0.sessionCount > 0 || $0.seconds > 0
        }
    }
    
    func averageGameSessionTime(for game: GameFirestore) -> String {
        guard game.seconds > 0, game.sessionCount > 0 else {
            return "00:00"
        }
        let averageSeconds = Double(game.seconds) / Double(game.sessionCount)
        let hours = Int(averageSeconds) / 3600
        let minutes = (Int(averageSeconds) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func topGamesByLaunches(limit: Int = 3) -> [GameFirestore] {
        Array(
            games
                .sorted { $0.sessionCount > $1.sessionCount }
                .prefix(limit)
        )
    }
    
    func topGamesByTotalTime(limit: Int = 3) -> [GameFirestore] {
        Array(
            games
                .sorted { $0.seconds > $1.seconds }
                .prefix(limit)
        )
    }
    
    // MARK: - Habits Statistics
    
    func hasEnoughHabitData() -> Bool {
        habits.count >= 3 && habits.contains {
            $0.sessionCount > 0 || $0.seconds > 0 || $0.streak > 0
        }
    }
    
    func averageHabitTime(for habit: HabitFirestore) -> String {
        guard habit.seconds > 0, habit.sessionCount > 0 else {
            return "00:00"
        }
        let averageSeconds = Double(habit.seconds) / Double(habit.sessionCount)
        let hours = Int(averageSeconds) / 3600
        let minutes = (Int(averageSeconds) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func topHabitsByStreak(limit: Int = 3) -> [HabitFirestore] {
        Array(
            habits
                .sorted { $0.streak > $1.streak }
                .prefix(limit)
        )
    }
    
    func topHabitsByTotalTime(limit: Int = 3) -> [HabitFirestore] {
        Array(
            habits
                .sorted { $0.seconds > $1.seconds }
                .prefix(limit)
        )
    }
}
