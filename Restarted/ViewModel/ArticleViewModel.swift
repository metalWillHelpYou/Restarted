//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import SwiftUI
import Combine

@MainActor
final class ArticleViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []
    
    private let articleManager = ArticleManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        articleManager.$articles
            .receive(on: RunLoop.main)
            .sink { [weak self] articles in
                self?.savedArticles = articles
            }
            .store(in: &cancellables)
    }
    
    func startObserving() {
        articleManager.startObservingArticles()
    }
    
    func stopObserving() {
        articleManager.stopObservingArticles()
    }

    func toggleReadStatus(for articleId: String) {
        guard let index = savedArticles.firstIndex(where: { $0.id == articleId }) else {
            return
        }
        
        savedArticles[index].isRead.toggle()
        let updatedIsRead = savedArticles[index].isRead
        
        Task {
            do {
                try await articleManager.updateReadStatus(
                    articleId: articleId,
                    isRead: updatedIsRead
                )
            } catch {
                DispatchQueue.main.async {
                    self.savedArticles[index].isRead.toggle()
                }
                print("Error updating the reading status: \(error)")
            }
        }
    }
}
