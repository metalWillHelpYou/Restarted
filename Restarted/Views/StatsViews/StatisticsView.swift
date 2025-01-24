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
                                    .stroke(Color.pie, lineWidth: 20)
                                    .rotationEffect(.degrees(-90))

                                Circle()
                                    .trim(from: CGFloat(viewModel.habitPercentage / 100),
                                          to: CGFloat((viewModel.habitPercentage + viewModel.gamePercentage) / 100))
                                    .stroke(Color.highlight, lineWidth: 20)
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 150, height: 150)
                            .padding()
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Practice: \(String(format: "%.0f", viewModel.habitPercentage))%")
                                    .font(.headline)
                                    .foregroundColor(Color.pie)
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
                            
                            // — Average session duration —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Average session duration")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
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
                            .padding(8)
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // — Sessions —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Sessions")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.topGamesByLaunches()) { game in
                                    HStack {
                                        Text(game.title)
                                        Spacer()
                                        Text("\(game.sessionCount)")
                                    }
                                }
                            }
                            .padding(8)
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // — Hours —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Hours")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.topGamesByTotalTime()) { game in
                                    HStack {
                                        Text(game.title)
                                        Spacer()
                                        Text(TimeTools.convertSecondsToHoursMinutes(game.seconds))
                                    }
                                }
                            }
                            .padding(8)
                        }
                        .padding()
                        .strokeBackground(Color.highlight)
                    }
                    
                    // MARK: - Habit Statistics
                    if viewModel.habits.isEmpty == false {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Practice")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.highlight)
                            
                            // — Average practice duration —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Average practice duration")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
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
                            .padding(8)
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // — Completions —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Completions")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
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
                            .padding(8)
                            
                            Divider()
                                .frame(height: 2)
                                .background(Color.highlight)
                            
                            // — Habit hours —
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Practice hours")
                                    .font(.headline)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.topHabitsByTotalTime()) { habit in
                                    HStack {
                                        Text(habit.title)
                                        Spacer()
                                        Text(TimeTools.convertSecondsToHoursMinutes(habit.seconds))
                                    }
                                }
                            }
                            .padding(8)
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
}

// MARK: - Preview
#Preview {
    StatisticsView()
}
