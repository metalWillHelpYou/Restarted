//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ArticleViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []
    
    private let firestoreService: FirestoreService
    
    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    func fetchArticles() async {
        savedArticles = await firestoreService.fetchArticles()
    }
}
