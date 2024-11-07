//
//  HabitViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.09.2024.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class HabitViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedHabits: [Habit] = []
    @Published var selectedHabit: Habit? = nil
    @Published var showDeleteDialog: Bool = false
    
    // Вычисляемое свойство для активных привычек
    var activeHabits: [Habit] {
        savedHabits.filter { $0.isActive }
    }
    
    // MARK: - Initializing and loading data
    init() {
        container = NSPersistentContainer(name: "HabitModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        fetchHabits() // Загружаем все привычки один раз
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
    
    // MARK: - Operations with habits
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
    
    // MARK: - Operations with active habits
    func addHabitToActive(_ habit: Habit) {
        habit.isActive = true
        saveData() // Сохраняем изменения
    }
    
    func removeHabitFromActive(_ habit: Habit) {
        habit.isActive = false
        saveData()
    }
    
    // MARK: - Saving data
    func saveData() {
        do {
            try container.viewContext.save()
            fetchHabits() // Обновляем список после сохранения
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // MARK: - Deletion and confirmation of deletion
    func performDelete() {
        if let habitToDelete = selectedHabit {
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
    
    // MARK: - Auxiliary functions for the UI
    func deleteButton(for habit: Habit?) -> some View {
        Button("Delete") { [self] in
            confirmDelete(habit)
        }
        .tint(.red)
    }
    
    func handleButtonAction(sheetModel: HabitSheetModel, habitTitle: String, goal: String, dismiss: () -> Void) {
        switch sheetModel.buttonType {
        case .add:
            if !habitTitle.isEmpty {
                addHabit(habitTitle, goal: Int32(goal) ?? 0)
                dismiss()
            }
        case .edit:
            if let habit = sheetModel.habit, !habitTitle.isEmpty {
                editHabit(entity: habit, newTitle: habitTitle, newGoal: Int32(goal) ?? 0 )
                dismiss()
            }
        }
    }
}
