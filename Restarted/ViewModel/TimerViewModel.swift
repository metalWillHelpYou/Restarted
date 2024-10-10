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
    
    private var timerSubscription: AnyCancellable?
    
    @Published private var hours: Int = 0
    @Published private var minutes: Int = 0
    var game: Game?
    
    @Published var currentGame: String = "No game selected"
    @Published var showEasterEgg: Bool = false              
    let games = ["Dota 2", "Minecraft", "Genshin Impact", "War Thunder", "Baldur's Gate 3"]
    
    func startTimer(hours: Int, minutes: Int) {
        timeRemaining = (hours * 3600) + (minutes * 60)
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
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerSubscription?.cancel()
                    self.isTimerRunning = false
                    self.showEasterEgg = true
                }
            }
        isTimerRunning = true
    }
    
    func stopTimer() {
        timerSubscription?.cancel()
        isTimerRunning = false
    }
    
    func timeString() -> String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func initializeTime(for game: Game?) {
        self.hours = Int(game?.hours ?? 0)
        self.minutes = Int(game?.minutes ?? 0)
    }
    
    func selectRandomGame() {
        currentGame = games.randomElement() ?? "No game selected"
    }
}
