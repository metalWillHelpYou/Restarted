//
//  ShortTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.11.2024.
//

import Foundation
import SwiftUI

// Runs 9‑question IGD short test and produces result
final class ShortTestViewModel: ObservableObject {
    // Index of currently displayed question
    @Published var currentQuestionIndex: Int = 0
    // Stores chosen answers, nil when unanswered
    @Published var selectedAnswers: [ShortTestAnswers?]
    // Final aggregated result shown after completion
    @Published var result: TestResult? = nil
    // Drives UI flow end state
    @Published var isTestCompleted: Bool = false
    
    private let questions = ShortTestQuestions.allCases
    
    init() { selectedAnswers = Array(repeating: nil, count: questions.count) }
    
    // Localized text of active question
    var currentQuestion: LocalizedStringKey { questions[currentQuestionIndex].rawValue }
    
    // Records answer and advances or calculates outcome
    func selectAnswer(_ answer: ShortTestAnswers) {
        selectedAnswers[currentQuestionIndex] = answer
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            calculateResult()
        }
    }
    
    // Computes risk score and conclusion string
    private func calculateResult() {
        var total = 0
        for answer in selectedAnswers.compactMap({ $0 }) {
            switch answer {
            case .never: total += 1
            case .rarely: total += 2
            case .sometimes: total += 3
            case .often: total += 4
            case .veryOften: total += 5
            }
        }
        
        let conclusion: LocalizedStringKey
        if total >= 32
        {
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
    
    // Navigates to previous question when possible
    func showPreviousQuestion() { if currentQuestionIndex > 0 { currentQuestionIndex -= 1 } }
    // Resets indices and answers to restart test
    func resetTest() {
        currentQuestionIndex = 0
        selectedAnswers = Array(repeating: nil, count: questions.count)
        result = nil
    }
}
