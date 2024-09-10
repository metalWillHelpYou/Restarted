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
    @State private var titleText: String = ""
    @State private var goalText: String = ""
    @Binding var sheetModel: HabitSheetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            CustomTextField(placeholder: sheetModel.titleText, text: $titleText)
            
            HStack {
                Text("Time goal")
                    .font(.title2).bold()
                
                Spacer()
                
                Text("Period")
                    .font(.title2).bold()
            }
            
            HStack {
                CustomTextField(placeholder: sheetModel.goalText, text: $goalText)
                    .keyboardType(.numberPad)
                
                Spacer()
                
                Menu("Select period") {
                    Button("Day") { /* handle selection */ }
                    Button("Week") { /* handle selection */ }
                }
            }
            
            Spacer()
            
            CustomButton(title: sheetModel.buttonLabel) {
                handleButtonAction()
            }
        }
        .padding()
        .background(Color.background)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    private func handleButtonAction() {
        switch sheetModel.buttonType {
        case .add:
            habitVm.addHabit(sheetModel.titleText, goal: Int32(sheetModel.goalText) ?? 0)
            dismiss()
        case .edit:
            if let habit = sheetModel.habit {
                habitVm.editHabit(entity: habit, newTitle: sheetModel.titleText, newGoal: Int32(sheetModel.goalText) ?? 0)
                dismiss()
            }
        }
    }
}

#Preview {
    SetHabitView(sheetModel: .constant(HabitSheetModel(titleText: "", goalText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(HabitEntityViewModel())
}
