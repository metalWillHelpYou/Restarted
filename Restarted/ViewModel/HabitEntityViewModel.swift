//
//  HabitEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.09.2024.
//

import Foundation
import CoreData

class HabitEntityViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedHabits: [Habit] = []
    
    init() {
        container = NSPersistentContainer(name: "HabitModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        fetchHabits()
    }
    
    func fetchHabits() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.title, ascending: true)]
        do {
            savedHabits = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching articles: \(error)")
        }
    }
    
    func addHabit(_ habit: String, goal: Int32) {
        let newHabit = Habit(context: container.viewContext)
        newHabit.title = habit
        newHabit.goal = goal
        
        saveData()
    }
    
    func editHabit(entity: Habit, newTitle: String) {
        entity.title = newTitle
        //newHabit.goal = goal
        
        saveData()
    }
    
    func deleteHabit(_ habit: Habit) {
        container.viewContext.delete(habit)
        
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchHabits()
        } catch let error {
            print("Error: \(error)")
        }
    }
}
