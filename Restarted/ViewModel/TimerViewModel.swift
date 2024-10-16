//
//  TimerViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import Foundation
import Combine
import CoreData

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var currentGame: String = "No game selected"
    @Published var savedPresets: [TimePreset] = []
    @Published var showEasterEgg: Bool = false
    
    private var timerSubscription: AnyCancellable?
    private var seconds: Int = 0
    var onTimerEnded: (() -> Void)?
    
    let games = ["Dota 2", "Minecraft", "Genshin Impact", "War Thunder", "Baldur's Gate 3"]
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GameModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        fetchPresets()
    }
    
    // MARK: - Timer Logic
    
    func saveTime(seconds: Int) {
        addPreset(seconds: Int32(seconds))
    }
    
    func startTimer(seconds: Int) {
        timeRemaining = seconds
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
    
    func stopTimer() {
        timerSubscription?.cancel()
        isTimerRunning = false
    }
    
    private func handleTimerTick() {
        guard timeRemaining > 0 else {
            stopTimer()
            showEasterEgg = true
            onTimerEnded?()
            return
        }
        timeRemaining -= 1
    }
    
    // MARK: - Game Selection
    
    func initializeTime(for game: Game?) {
        seconds = Int(game?.seconds ?? 0)
    }
    
    func selectRandomGame() {
        currentGame = games.randomElement() ?? "No game selected"
    }

    // MARK: - Time Formatting
    
    func timeString() -> String {
        let (hours, minutes, seconds) = convertSecondsToTime(timeRemaining)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func convertSecondsToTime(_ seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return (hours, minutes, remainingSeconds)
    }
    
    func formattedTime(from seconds: Int32) -> String {
        let (hours, minutes, remainingSeconds) = convertSecondsToTime(Int(seconds))
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
    
    func formatTimeDigits(hours: Int, minutes: Int) -> String {
        hours > 0 ? String(format: "%d:%02d", hours, minutes) : String(format: "%2d", minutes)
    }

    func formatTimeText(hours: Int, minutes: Int) -> String {
        var components: [String] = []
        
        if hours > 0 {
            components.append("\(hours) hour\(hours > 1 ? "s" : "")")
        }
        
        if minutes > 0 {
            components.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
        }
        
        return components.joined(separator: " ")
    }

    // MARK: - Core Data Logic
    
    func fetchPresets() {
        let request = NSFetchRequest<TimePreset>(entityName: "TimePreset")
        do {
            savedPresets = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching time presets: \(error)")
        }
    }
    
    func addPreset(seconds: Int32) {
        guard !savedPresets.contains(where: { $0.seconds == seconds }) else { return }
        
        let newPreset = TimePreset(context: container.viewContext)
        newPreset.seconds = seconds
        
        saveData()
    }
    
    func deletePreset(_ preset: TimePreset) {
        container.viewContext.delete(preset)
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchPresets()
        } catch {
            print("Error saving time presets: \(error)")
        }
    }
}
