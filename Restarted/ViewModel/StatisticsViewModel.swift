//
//  StatisticsViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.01.2025.
//

import Foundation
import Combine

// Manages combined game and practice statistics
@MainActor
final class StatisticsViewModel: ObservableObject {
    // Live data from Firestore
    @Published var games: [GameFirestore] = []
    @Published var practices: [Practice] = []
    
    // Computed totals and percentages used by charts
    @Published var practicePercentage: Double = 0
    @Published var gamePercentage: Double = 0
    @Published var practiceTime: Int = 0
    @Published var gameTime: Int = 0
    
    private let gameManager = GameManager.shared
    private let practiceManager = PracticeManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Subscribes to Firestore streams and recalculates on change
    init() {
        gameManager.$games
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.games = $0 }
            .store(in: &cancellables)
        practiceManager.$practices
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.practices = $0
                self?.calculateTimeDistribution()
            }
            .store(in: &cancellables)
    }
    
    // Enables real-time updates
    func startListening() {
        gameManager.startListeningToGames()
        practiceManager.startObservingPractices()
    }
    
    // Stops real-time updates
    func stopListening() {
        gameManager.stopListeningToGames()
        practiceManager.stopObservingPractices()
    }
    
    // Recomputes total seconds and their percentages
    private func calculateTimeDistribution() {
        practiceTime = practices.reduce(0) { $0 + $1.seconds }
        gameTime = games.reduce(0) { $0 + $1.seconds }
        let total = Double(practiceTime + gameTime)
        if total > 0 {
            practicePercentage = (Double(practiceTime) / total) * 100
            gamePercentage = (Double(gameTime) / total) * 100
        } else {
            practicePercentage = 0
            gamePercentage = 0
        }
    }
    
    // Returns true when at least 3 games exist
    func hasEnoughGameData() -> Bool { games.count >= 3 }
    
    // Average session length for a single game
    func averageGameSessionTime(for game: GameFirestore) -> String {
        guard game.seconds > 0, game.sessionCount > 0 else { return "00:00" }
        let avg = game.seconds / game.sessionCount
        return formatTime(seconds: avg)
    }
    
    // Games ranked by number of launches
    func topGamesByLaunches() -> [GameFirestore] { games.sorted { $0.sessionCount > $1.sessionCount } }
    
    // Games ranked by cumulative play time
    func topGamesByTotalTime() -> [GameFirestore] { games.sorted { $0.seconds > $1.seconds } }
    
    // Returns true when at least 3 meaningful practices exist
    func hasEnoughPracticeData() -> Bool {
        practices.count >= 3 && practices.contains { $0.sessionCount > 0 || $0.seconds > 0 || $0.streak > 0 }
    }
    
    // Average session length for a single practice
    func averagePracticeTime(for practice: Practice) -> String {
        guard practice.seconds > 0, practice.sessionCount > 0 else { return "00:00" }
        let avg = practice.seconds / practice.sessionCount
        return formatTime(seconds: avg)
    }
    
    // Practices ranked by longest streak
    func topPracticesByStreak() -> [Practice] { practices.sorted { $0.streak > $1.streak } }
    
    // Practices ranked by cumulative time
    func topPracticesByTotalTime() -> [Practice] { practices.sorted { $0.seconds > $1.seconds } }
    
    // Formats seconds as HH:MM
    private func formatTime(seconds: Int) -> String {
        guard seconds > 0 else { return "00:00" }
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return String(format: "%02d:%02d", h, m)
    }
}
