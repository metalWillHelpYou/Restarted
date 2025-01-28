//
//  ShortTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.11.2024.
//

import Foundation
import SwiftUI

final class ShortTestViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [ShortTestAnswers?]
    @Published var result: TestResult? = nil
    @Published var isTestCompleted: Bool = false
    
    private let questions = ShortTestQuestions.allCases
    
    init() {
        self.selectedAnswers = Array(repeating: nil, count: questions.count)
    }
    
    var currentQuestion: LocalizedStringKey {
        questions[currentQuestionIndex].rawValue
    }
    
    func selectAnswer(_ answer: ShortTestAnswers) {
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
            case .never:
                answerScore = 1
            case .rarely:
                answerScore = 2
            case .sometimes:
                answerScore = 3
            case .often:
                answerScore = 4
            case .veryOften:
                answerScore = 5
            }
            
            totalScore += answerScore
        }
        
        let conclusion: LocalizedStringKey
        if totalScore >= 32 {
            conclusion = """
            High risk of gaming addiction based on DSM-5 criteria.
            
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
