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
    @Published var currentHabit: String = "No habit selected"
    
    private var stopwatchSubscription: AnyCancellable?
    private var startTime: Date?

    // MARK: - Stopwatch Logic

    func startStopwatch(forHabitId habitId: String) {
        elapsedTime = 0
        startTime = Date()
        resumeStopwatch()
    }

    func pauseStopwatch() {
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
    }

    func resumeStopwatch() {
        guard !isStopwatchRunning else { return }
        
        stopwatchSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleStopwatchTick()
            }
        isStopwatchRunning = true
    }

    func stopStopwatch(forHabitId habitId: String) {
        stopwatchSubscription?.cancel()
        isStopwatchRunning = false
        Task {
            await sendElapsedTimeToHabitManager(for: habitId)
            await incrementSessionCount(for: habitId)
        }
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

    func sendElapsedTimeToHabitManager(for habitId: String) async {
        guard elapsedTime > 0 else { return }

        do {
            try await HabitManager.shared.updateHabitTime(for: habitId, elapsedTime: elapsedTime)
            print("Updated habit time successfully!")
        } catch {
            print("Error updating habit time: \(error)")
        }
    }

    func incrementSessionCount(for habitId: String) async {
        do {
            try await HabitManager.shared.incrementSessionCount(for: habitId)
        } catch {
            print("Error updating habit session count: \(error)")
        }
    }
}
