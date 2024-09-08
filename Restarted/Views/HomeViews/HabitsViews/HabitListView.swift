//
//  HabitListView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct HabitListView: View {
    @State private var addHabit: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(HabitData.habits) { habit in
                    HabitView(habit: habit)
                }
                
                Button(action: {
                    addHabit.toggle()
                }, label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.highlight)
                            .frame(height: 72)
                            .background(.black)
                        
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                            .padding(.horizontal, 16)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.vertical, 4)
                })
            }
            .navigationTitle("Choose new habit")
            .padding(.horizontal)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .popover(isPresented: $addHabit, content: {
                SetHabitView()
            })
        }
    }
}

#Preview {
    HabitListView()
        .environmentObject(HabitEntityViewModel())
}
