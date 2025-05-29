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
    // Seconds elapsed since session start
    @Published var elapsedTime: Int = 0
    // Indicates active timer state
    @Published var isStopwatchRunning: Bool = false
    // Descriptive label for selected practice
    @Published var currentPractice: String = "No practice selected"

    private var stopwatchSubscription: AnyCancellable?
    private var pausedTime: Int = 0

    // Starts new session or resumes from pause
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

    // Pauses timer and stores current value
    func pauseStopwatch() {
        guard isStopwatchRunning else { return }
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
        pausedTime = elapsedTime
    }

    // Continues ticking from `pausedTime`
    func resumeStopwatch() {
        guard !isStopwatchRunning else { return }
        startTimer()
    }

    // Stops timer and commits time to Firestore
    func stopStopwatch(forPracticeId practiceId: String) {
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
        pausedTime = 0
        Task {
            await sendElapsedTimeToPracticeManager(for: practiceId)
            await incrementSessionCount(for: practiceId)
        }
    }

    // Creates Combine timer that fires every second
    private func startTimer() {
        stopwatchSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleStopwatchTick()
            }
        isStopwatchRunning = true
    }

    // Increments elapsed time by one
    private func handleStopwatchTick() {
        elapsedTime += 1
    }

    // Returns HH:MM:SS formatted string
    func formattedTime() -> String {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Firestore integration
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
