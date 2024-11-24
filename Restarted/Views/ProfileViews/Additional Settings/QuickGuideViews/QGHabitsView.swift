//
//  QGHabitsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGHabitsView: View {
    @State private var shouldAnimate = false
    @State private var isCyclingCompleted = false
    @State private var isReadingCompleted = false
    @State private var isLearningCompleted = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Habit Tracker")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("Add goals and form healthy habits to balance your time in games. Choose from a list of habits or write your own.")
                .font(.title3)
                .padding(.bottom, 70)
            
            List {
                HStack {
                    Image(systemName: isCyclingCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("Cycling")
                        .strikethrough(isCyclingCompleted)
                    
                    Spacer()
                    
                    Text("12500m")
                        .foregroundStyle(Color.highlight)
                        .strikethrough(isCyclingCompleted)
                }
                .listRowBackground(Color.background)
                .listRowSeparatorTint(Color.highlight)
                
                HStack {
                    Image(systemName: isReadingCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("Reading")
                        .strikethrough(isReadingCompleted)
                    
                    Spacer()
                    
                    Text("1h")
                        .foregroundStyle(Color.highlight)
                        .strikethrough(isReadingCompleted)
                }
                .listRowBackground(Color.background)
                .listRowSeparatorTint(Color.highlight)
                
                HStack {
                    Image(systemName: isLearningCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("Learning Russian")
                        .strikethrough(isLearningCompleted)
                    
                    Spacer()
                    
                    Text("3h")
                        .foregroundStyle(Color.highlight)
                        .strikethrough(isLearningCompleted)
                }
                .listRowBackground(Color.background)
                .listRowSeparatorTint(Color.highlight)
            }
            .frame(maxHeight: 150)
            .listStyle(.plain)
            .scrollDisabled(true)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut) { isCyclingCompleted = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut) { isReadingCompleted = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut) { isLearningCompleted = true }
            }
        }
        .onDisappear {
            isCyclingCompleted = false
            isReadingCompleted = false
            isLearningCompleted = false
        }
    }
}

#Preview {
    QGHabitsView()
}
