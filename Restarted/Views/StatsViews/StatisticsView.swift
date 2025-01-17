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
                    if viewModel.games.isEmpty == false {
                        HStack {
                            ZStack {
                                Circle()
                                    .trim(from: 0, to: CGFloat(viewModel.habitPercentage / 100))
                                    .stroke(Color.mint, lineWidth: 20)
                                    .rotationEffect(.degrees(-90))

                                Circle()
                                    .trim(from: CGFloat(viewModel.habitPercentage / 100), to: CGFloat((viewModel.habitPercentage + viewModel.gamePercentage) / 100))
                                    .stroke(Color.highlight, lineWidth: 20)
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 150, height: 150)
                            .padding()
                            
                            Spacer()
                            
                            VStack {
                                Text("Habits: \(String(format: "%.0f", viewModel.habitPercentage))%")
                                    .font(.headline)
                                    .foregroundColor(Color.mint)
                                Text("Games: \(String(format: "%.0f", viewModel.gamePercentage))%")
                                    .font(.headline)
                                    .foregroundColor(Color.highlight)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                        
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
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // Top games by sessions and by total hours
                            statSection(title: "Sessions") {
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
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            statSection(title: "Hours") {
                                ForEach(
                                    viewModel.topGamesByTotalTime()
                                ) { game in
                                    HStack {
                                        Text(game.title)
                                        Spacer()
                                        Text(TimeTools.convertSecondsToHoursMinutes(game.seconds))
                                    }
                                }
                            }
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                    }
                    
                    // MARK: - Habit Statistics
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
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // Top habits by completions and by streaks
                            statSection(title: "Completions") {
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
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // Top habits by total hours
                            statSection(title: "Habit hours") {
                                ForEach(
                                    viewModel.topHabitsByTotalTime()
                                ) { habit in
                                    HStack {
                                        Text(habit.title)
                                        Spacer()
                                        Text(TimeTools.convertSecondsToHoursMinutes(habit.seconds))
                                    }
                                }
                            }
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                    }
                    
                    // MARK: - No Data Placeholder
                    if !viewModel.hasEnoughGameData()
                        && !viewModel.hasEnoughHabitData() {
                        Text("To display statistics, you need to track at least 1 games or 1 habits.")
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
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
        }
    }
    
    // MARK: - Reusable View for Sections
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
