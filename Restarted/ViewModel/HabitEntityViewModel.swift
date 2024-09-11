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
    @Published var activeHabits: [Habit] = []
    @Published var selectedHabit: Habit? = nil
    @Published var showDeleteDialog: Bool = false
    
    init() {
        container = NSPersistentContainer(name: "HabitModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        fetchHabits()
        fetchActiveHabits()
    }

    func fetchHabits() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.title, ascending: true)]
        do {
            savedHabits = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching habits: \(error)")
        }
    }
    
    func fetchActiveHabits() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        request.predicate = NSPredicate(format: "isActive == YES")
        do {
            activeHabits = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching active habits: \(error)")
        }
    }
    
    func addHabitToActive(_ habit: Habit) {
        habit.isActive = true
        saveData()
        fetchActiveHabits()
    }
    
    func removeHabitFromActive(_ habit: Habit) {
        habit.isActive = false
        saveData()
        fetchActiveHabits()
    }
    
    func addHabit(_ habit: String, goal: Int32) {
        let newHabit = Habit(context: container.viewContext)
        newHabit.title = habit
        newHabit.goal = goal
        
        saveData()
    }
    
    func editHabit(entity: Habit, newTitle: String, newGoal: Int32) {
        entity.title = newTitle
        entity.goal = newGoal
        
        saveData()
    }
    
    func deleteHabit(_ habit: Habit) {
        container.viewContext.delete(habit)
        
        saveData()
    }

    func performDelete() {
        if let habitToDelete = selectedHabit {
            deleteHabit(habitToDelete)
            removeHabitFromActive(habitToDelete)
        }
        cancelDelete()
    }
    
    func confirmDelete(_ habit: Habit?) {
        selectedHabit = habit
        showDeleteDialog = true
    }

    func cancelDelete() {
        selectedHabit = nil
        showDeleteDialog = false
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

