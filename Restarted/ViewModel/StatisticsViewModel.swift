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
    @Published var habitPercentage: Double = 0
    @Published var gamePercentage: Double = 0
    @Published var habitTime: Int = 0
    @Published var gameTime: Int = 0
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(gamesDidChange), name: .gamesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(habitsDidChange), name: .habitsDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .gamesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .habitsDidChange, object: nil)
    }
    
    // MARK: - Listener Management
    
    func startListening() {
        GameManager.shared.startListeningToGames()
        HabitManager.shared.startListeningToHabits()
    }
    
    func stopListening() {
        GameManager.shared.stopListeningToGames()
        HabitManager.shared.stopListeningToHabits()
    }
    
    // MARK: - Notification Handlers
    
    @objc private func gamesDidChange() {
        DispatchQueue.main.async {
            self.games = GameManager.shared.games
            self.calculateTimeDistribution()
        }
    }
    
    @objc private func habitsDidChange() {
        DispatchQueue.main.async {
            self.habits = HabitManager.shared.habits
            self.calculateTimeDistribution()
        }
    }
    
    // MARK: - Time Formatting
    
    private func formatTime(seconds: Int) -> String {
        guard seconds > 0 else { return "00:00" }
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    // MARK: - Time Distribution Logic
    
    private func calculateTimeDistribution() {
        habitTime = habits.reduce(0) { $0 + $1.seconds }
        gameTime = games.reduce(0) { $0 + $1.seconds }
        let totalTime = Double(habitTime + gameTime)
        
        if totalTime > 0 {
            habitPercentage = (Double(habitTime) / totalTime) * 100
            gamePercentage = (Double(gameTime) / totalTime) * 100
        } else {
            habitPercentage = 0
            gamePercentage = 0
        }
    }
    
    // MARK: - Games Statistics
    
    func hasEnoughGameData() -> Bool {
        games.count >= 3
    }
    
    func averageGameSessionTime(for game: GameFirestore) -> String {
        guard game.seconds > 0, game.sessionCount > 0 else { return "00:00" }
        let averageSeconds = game.seconds / game.sessionCount
        return formatTime(seconds: averageSeconds)
    }
    
    func topGamesByLaunches() -> [GameFirestore] {
        Array(
            games
                .sorted { $0.sessionCount > $1.sessionCount }
        )
    }
    
    func topGamesByTotalTime() -> [GameFirestore] {
        Array(
            games
                .sorted { $0.seconds > $1.seconds }
        )
    }
    
    // MARK: - Habits Statistics
    
    func hasEnoughHabitData() -> Bool {
        habits.count >= 3 && habits.contains {
            $0.sessionCount > 0 || $0.seconds > 0 || $0.streak > 0
        }
    }
    
    func averageHabitTime(for habit: HabitFirestore) -> String {
        guard habit.seconds > 0, habit.sessionCount > 0 else { return "00:00" }
        let averageSeconds = habit.seconds / habit.sessionCount
        return formatTime(seconds: averageSeconds)
    }
    
    func topHabitsByStreak() -> [HabitFirestore] {
        Array(
            habits
                .sorted { $0.streak > $1.streak }
        )
    }
    
    func topHabitsByTotalTime() -> [HabitFirestore] {
        Array(
            habits
                .sorted { $0.seconds > $1.seconds }
        )
    }
}
