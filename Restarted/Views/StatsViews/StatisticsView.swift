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
            VStack {
                if viewModel.hasSufficientGameData() || viewModel.hasSufficientHabitData() {
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Average session duration")
                                    .font(.title3)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.fetchedGames.filter { viewModel.findAverageGameSessionTime(in: $0) != "00:00" }) { game in
                                    HStack {
                                        Text(game.title)
                                        
                                        Spacer()
                                        
                                        Text(viewModel.findAverageGameSessionTime(in: game))
                                    }
                                }
                            }
                            .padding()
                            .strokeBackground(Color.highlight)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Top of sessions")
                                        .font(.title3)
                                        .foregroundStyle(Color.highlight)
                                    
                                    ForEach(viewModel.findTheLargestNumberOfGameLaunches(of: viewModel.fetchedGames)) { game in
                                        HStack {
                                            
                                            Text(game.title)
                                            
                                            Spacer()
                                            Text("\(game.sessionCount)")
                                        }
                                    }
                                }
                                .padding()
                                .strokeBackground(Color.highlight)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Top of hours")
                                        .font(.title3)
                                        .foregroundStyle(Color.highlight)
                                    
                                    ForEach(viewModel.findTheLargestNumberOfGameTime(of: viewModel.fetchedGames)) { game in
                                        HStack {
                                            
                                            Text(game.title)
                                            
                                            Spacer()
                                            Text("\(TimeTools.convertSecondsToHours(game.seconds))")
                                        }
                                    }
                                }
                                .padding()
                                .strokeBackground(Color.highlight)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Top of habit completions")
                                    .font(.title3)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.findMostComplietableHabits(of: viewModel.fetchedHabits)) { habit in
                                    HStack {
                                        
                                        Text(habit.title)
                                        
                                        Spacer()
                                        Text("\(habit.amountOfComletion)")
                                    }
                                }
                            }
                            .padding()
                            .strokeBackground(Color.highlight)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Top of habit streaks")
                                    .font(.title3)
                                    .foregroundStyle(Color.highlight)
                                
                                ForEach(viewModel.findLargestStreaks(of: viewModel.fetchedHabits)) { habit in
                                    HStack {
                                        
                                        Text(habit.title)
                                        
                                        Spacer()
                                        Text("\(habit.streak)")
                                    }
                                }
                            }
                            .padding()
                            .strokeBackground(Color.highlight)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                } else {
                    Text("To display statistics, you need to track at least 3 games or 3 habits.")
                        .padding()
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Statistics")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
            .task { await viewModel.fetchGames() }
            .task { await viewModel.fetchHabits() }
        }
    }
}

#Preview {
    StatisticsView()
}
