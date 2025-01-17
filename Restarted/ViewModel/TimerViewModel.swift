//
//  TimerViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import Foundation
import Combine

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var currentGame: String = "No game selected"
    @Published var elapsedTime: Int = 0
    @Published var showEasterEgg: Bool = false
    
    private var timerSubscription: AnyCancellable?
    private var startTime: Date?
    
    var onTimerEnded: (() -> Void)?
    let games = ["Dota 2", "Minecraft", "Genshin Impact", "War Thunder", "Baldur's Gate 3"]
    
    // MARK: - Timer Logic
    
    func startTimer(seconds: Int, forGameId gameId: String) {
        timeRemaining = seconds
        elapsedTime = 0
        startTime = Date()
        resumeTimer()
    }
    
    func pauseTimer() {
        timerSubscription?.cancel()
        isTimerRunning = false
    }
    
    func resumeTimer() {
        guard !isTimerRunning else { return }
        
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTimerTick()
            }
        isTimerRunning = true
    }
    
    func stopTimer(forGameId gameId: String) {
        timerSubscription?.cancel()
        isTimerRunning = false
        Task {
            await sendElapsedTimeToGameManager(for: gameId)
            await incrementSessionCount(for: gameId)
        }
    }
    
    private func handleTimerTick() {
        guard timeRemaining > 0 else {
            stopTimer(forGameId: currentGame)
            onTimerEnded?()
            return
        }
        
        timeRemaining -= 1
        elapsedTime += 1
    }
    
    // MARK: - Firestore Logic
    
    func sendElapsedTimeToGameManager(for gameId: String) async {
        guard elapsedTime > 0 else { return }
        
        do {
            try await GameManager.shared.updateGameTime(for: gameId, elapsedTime: elapsedTime)
            print("Updated game time successfully!")
        } catch {
            print("Error updating game time: \(error)")
        }
    }
    
    func incrementSessionCount(for gameId: String) async {
        do {
            try await GameManager.shared.incrementSessionCount(for: gameId)
        } catch {
            print("Error updating game session count: \(error)")
        }
    }
    
    // MARK: - Game Selection
    
    func selectRandomGame() {
        currentGame = games.randomElement() ?? "No game selected"
    }
    
    func timeString() -> String {
         let (hours, minutes, seconds) = TimeTools.convertSecondsToTime(timeRemaining)
         return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
     }
}
