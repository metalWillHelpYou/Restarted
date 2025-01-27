//
//  PracticesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct PracticeMainScreenView: View {
    @EnvironmentObject var viewModel: PracticeViewModel
    @State private var showAddPractice: Bool = false
    @State private var showEditPractice: Bool = false
    @State private var showDeletePractice: Bool = false
    @State private var showAddTime: Bool = false
    @State private var selectedPractice: PracticeFirestore? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.savedPractices.isEmpty {
                    List {
                        ForEach(viewModel.savedPractices) { practice in
                            NavigationLink(destination: StopwatchView(practice: practice), label: {
                                Text(practice.title)
                            })
                            .padding(.vertical, 8)
                            .listRowBackground(Color.background)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Delete") {
                                    selectedPractice = practice
                                    showDeletePractice.toggle()
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Add time") {
                                    selectedPractice = practice
                                    showAddTime.toggle()
                                }
                                .tint(.gray)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Edit") {
                                    selectedPractice = practice
                                    showEditPractice.toggle()
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
            .navigationTitle("Practice")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.savedPractices.isEmpty {
                        addButton
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    sortPractices
                }
            }
            .sheet(isPresented: $showAddPractice) {
                AddPracticeView()
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEditPractice) {
                if let practice = selectedPractice {
                    EditPracticeView(practice: practice)
                        .presentationDetents([.fraction(0.2)])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showAddTime, content: {
                AddTimeView { seconds in
                    if let practice = selectedPractice {
                        Task {
                            await viewModel.addTimeTo(practiceId: practice.id, time: seconds)
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            })
            .confirmationDialog("Are you sure?", isPresented: $showDeletePractice) {
                if let practice = selectedPractice {
                    Button("Delete", role: .destructive) {
                        Task {
                            await viewModel.deletePractice(with: practice.id)
                        }
                    }
                }
            }
        }
    }
}

extension PracticeMainScreenView {
    private var addButton: some View {
        Button(action: {
            showAddPractice.toggle()
        }) {
            PlusButton()
        }
    }
    
    private var sortPractices: some View {
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
    PracticeMainScreenView()
        .environmentObject(PracticeViewModel())
}
