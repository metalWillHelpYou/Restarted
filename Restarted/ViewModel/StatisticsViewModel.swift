//
//  StatisticsViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.01.2025.
//

import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var fetchedGames: [GameFirestore] = []
    @Published var fetchedHabits: [HabitFirestore] = []
    
    
    func fetchGames() async {
        fetchedGames = await GameManager.shared.fetchGames()
    }
    
    func findTheLargestNumberOfGameLaunches(of games: [GameFirestore]) -> [GameFirestore] {
        let mostLaunchebleGames = Array(games.sorted { $0.sessionCount > $1.sessionCount }.prefix(3))
        return mostLaunchebleGames
    }
    
    func findTheLargestNumberOfGameTime(of games: [GameFirestore]) -> [GameFirestore] {
        let theLargestAmountOfTime = Array(games.sorted { $0.seconds > $1.seconds }.prefix(3))
        return theLargestAmountOfTime
    }
    
    func findAverageGameSessionTime(in game: GameFirestore) -> String {
        guard game.seconds != 0, game.sessionCount != 0 else { return "00:00" }
        
        let formattedSeconds = game.seconds / 3600
        let average = Double(formattedSeconds) / Double(game.sessionCount)
        
        let totalMinutes = Int(average * 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func fetchHabits() async {
        fetchedHabits = await HabitManager.shared.fetchHabits()
    }
    
    func findMostComplietableHabits(of habits: [HabitFirestore]) -> [HabitFirestore] {
        let mostComplietableHabits = Array(habits.sorted { $0.amountOfComletion > $1.amountOfComletion }.prefix(3))
        return mostComplietableHabits
    }
    
    func findLargestStreaks(of habits: [HabitFirestore]) -> [HabitFirestore] {
        let largestStreaks = Array(habits.sorted { $0.streak > $1.streak }.prefix(3))
        return largestStreaks
    }
}
