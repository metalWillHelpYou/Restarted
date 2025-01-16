//
//  StatisticsView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    // MARK: - Game Statistics
                    // Check if there are any games loaded in the ViewModel
                    if viewModel.games.isEmpty == false {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Games")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.highlight)
                            
                            // Average session duration for each game
                            statSection(title: "Average session duration") {
                                ForEach(viewModel.games.filter {
                                    viewModel.averageGameSessionTime(for: $0) != "00:00"
                                }) { game in
                                    HStack {
                                        Text(game.title)
                                        Spacer()
                                        Text(viewModel.averageGameSessionTime(for: game))
                                    }
                                }
                            }
                            
                            // Top games by sessions and by total hours
                            HStack(alignment: .top, spacing: 16) {
                                statSection(title: "Top of sessions") {
                                    ForEach(
                                        viewModel.topGamesByLaunches()
                                    ) { game in
                                        HStack {
                                            Text(game.title)
                                            Spacer()
                                            Text("\(game.sessionCount)")
                                        }
                                    }
                                }
                                
                                statSection(title: "Top of hours") {
                                    ForEach(
                                        viewModel.topGamesByTotalTime()
                                    ) { game in
                                        HStack {
                                            Text(game.title)
                                            Spacer()
                                            Text("\(TimeTools.convertSecondsToHours(game.seconds))h")
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                    }
                    
                    // MARK: - Habit Statistics
                    // Check if there are any habits loaded in the ViewModel
                    if viewModel.habits.isEmpty == false {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Habits")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.highlight)
                            
                            // Average habit duration
                            statSection(title: "Average habit duration") {
                                ForEach(viewModel.habits.filter {
                                    viewModel.averageHabitTime(for: $0) != "00:00"
                                }) { habit in
                                    HStack {
                                        Text(habit.title)
                                        Spacer()
                                        Text(viewModel.averageHabitTime(for: habit))
                                    }
                                }
                            }
                            
                            // Top habits by completions and by streaks
                            HStack(alignment: .top, spacing: 16) {
                                statSection(title: "Top of completions") {
                                    ForEach(
                                        viewModel.habits
                                            .sorted { $0.sessionCount > $1.sessionCount }
                                            .prefix(3)
                                    ) { habit in
                                        HStack {
                                            Text(habit.title)
                                            Spacer()
                                            Text("\(habit.sessionCount)")
                                        }
                                    }
                                }
                                
                                statSection(title: "Top of habit streaks") {
                                    ForEach(
                                        viewModel.topHabitsByStreak()
                                    ) { habit in
                                        HStack {
                                            Text(habit.title)
                                            Spacer()
                                            Text("\(habit.streak)")
                                        }
                                    }
                                }
                            }
                            
                            // Top habits by total hours
                            statSection(title: "Top of habit hours") {
                                ForEach(
                                    viewModel.topHabitsByTotalTime()
                                ) { habit in
                                    HStack {
                                        Text(habit.title)
                                        Spacer()
                                        Text("\(TimeTools.convertSecondsToHours(habit.seconds))h")
                                    }
                                }
                            }
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                    }
                    
                    // MARK: - No Data Placeholder
                    // If there's not enough data for both games and habits
                    if !viewModel.hasEnoughGameData()
                       && !viewModel.hasEnoughHabitData() {
                        Text("To display statistics, you need to track at least 3 games or 3 habits.")
                            .frame(maxWidth: .infinity)
                            .background(Color.background)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
                
                Spacer()
            }
            .navigationTitle("Statistics")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
//            .task {
//                await viewModel.loadGames()
//                await viewModel.loadHabits()
//            }
        }
    }
    
    // MARK: - Reusable View for Sections
    /// English comment: A helper method to create a styled section with title and content.
    @ViewBuilder
    private func statSection<Content: View>(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.highlight)
            content()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.background.opacity(0.1))
        )
    }
}

// MARK: - Preview
#Preview {
    StatisticsView()
}
