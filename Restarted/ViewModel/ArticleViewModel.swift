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
    private let manager = ArticleManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        manager.$articles
            .receive(on: RunLoop.main)
            .sink { [weak self] articles in
                self?.savedArticles = articles
            }
            .store(in: &cancellables)
    }
    
    func startListening() {
        ArticleManager.shared.startListeningToArticles()
    }
    
    func stopListening() {
        ArticleManager.shared.stopListeningToArticles()
    }

    func toggleReadStatus(for articleId: String) {
        guard let index = savedArticles.firstIndex(where: { $0.id == articleId }) else {
            return
        }
        
        savedArticles[index].isRead.toggle()
        let updatedIsRead = savedArticles[index].isRead
        
        Task {
            do {
                try await ArticleManager.shared.updateReadStatus(
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
