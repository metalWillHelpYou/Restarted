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
    @Published var currentPractice: String = "No practice selected"
    
    private var stopwatchSubscription: AnyCancellable?
    private var pausedTime: Int = 0
    
    // MARK: - Stopwatch Logic
    
    func startStopwatch(forPracticeId practiceId: String) {
        guard !isStopwatchRunning else { return }
        if pausedTime > 0 {
            elapsedTime = pausedTime
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
    
    func stopStopwatch(forPracticeId practiceId: String) {
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
        pausedTime = 0
        Task {
            await sendElapsedTimeToPracticeManager(for: practiceId)
            await incrementSessionCount(for: practiceId)
        }
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
    
    // MARK: - Firestore Logic
    
    func sendElapsedTimeToPracticeManager(for practiceId: String) async {
        guard elapsedTime > 0 else { return }

        do {
            try await PracticeManager.shared.updatePracticeTime(for: practiceId, elapsedTime: elapsedTime)
            print("Updated practice time successfully!")
        } catch {
            print("Error updating practice time: \(error)")
        }
    }
    
    func incrementSessionCount(for practiceId: String) async {
        do {
            try await PracticeManager.shared.incrementSessionCount(for: practiceId)
        } catch {
            print("Error updating practice session count: \(error)")
        }
    }
}
