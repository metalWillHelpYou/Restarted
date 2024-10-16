//
//  TimerViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var currentGame: String = "No game selected"
    @Published var savedTimes: [Int] = []
    
    @Published var showEasterEgg: Bool = false
    let games = ["Dota 2", "Minecraft", "Genshin Impact", "War Thunder", "Baldur's Gate 3"]

    private var timerSubscription: AnyCancellable?
    private var seconds: Int = 0
    var onTimerEnded: (() -> Void)?
    
    func saveTime(hours: Int, minutes: Int) {
        let seconds = (hours * 3600) + (minutes * 60)
        savedTimes.insert(seconds, at: 0)
    }
    
    func startTimer(seconds: Int) {
        timeRemaining = seconds
        resumeTimer()
    }
    
    func timeString() -> String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerSubscription?.cancel()
                    self.isTimerRunning = false
                    self.showEasterEgg = true
                    self.onTimerEnded?()
                }
            }
        isTimerRunning = true
    }
    
    func stopTimer() {
        timerSubscription?.cancel()
        isTimerRunning = false
    }

    
    func initializeTime(for game: Game?) {
        self.seconds = Int(game?.seconds ?? 0)
    }
    
    func selectRandomGame() {
        currentGame = games.randomElement() ?? "No game selected"
    }
    
    func convertSecondsToTime(_ seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return (hours, minutes, remainingSeconds)
    }
}
