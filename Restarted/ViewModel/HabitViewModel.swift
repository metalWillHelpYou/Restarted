//
//  HabitViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.09.2024.
//

import Foundation
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var selectedHabit: Habit? = nil
    @Published var showDeleteDialog: Bool = false
    
    // Подтверждение удаления привычки
    func confirmDelete(_ habit: Habit?) {
        selectedHabit = habit
        showDeleteDialog = true
    }
    
    // Отмена удаления привычки
    func cancelDelete() {
        selectedHabit = nil
        showDeleteDialog = false
    }
    
    // Удаление привычки из активных
    func performDelete(habitVm: HabitEntityViewModel) {
        if let habitToDelete = selectedHabit {
            habitVm.removeHabitFromActive(habitToDelete)
        }
        cancelDelete()
    }
    
    // Кнопка для удаления привычки
    func deleteButton(for habit: Habit?) -> some View {
        Button("Delete") { [self] in
            confirmDelete(habit)
        }
        .tint(.red)
    }
}
