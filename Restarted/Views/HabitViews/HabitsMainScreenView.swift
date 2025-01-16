//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @State private var showAddHabit: Bool = false
    @State private var showEditHabit: Bool = false
    @State private var showDeleteHabit: Bool = false
    @State private var showAddTime: Bool = false
    @State private var selectedHabit: HabitFirestore? = nil

    var body: some View {
        NavigationStack {
            VStack {
                circleSection
                
                if !viewModel.savedHabits.isEmpty {
                    List {
                        ForEach(viewModel.savedHabits) { habit in
                            NavigationLink(destination: StopwatchView(habit: habit), label: {
                                Text(habit.title)
                            })
                            .padding(.vertical, 8)
                            .listRowBackground(Color.background)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Delete") {
                                    selectedHabit = habit
                                    showDeleteHabit.toggle()
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Add time") {
                                    selectedHabit = habit
                                    showAddTime.toggle()
                                }
                                .tint(.gray)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Edit") {
                                    selectedHabit = habit
                                    showEditHabit.toggle()
                                }
                                .tint(.orange)
                            }
                        }
                        .listRowSeparatorTint(Color.highlight)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                    HStack {
                        Text("Your new life starts here")
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .transition(.opacity)
                        addButton
                    }
                    Spacer()
                }
            }
            .navigationTitle("Habits")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .task {
                viewModel.calculateHabitTime()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.savedHabits.isEmpty {
                        addButton
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    sortHabits
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView()
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEditHabit) {
                if let habit = selectedHabit {
                    EditHabitView(habit: habit)
                        .presentationDetents([.fraction(0.2)])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showAddTime, content: {
                AddTimeView { seconds in
                    if let habit = selectedHabit {
                        Task {
                            await viewModel.addTimeTo(habitId: habit.id, time: seconds)
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            })
            .confirmationDialog("Are you sure?", isPresented: $showDeleteHabit) {
                if let habit = selectedHabit {
                    Button("Delete", role: .destructive) {
                        Task {
                            await viewModel.deleteHabit(with: habit.id)
                        }
                    }
                }
            }
        }
    }
}

extension HabitsMainScreenView {
    private var circleSection: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.highlight, lineWidth: 4)
                    .frame(width: 300, height: 300)
                    .padding()
                
                Text("\(viewModel.totalTime)")
            }
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showAddHabit.toggle()
        }) {
            PlusButton()
        }
    }
    
    private var sortHabits: some View {
        Menu {
            Button("Sort by Name") {
                viewModel.sortByTitle()
            }

            Button("Sort by Date") {
                viewModel.sortByDateAdded()
            }

            Button("Sort by Time") {
                viewModel.sortByTime()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundStyle(Color.highlight)
                .frame(width: 30, height: 30)
        }
    }
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitViewModel())
}
