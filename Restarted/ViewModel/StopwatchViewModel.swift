//
//  StopwatchViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 13.01.2025.
//

import Foundation
import Combine

@MainActor
final class StopwatchViewModel: ObservableObject {
    @Published var elapsedTime: Int = 0
    @Published var isStopwatchRunning: Bool = false
    
    private var stopwatchSubscription: AnyCancellable?
    private var pausedTime: Int = 0
    
    func startStopwatch() {
        guard !isStopwatchRunning else { return }
        if pausedTime > 0 {
            resumeStopwatch()
        } else {
            elapsedTime = 0
            startTimer()
        }
    }
    
    func pauseStopwatch() {
        guard isStopwatchRunning else { return }
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
        pausedTime = elapsedTime
    }
    
    func resumeStopwatch() {
        guard !isStopwatchRunning else { return }
        startTimer()
    }
    
    func resetStopwatch() {
        stopwatchSubscription?.cancel()
        elapsedTime = 0
        pausedTime = 0
        isStopwatchRunning = false
    }
    
    private func startTimer() {
        stopwatchSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleStopwatchTick()
            }
        isStopwatchRunning = true
    }
    
    private func handleStopwatchTick() {
        elapsedTime += 1
    }
    
    func formattedTime() -> String {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    deinit {
        stopwatchSubscription?.cancel()
    }
}
