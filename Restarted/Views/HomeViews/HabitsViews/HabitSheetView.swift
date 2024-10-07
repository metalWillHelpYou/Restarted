//
//  HabitSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct HabitSheetView: View {
    @EnvironmentObject var habitVm: HabitViewModel
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
        .onTapGesture { self.hideKeyboard() }
        .onAppear { initializeFields() }
    }
}

extension HabitSheetView {
    private func handleButtonAction() {
        switch sheetModel.buttonType {
        case .add:
            if !titleText.isEmpty, let goal = Int32(goalText) {
                habitVm.addHabit(titleText, goal: goal)
                dismiss()
            }
        case .edit:
            if let habit = sheetModel.habit, !titleText.isEmpty, let goal = Int32(goalText) {
                habitVm.editHabit(entity: habit, newTitle: titleText, newGoal: goal)
                dismiss()
            }
        }
    }
    
    private func initializeFields() {
        titleText = sheetModel.habit?.title ?? ""
        goalText = sheetModel.habit != nil ? String(sheetModel.habit?.goal ?? 0) : ""
    }
}


#Preview {
    HabitSheetView(sheetModel: .constant(HabitSheetModel(titleText: "", goalText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(HabitViewModel())
}
