//
//  LongTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.11.2024.
//

import Foundation
import SwiftUI

final class LongTestViewModel: ObservableObject {
    // Index of question currently displayed
    @Published var currentQuestionIndex: Int = 0
    // Stores selected answers, nil when unanswered
    @Published var selectedAnswers: [LongTestAnswers?]
    // Final computed result after completion
    @Published var result: TestResult? = nil
    // Indicates completion state for UI
    @Published var isTestCompleted: Bool = false
    
    private let questions = LongTestQuestions.allCases
    
    init() { self.selectedAnswers = Array(repeating: nil, count: questions.count) }
    
    // Localized text of current question
    var currentQuestion: LocalizedStringKey { questions[currentQuestionIndex].rawValue }
    
    // Records answer and moves to next question or finishes test
    func selectAnswer(_ answer: LongTestAnswers) {
        selectedAnswers[currentQuestionIndex] = answer
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else { calculateResult() }
    }
    
    // Computes total score and diagnostic conclusion
    private func calculateResult() {
        var total = 0
        for answer in selectedAnswers.compactMap({ $0 }) {
            switch answer {
            case .stronglyDisagree: total += 1
            case .disagree: total += 2
            case .neitherAgreeNorDisagree: total += 3
            case .agree: total += 4
            case .stronglyAgree: total += 5
            }
        }
        
        let conclusion: LocalizedStringKey
        if total >= 71 {
            conclusion = """
            High risk of gaming addiction detected based on your test score.
            
            It is strongly recommended to consult a specialist.
            """
        } else {
            conclusion = """
            No signs of gaming addiction detected.
            
            Maintain healthy gaming habits to prevent future problems.
            """
        }
        
        result = TestResult(totalScore: total, conclusion: conclusion)
    }
    
    // Moves back one question when possible
    func showPreviousQuestion() { if currentQuestionIndex > 0 { currentQuestionIndex -= 1 } }
    // Resets all state to restart test
    func resetTest() {
        currentQuestionIndex = 0
        selectedAnswers = Array(repeating: nil, count: questions.count)
        result = nil
    }
}
