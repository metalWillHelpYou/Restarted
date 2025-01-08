//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @State private var showAddHabit: Bool = false
    @State private var selectedHabit: HabitFirestore?
    @State private var showDeleteHabit: Bool = false
    @State private var showEditHabit: Bool = false
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.savedHabits) { habit in
                        HStack {
                            Text(habit.title)
                            Spacer()
                            
                            Button {
                                Task {
                                    await viewModel.addHabitToActive(habitId: habit.id)
                                }
                            } label: {
                                Image(systemName: viewModel.isHabitActive ? "checkmark.circle.fill" : "plus")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .listRowBackground(Color.background)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete") {
                                selectedHabit = habit
                                showDeleteHabit.toggle()
                            }
                            .tint(.red)
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
            }
            .navigationTitle("Available Habits")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddHabit.toggle()
                    } label: {
                        PlusButton()
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
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

#Preview {
    HabitListView()
        .environmentObject(HabitViewModel())
}

struct AddHabitView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            TextField("New habit", text: $viewModel.habitTitleHandler)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    await viewModel.addHabit(viewModel.habitTitleHandler)
                }
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(!viewModel.habitTitleHandler.isEmpty ? Color.text : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(!viewModel.habitTitleHandler.isEmpty ? Color.highlight : Color.gray)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.habitTitleHandler)
            })
            .disabled(viewModel.habitTitleHandler.isEmpty)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.background)
    }
}
