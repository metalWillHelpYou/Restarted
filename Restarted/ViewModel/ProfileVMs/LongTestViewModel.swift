//
//  LongTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.11.2024.
//

import Foundation

final class LongTestViewModel: IGDTestViewModelProtocol {
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [Answers?]
    @Published var result: TestResult? = nil
    
    private let questions = LongTestQuestions.allCases
    
    init() {
        self.selectedAnswers = Array(repeating: nil, count: questions.count)
    }
    
    var currentQuestion: String {
        questions[currentQuestionIndex].rawValue
    }
    
    func selectAnswer(_ answer: Answers) {
        selectedAnswers[currentQuestionIndex] = answer
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            calculateResult()
        }
    }
    
    private func calculateResult() {
        let questionToCriteriaMap: [LongTestQuestions: Int] = [
            .question1: 0, .question7: 0,                   // Preoccupation
            .question4: 1, .question10: 1, .question16: 1,  // Withdrawal
            .question3: 2, .question9: 2,                   // Tolerance
            .question6: 3, .question12: 3, .question18: 3,  // Failure to Control
            .question5: 4, .question13: 4,                  // Loss of Interest
            .question20: 5,                                 // Continuation
            .question11: 6,                                 // Deception
            .question2: 7, .question8: 7, .question14: 7,   // Escape
            .question17: 8, .question19: 8, .question15: 8  // Loss of Opportunities
        ]

        // Массив для отслеживания выполнения критериев
        var criteriaFulfilled = Array(repeating: false, count: 9)

        // Проверка выполнения критериев
        for (index, answer) in selectedAnswers.enumerated() {
            guard let answer = answer else { continue }
            
            let question = LongTestQuestions.allCases[index]
            guard let criteriaIndex = questionToCriteriaMap[question] else { continue }

            if answer == .veryOften {
                criteriaFulfilled[criteriaIndex] = true
            }
        }
        
        // Подсчет выполненных критериев
        let fulfilledCriteriaCount = criteriaFulfilled.filter { $0 }.count

        // Заключение
        let conclusion: String
        if fulfilledCriteriaCount >= 5 {
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
        
        // Сохранение результата
        self.result = TestResult(totalScore: fulfilledCriteriaCount, conclusion: conclusion)
    }
}
