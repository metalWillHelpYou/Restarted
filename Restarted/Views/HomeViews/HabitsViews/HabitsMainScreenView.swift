//
//  HabitsMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.09.2024.
//

import SwiftUI

struct HabitsMainScreenView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    @State private var showHabitListView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    //timeSection
                    
                    Spacer()
                    
                    habitListSection
                    
                    Spacer()
                }
                .navigationTitle("Active Habits")
                .toolbar {
                    NavigationLink(destination: HabitListView()) {
                        PlusButton()
                    }
                }
            }
        }
    }
}

extension HabitsMainScreenView {
    private var timeSection: some View {
        VStack {
            Circle()
                .stroke(Color.highlight, lineWidth: 4)
                .padding(40)
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
    
    private var habitListSection: some View {
        VStack {
            if habitVm.activeHabits.isEmpty {
                Text("No active habits. Add new ones!")
                    .font(.headline)
                    .foregroundStyle(.gray)
            } else {
                List {
                    ForEach(habitVm.activeHabits) { habit in
                        HStack {
                            Text(habit.title ?? "")
                            Spacer()
                            Button(action: {
                                habitVm.removeHabitFromActive(habit)
                            }) {
                                Text("Remove")
                                    .foregroundColor(.red)
                            }
                        }
                        .listRowBackground(Color.background)
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(Color.highlight)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}


#Preview {
    HabitsMainScreenView()
        .environmentObject(HabitEntityViewModel())
}
