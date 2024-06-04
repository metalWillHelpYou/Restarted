//
//  DataLoaderFromJSON.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.05.2024.
//

import Foundation

class DataLoaderFromJSON<T: Decodable>: ObservableObject {
    @Published var items: [T] = []
    private let filename: String
    
    init(filename: String) {
        self.filename = filename
        loadItems()
    }
    
    private func loadItems() {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let items = try decoder.decode([T].self, from: data)
                self.items = items
                print("Loaded items from \(filename)")
            } catch {
                print("Failed to load items: \(error.localizedDescription)")
            }
        } else {
            print("Failed to find \(filename).json in bundle")
        }
    }
}


