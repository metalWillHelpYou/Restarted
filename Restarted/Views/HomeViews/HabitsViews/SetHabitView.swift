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
    @Binding var sheetModel: HabitSheetModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                titleSection
                
                goalAndPeriodSection
                
                Spacer()
                
                saveButton
            }
            .padding()
            .padding(.top)
            .background(Color.background)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

extension SetHabitView {
    private var titleSection: some View {
        VStack {
            TextField("Enter habit title...", text: $titleString)
                .padding(.leading, 8)
                .frame(height: 40)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var goalAndPeriodSection: some View {
        VStack {
            HStack {
                Text("Time goal")
                    .font(.title2).bold()
                
                Spacer()
                
                Text("Period")
                    .font(.title2).bold()
            }
            
            HStack {
                TextField("Type here your goal", text: $goalText)
                    .padding(.leading, 8)
                    .frame(width: 180, height: 40)
                    .foregroundStyle(.black)
                    .background(Color.highlight.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .keyboardType(.numberPad)
                    .onChange(of: goalText) { oldValue, newValue in
                        goalText = newValue.filter { $0.isNumber }
                    }
                
                Spacer()
                
                Menu("Select period") {
                    Button("Day") {
                    }
                    
                    Button("Week") {
                    }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: handleButtonAction, label: {
            Text("Save habit")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.highlight)
                .foregroundStyle(Color.text)
                .cornerRadius(15)
        })
    }
}

extension SetHabitView {
    private func handleButtonAction() {
        switch sheetModel.buttonType {
        case .add:
            habitVm.addHabit(titleString, goal: Int32(goalText) ?? 0)
            titleString = ""
            goalText = ""
            dismiss()
        case .edit:
            if let habit = sheetModel.habit {
                habitVm.editHabit(entity: habit, newTitle: titleString, newGoal: Int32(goalText) ?? 0)
            dismiss()
            }
        }
    }
}

#Preview {
    SetHabitView(sheetModel: .constant(HabitSheetModel(titleText: "", goalText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(HabitEntityViewModel())
}
