//
//  ShortTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.11.2024.
//

import Foundation

final class ShortTestViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [ShortTestAnswers?]
    @Published var result: TestResult? = nil
    @Published var isTestCompleted: Bool = false
    
    private let questions = ShortTestQuestions.allCases
    
    init() {
        self.selectedAnswers = Array(repeating: nil, count: questions.count)
    }
    
    var currentQuestion: String {
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
        // Подсчет выполненных критериев
        var fulfilledCriteriaCount = 0

        for answer in selectedAnswers {
            guard let answer = answer else { continue }
            
            if answer == .veryOften {
                fulfilledCriteriaCount += 1
            }
        }

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

