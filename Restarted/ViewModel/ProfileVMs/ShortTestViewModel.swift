//
//  ShortTestViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.11.2024.
//

import Foundation

final class ShortTestViewModel: IGDTestViewModelProtocol {
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [Answers?]
    @Published var result: TestResult? = nil
    
    private let questions = ShortTestQuestions.allCases
    
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
        let totalScore = selectedAnswers.compactMap { $0 }.reduce(0) { partialResult, answer in
            switch answer {
            case .never: return partialResult + 0
            case .rarely: return partialResult + 1
            case .sometimes: return partialResult + 2
            case .often: return partialResult + 3
            case .veryOften: return partialResult + 4
            }
        }
        
        let conclusion: String
        switch totalScore {
        case 0...5: conclusion = "Низкий уровень зависимости. У вас сбалансированное отношение к играм."
        case 6...10: conclusion = "Средний уровень зависимости. Рекомендуется пересмотреть своё отношение к играм."
        default: conclusion = "Высокий уровень зависимости. Пора принимать меры для снижения времени, проводимого за играми."
        }
        
        self.result = TestResult(totalScore: totalScore, conclusion: conclusion)
    }
}

