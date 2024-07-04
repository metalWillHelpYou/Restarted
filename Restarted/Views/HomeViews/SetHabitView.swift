//
//  SetHabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct SetHabitView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                //GoalAndPeriodView()
                
                timeRange
                
                remindersSetup
                
                Spacer()
                
                saveButton
            }
            .navigationTitle("Setup Habit")
            .padding()
            .background(Color.background)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    var timeRange: some View {
        VStack(alignment: .leading) {
            Text("Time Range")
                .font(.title2).bold()
            
            HStack(spacing: 12) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 100, height: 40)
                        .foregroundStyle(Color.highlight)
                }
            }
        }
        .padding(.vertical)
    }
    
    var remindersSetup: some View {
        VStack(alignment: .leading) {
            Text("Reminders")
                .font(.title2).bold()
            
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 40)
                    .foregroundStyle(Color.highlight)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 40)
                    .foregroundStyle(Color.highlight)
            }
        }
        .padding(.vertical)
    }
    
    var saveButton: some View {
        Button(action: {
        }) {
            Text("Save habit")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.highlight)
                .foregroundColor(userTheme == .light ? .white : .black)
                .cornerRadius(15)
        }
    }
}

#Preview {
    SetHabitView()
}


