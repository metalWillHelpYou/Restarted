//
//  LongTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.11.2024.
//

import Foundation
import SwiftUI

final class LongTestViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [LongTestAnswers?]
    @Published var result: TestResult? = nil
    @Published var isTestCompleted: Bool = false
    
    private let questions = LongTestQuestions.allCases
    
    init() {
        self.selectedAnswers = Array(repeating: nil, count: questions.count)
    }
    
    var currentQuestion: LocalizedStringKey {
        questions[currentQuestionIndex].rawValue
    }
    
    func selectAnswer(_ answer: LongTestAnswers) {
        selectedAnswers[currentQuestionIndex] = answer
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            calculateResult()
        }
    }
    
    private func calculateResult() {
        var totalScore: Int = 0
        for (_, answer) in selectedAnswers.enumerated() {
            guard let answer = answer else { continue }
            
            let answerScore: Int
            switch answer {
            case .stronglyDisagree:
                answerScore = 1
            case .disagree:
                answerScore = 2
            case .neitherAgreeNorDisagree:
                answerScore = 3
            case .agree:
                answerScore = 4
            case .stronglyAgree:
                answerScore = 5
            }
            
            totalScore += answerScore
        }
        
        let conclusion: LocalizedStringKey
        if totalScore >= 71 {
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
        
        self.result = TestResult(totalScore: totalScore, conclusion: conclusion)
    }
    
    func showPreviousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func resetTest() {
        currentQuestionIndex = 0
        selectedAnswers = Array(repeating: nil, count: selectedAnswers.count)
        result = nil
    }
}
