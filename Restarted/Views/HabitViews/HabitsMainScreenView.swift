//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @State private var showHabitListView: Bool = false
    @State private var selectedHabit: HabitFirestore? = nil
    @State private var showDeleteHabitFromActive: Bool = false
    @State private var isHabitComplete: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                circleSection
                
                if viewModel.savedHabits.filter({ $0.isActive }).count > 0 {
                    List {
                        ForEach(viewModel.savedHabits.filter({ $0.isActive })) { habit in
                            HStack {
                                Button {
                                    Task {
                                        await viewModel.markAsDone(habit.id)
                                    }
                                } label: {
                                    Image(systemName: "circle")
                                }
                                
                                Text(habit.title)
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.background)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Delete") {
                                    selectedHabit = habit
                                    showDeleteHabitFromActive.toggle()
                                }
                                .tint(.red)
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
                        NavigationLink(destination: HabitListView()) { PlusButton() }
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }
        .navigationTitle("Habits")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .task { await viewModel.fetchHabits() }
        .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.savedHabits.filter({ $0.isActive }).count > 0 {
                    NavigationLink(destination: HabitListView()) {
                        PlusButton()
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $showDeleteHabitFromActive) {
            if let habit = selectedHabit {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.removeHabitFromActive(habitId: habit.id)
                    }
                }
            }
        }
    }
}

extension HabitsMainScreenView {
    private var circleSection: some View {
        VStack {
            Circle()
                .stroke(Color.highlight, lineWidth: 4)
                .frame(width: 300, height: 300)
                .padding()
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
}

#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitViewModel())
}
