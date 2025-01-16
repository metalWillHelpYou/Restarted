//
//  SecondaryHabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @Environment (\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
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
                    await viewModel.addHabit(with: viewModel.habitTitleHandler)
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

struct EditHabitView: View {
    @EnvironmentObject var viewModel: HabitViewModel
    @Environment (\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    let habit: HabitFirestore
    
    var body: some View {
        VStack {
            TextField("Edit habit", text: $viewModel.habitTitleHandler)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    await viewModel.editHabit(habit.id, title: viewModel.habitTitleHandler)
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
