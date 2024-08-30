//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import CoreData
import SwiftUI

class ArticleEntityViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedArticles: [Article] = []

    init() {
        container = NSPersistentContainer(name: "ArticleModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        let hasPreloaded = UserDefaults.standard.bool(forKey: "hasPreloadedData")
        
        if !hasPreloaded {
            preloadData()
            UserDefaults.standard.set(true, forKey: "hasPreloadedData")
        }
        
        fetchArticles()
    }
    
    func fetchArticles() {
        let request = NSFetchRequest<Article>(entityName: "Article")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Article.title, ascending: true)]
        
        do {
            savedArticles = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching articles: \(error)")
        }
    }
    
    private func isDatabaseEmpty() -> Bool {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let count = try container.viewContext.count(for: fetchRequest)
            return count == 0
        } catch {
            return true
        }
    }
    
    private func preloadData() {
        clearExistingData()
        
        let context = container.viewContext
        
        let articles = [
            (title: "Article 1", content: "Content for article 1", isRead: false),
            (title: "Article 2", content: "Content for article 2", isRead: false)
        ]
        
        for articleData in articles {
            let article = Article(context: context)
            article.title = articleData.title
            article.content = articleData.content
            article.isRead = articleData.isRead
        }
        
        do {
            try context.save()
        } catch let error {
            print("Error saving preloaded data: \(error)")
        }
    }

    private func clearExistingData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Article.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting existing data: \(error)")
        }
    }

    func markArticleAsRead(_ article: Article) {
        article.isRead = true
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchArticles()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
