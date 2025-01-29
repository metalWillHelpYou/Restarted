//
//  StatisticsViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.01.2025.
//

import Foundation
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var games: [GameFirestore] = []
    @Published var practices: [Practice] = []
    
    @Published var practicePercentage: Double = 0
    @Published var gamePercentage: Double = 0
    @Published var practiceTime: Int = 0
    @Published var gameTime: Int = 0
    
    private let gameManager = GameManager.shared
    private let practiceManager = PracticeManager.shared

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        gameManager.$games
            .receive(on: RunLoop.main)
            .sink { [weak self] newGames in
                self?.games = newGames
            }
            .store(in: &cancellables)
        
        practiceManager.$practices
            .receive(on: RunLoop.main)
            .sink { [weak self] newPractices in
                self?.practices = newPractices
                self?.calculateTimeDistribution()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Listener Management
    
    func startListening() {
        gameManager.startListeningToGames()
        practiceManager.startObservingPractices()
    }
    
    func stopListening() {
        gameManager.stopListeningToGames()
        practiceManager.stopObservingPractices()
    }
    
    // MARK: - Notification Handlers
    
    @objc private func gamesDidChange() {
        DispatchQueue.main.async {
            self.games = self.gameManager.games
            self.calculateTimeDistribution()
        }
    }
    
    @objc private func practicesDidChange() {
        DispatchQueue.main.async {
            self.practices = self.practiceManager.practices
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
    
    func averagePracticeTime(for practice: Practice) -> String {
        guard practice.seconds > 0, practice.sessionCount > 0 else { return "00:00" }
        let averageSeconds = practice.seconds / practice.sessionCount
        return formatTime(seconds: averageSeconds)
    }
    
    func topPracticesByStreak() -> [Practice] {
        Array(
            practices
                .sorted { $0.streak > $1.streak }
        )
    }
    
    func topPracticesByTotalTime() -> [Practice] {
        Array(
            practices
                .sorted { $0.seconds > $1.seconds }
        )
    }
}
