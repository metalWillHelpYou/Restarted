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
    @Published var practices: [PracticeFirestore] = []
    @Published var practicePercentage: Double = 0
    @Published var gamePercentage: Double = 0
    @Published var practiceTime: Int = 0
    @Published var gameTime: Int = 0
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(gamesDidChange), name: .gamesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(practicesDidChange), name: .practicesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .gamesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .practicesDidChange, object: nil)
    }
    
    // MARK: - Listener Management
    
    func startListening() {
        GameManager.shared.startListeningToGames()
        PracticeManager.shared.startListeningToPractices()
    }
    
    func stopListening() {
        GameManager.shared.stopListeningToGames()
        PracticeManager.shared.stopListeningToPractices()
    }
    
    // MARK: - Notification Handlers
    
    @objc private func gamesDidChange() {
        DispatchQueue.main.async {
            self.games = GameManager.shared.games
            self.calculateTimeDistribution()
        }
    }
    
    @objc private func practicesDidChange() {
        DispatchQueue.main.async {
            self.practices = PracticeManager.shared.practices
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
        practiceTime = practices.reduce(0) { $0 + $1.seconds }
        gameTime = games.reduce(0) { $0 + $1.seconds }
        let totalTime = Double(practiceTime + gameTime)
        
        if totalTime > 0 {
            practicePercentage = (Double(practiceTime) / totalTime) * 100
            gamePercentage = (Double(gameTime) / totalTime) * 100
        } else {
            practicePercentage = 0
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
    
    // MARK: - Practices Statistics
    
    func hasEnoughPracticeData() -> Bool {
        practices.count >= 3 && practices.contains {
            $0.sessionCount > 0 || $0.seconds > 0 || $0.streak > 0
        }
    }
    
    func averagePracticeTime(for practice: PracticeFirestore) -> String {
        guard practice.seconds > 0, practice.sessionCount > 0 else { return "00:00" }
        let averageSeconds = practice.seconds / practice.sessionCount
        return formatTime(seconds: averageSeconds)
    }
    
    func topPracticesByStreak() -> [PracticeFirestore] {
        Array(
            practices
                .sorted { $0.streak > $1.streak }
        )
    }
    
    func topPracticesByTotalTime() -> [PracticeFirestore] {
        Array(
            practices
                .sorted { $0.seconds > $1.seconds }
        )
    }
}
