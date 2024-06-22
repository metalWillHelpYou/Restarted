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
                
                TimeRangeView()
                
                RemindersSetupView()
                
                Spacer()
                
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
            .padding()
            .navigationTitle("Setup Habit")
            .background(Color.background)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

#Preview {
    SetHabitView()
}


