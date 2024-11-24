//
//  IGDTestView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.11.2024.
//

import SwiftUI

struct IGDTestView<ViewModel: IGDTestViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @State private var isTestCompleted = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                if isTestCompleted {
                    resultScreen
                } else {
                    VStack(spacing: 16) {
                        question
                        
                        answers
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            previousQuestion
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            endTest
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension IGDTestView {
    private var question: some View {
        Text(viewModel.currentQuestion)
            .multilineTextAlignment(.leading)
            .font(.title2)
            .frame(maxHeight: 150)
            .padding(.horizontal)
    }
    
    private var answers: some View {
        ForEach(Answers.allCases, id: \.self) { answer in
            Button(action: {
                viewModel.selectAnswer(answer)
                if viewModel.result != nil {
                    isTestCompleted = true
                }
            }) {
                Text(answer.rawValue)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text)
                    .strokeBackground(Color.highlight)
                    .padding(.horizontal)
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
            isTestCompleted = false
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
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.text)
            .strokeBackground(Color.highlight)
            .padding(.horizontal)
        }
    }
}

struct LongTestView: View {
    var body: some View {
        IGDTestView(viewModel: LongTestViewModel())
    }
}

struct ShortTestView: View {
    var body: some View {
        IGDTestView(viewModel: ShortTestViewModel())
    }
}

#Preview {
    LongTestView()
}

#Preview {
    ShortTestView()
}
