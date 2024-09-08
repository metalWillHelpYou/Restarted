//
//  SetHabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct SetHabitView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var titleString: String = ""
    @State private var goalText: String = ""
    
    var habit: Habit?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                title
                
                goalAndPeriod
                
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
}

extension SetHabitView {
    private var title: some View {
        VStack {
            TextField("Enter habit title...", text: $titleString)
                .padding(.leading, 8)
                .frame(width: 200, height: 40)
                .foregroundStyle(.blue)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var goalAndPeriod: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Time goal")
                    .font(.title2).bold()
                
                TextField("Type here your goal", text: $goalText)
                    .padding(.leading, 8)
                    .frame(height: 40)
                    .foregroundStyle(.blue)
                    .background(Color.highlight.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Period")
                    .font(.title2).bold()
            }
        }
    }
    
    
    private var timeRange: some View {
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
    
    private var remindersSetup: some View {
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
    
    private var saveButton: some View {
        Button(action: {
            //habitVm.addHabit(titleString, goal: Int32(goalText) ?? 0)
            dismiss()
        }) {
            Text("Save habit")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.highlight)
                .foregroundStyle(Color.text)
                .cornerRadius(15)
        }
    }
}

#Preview {
    SetHabitView(habit: nil)
        .environmentObject(HabitEntityViewModel())
}
