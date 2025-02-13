//
//  LongTestView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.01.2025.
//

import SwiftUI

struct LongTestView: View {
    @StateObject private var viewModel = LongTestViewModel()
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                if viewModel.isTestCompleted {
                    resultScreen
                } else {
                    VStack(spacing: 16) {
                        question
                        
                        answers
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            endTest
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            previousQuestion
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension LongTestView {
    private var question: some View {
        Text(viewModel.currentQuestion)
            .multilineTextAlignment(.leading)
            .font(.title2)
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var answers: some View {
        ForEach(LongTestAnswers.allCases, id: \.self) { answer in
            Button(action: {
                viewModel.selectAnswer(answer)
                if viewModel.result != nil {
                    viewModel.isTestCompleted  = true
                }
            }) {
                Text(answer.rawValue)
                    .withAnswerButtonFormatting()
            }
        }
    }
    
    private var previousQuestion: some View {
        Button(action: {
            viewModel.showPreviousQuestion()
        }, label: {
            Image(systemName: "arrow.uturn.backward")
        })
    }
    
    private var endTest: some View {
        Button(action: {
            dismiss()
            viewModel.resetTest()
            viewModel.isTestCompleted = false
        }, label: {
            Image(systemName: "multiply")
        })
    }
    
    private var resultScreen: some View {
        VStack {
            if let result = viewModel.result {
                Text("Result")
                    .font(.largeTitle)
                    .padding()
                
                Text("Score: \(result.totalScore)")
                    .font(.headline)
                
                Text(result.conclusion)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button("Try again") {
                dismiss()
                viewModel.resetTest()
            }
            .withSimpleButtonFormatting(foregroundStyle: Color.text)
            .padding(.horizontal)
        }
    }
}

#Preview {
    LongTestView()
}
