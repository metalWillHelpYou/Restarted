//
//  TimerViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import Foundation
import Combine

// Provides countdown timer functionality tied to a game session
@MainActor
final class TimerViewModel: ObservableObject {
    // Seconds left until timer ends
    @Published var timeRemaining: Int = 0
    // Indicates active timer state
    @Published var isTimerRunning: Bool = false
    // Name of the game currently associated with the timer
    @Published var currentGame: String = "No game selected"
    // Elapsed seconds tracked for persistence
    @Published var elapsedTime: Int = 0
    // Shows hidden UI when triggered
    @Published var showEasterEgg: Bool = false
    
    // Combine publisher driving the countdown
    private var timerSubscription: AnyCancellable?
    // Start timestamp used for calculations if needed
    private var startTime: Date?
    
    // Callback executed when timer reaches zero
    var onTimerEnded: (() -> Void)?
    // Sample games used for random selection
    let games = ["Dota 2", "Minecraft", "Genshin Impact", "War Thunder", "Baldur's Gate 3"]
    
    // Initializes and starts timer for given duration
    func startTimer(seconds: Int, forGameId gameId: String) {
        timeRemaining = seconds
        elapsedTime = 0
        startTime = Date()
        resumeTimer()
    }
    
    // Pauses timer without resetting counters
    func pauseTimer() {
        timerSubscription?.cancel()
        isTimerRunning = false
    }
    
    // Resumes ticking if not already running
    func resumeTimer() {
        guard !isTimerRunning else { return }
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.handleTimerTick() }
        isTimerRunning = true
    }
    
    // Stops timer and writes elapsed time to Firestore
    func stopTimer(forGameId gameId: String) {
        timerSubscription?.cancel()
        isTimerRunning = false
        Task {
            await sendElapsedTimeToGameManager(for: gameId)
            await incrementSessionCount(for: gameId)
        }
    }
    
    // Decrements remaining time each second and handles expiry
    private func handleTimerTick() {
        guard timeRemaining > 0 else {
            stopTimer(forGameId: currentGame)
            onTimerEnded?()
            return
        }
        
        timeRemaining -= 1
        elapsedTime += 1
    }
    
    // Firestore integration
    func sendElapsedTimeToGameManager(for gameId: String) async {
        guard elapsedTime > 0 else { return }
        
        do {
            try await GameManager.shared.updateGameTime(for: gameId, elapsedTime: elapsedTime)
            print("Updated game time successfully!")
        } catch {
            print("Error updating game time: \(error)")
        }
    }
    
    // Increments session count for the game document
    func incrementSessionCount(for gameId: String) async {
        do {
            try await GameManager.shared.incrementSessionCount(for: gameId)
        } catch {
            print("Error updating game session count: \(error)")
        }
    }
    
    
    // Game helpers
    func selectRandomGame() { currentGame = games.randomElement() ?? "No game selected" }
    
    func timeString() -> String {
         let (hours, minutes, seconds) = TimeTools.convertSecondsToTime(timeRemaining)
         return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
     }
}
