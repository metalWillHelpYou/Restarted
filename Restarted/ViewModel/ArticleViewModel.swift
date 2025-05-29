//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import SwiftUI
import Combine

// Keeps article list in sync with Firestore state
@MainActor
final class ArticleViewModel: ObservableObject {
    // Articles currently displayed in UI
    @Published var savedArticles: [Article] = []
    
    // Manager responsible for network operations
    private let articleManager = ArticleManager.shared
    private var cancellables = Set<AnyCancellable>()

    // Subscribes to manager's publisher
    init() {
        articleManager.$articles
            .receive(on: RunLoop.main)
            .sink { [weak self] articles in
                self?.savedArticles = articles
            }
            .store(in: &cancellables)
    }
    
    // Begin real‑time Firestore observation
    func startObserving() {
        articleManager.startObservingArticles()
    }
    
    // Stop listening to changes
    func stopObserving() {
        articleManager.stopObservingArticles()
    }

    // Toggle read flag locally and persist change
    func toggleReadStatus(for articleId: String) {
        // Locate article in local array
        guard let index = savedArticles.firstIndex(where: { $0.id == articleId }) else { return }
        
        savedArticles[index].isRead.toggle()
        let updatedIsRead = savedArticles[index].isRead
        
        Task {
            do {
                try await articleManager.updateReadStatus(articleId: articleId, isRead: updatedIsRead)
            } catch {
                // Roll back on failure
                DispatchQueue.main.async { self.savedArticles[index].isRead.toggle() }
                print("Error updating status: \(error)")
            }
        }
    }
}
