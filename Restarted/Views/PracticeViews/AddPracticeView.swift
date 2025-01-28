//
//  SecondaryPracticeView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct AddPracticeView: View {
    @EnvironmentObject var viewModel: PracticeViewModel
    @Environment (\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        VStack {
            TextField("New practice", text: $viewModel.practiceTitleInput)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    await viewModel.addPractice(with: viewModel.practiceTitleInput)
                }
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(!viewModel.practiceTitleInput.isEmpty ? Color.text : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(!viewModel.practiceTitleInput.isEmpty ? Color.highlight : Color.gray)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.practiceTitleInput)
            })
            .disabled(viewModel.practiceTitleInput.isEmpty)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.background)
    }
}

struct EditPracticeView: View {
    @EnvironmentObject var viewModel: PracticeViewModel
    @Environment (\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    let practice: Practice
    
    var body: some View {
        VStack {
            TextField("Edit practice", text: $viewModel.practiceTitleInput)
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                Task {
                    await viewModel.editPractice(practice.id, title: viewModel.practiceTitleInput)
                }
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(!viewModel.practiceTitleInput.isEmpty ? Color.text : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(!viewModel.practiceTitleInput.isEmpty ? Color.highlight : Color.gray)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.practiceTitleInput)
            })
            .disabled(viewModel.practiceTitleInput.isEmpty)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.background)
    }
}
