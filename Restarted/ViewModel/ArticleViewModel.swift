//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import CoreData
import SwiftUI

@MainActor
final class ArticleViewModel: ObservableObject {
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
            print("Preloading articles for the first time")
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
    
    func preloadData() {
        let context = container.viewContext
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                print("Database is empty, preloading articles")
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
                
                try context.save()
                print("Preloaded articles saved successfully")
            } else {
                print("Articles already exist in database, skipping preload")
            }
        } catch {
            print("Error checking if database is empty: \(error)")
        }
    }


    func updateReadStatus(for article: Article, isRead: Bool) {
        article.isRead = isRead
        saveData()
        print("Updated read status for \(article.title ?? "Unknown") to \(isRead)")
    }

    func saveData() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                fetchArticles()
            } catch let error {
                print("Error saving data: \(error)")
            }
        }
    }
}
