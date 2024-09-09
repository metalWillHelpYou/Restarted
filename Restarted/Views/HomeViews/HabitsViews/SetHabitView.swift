//
//  SetHabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct SetHabitView: View {
    @EnvironmentObject var habitVm: HabitEntityViewModel  // ViewModel для управления привычками
    @Environment(\.dismiss) var dismiss  // Для закрытия представления

    @State private var titleString: String = ""  // Название привычки
    @State private var goalText: String = ""  // Цель (число)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                titleSection  // Секция с полем ввода названия привычки
                
                goalAndPeriodSection  // Секция для цели и периода
                
                Spacer()
                
                saveButton  // Кнопка сохранения привычки
            }
            .padding()
            .padding(.top)
            .background(Color.background)
            .onTapGesture {
                self.hideKeyboard()  // Скрыть клавиатуру при касании вне текстовых полей
            }
        }
    }
}

// MARK: - Components
extension SetHabitView {
    // Секция для ввода названия привычки
    private var titleSection: some View {
        VStack {
            TextField("Enter habit title...", text: $titleString)
                .padding(.leading, 8)
                .frame(height: 40)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // Секция для ввода цели и периода
    private var goalAndPeriodSection: some View {
        VStack {
            HStack {
                Text("Time goal")
                    .font(.title2).bold()
                
                Spacer()
                
                Text("Period")
                    .font(.title2).bold()
            }
            
            HStack {
                TextField("Type here your goal", text: $goalText)
                    .padding(.leading, 8)
                    .frame(width: 180, height: 40)
                    .foregroundStyle(.black)
                    .background(Color.highlight.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .keyboardType(.numberPad)
                    .onChange(of: goalText) { oldValue, newValue in
                        goalText = newValue.filter { $0.isNumber }  // Очищаем нечисловые символы
                    }
                
                Spacer()
                
                Menu("Select period") {
                    Button("Day") {
                        // Логика для выбора дня
                    }
                    
                    Button("Week") {
                        // Логика для выбора недели
                    }
                }
            }
        }
    }
    
    // Кнопка сохранения привычки
    private var saveButton: some View {
        Button(action: {
            // Добавляем привычку в ViewModel
            habitVm.addHabit(titleString, goal: Int32(goalText) ?? 0)
            dismiss()  // Закрываем представление после сохранения
        }) {
            Text("Save habit")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.highlight)
                .foregroundStyle(Color.text)
                .cornerRadius(15)
        }
    }
}

// Превью экрана SetHabitView
#Preview {
    SetHabitView()
        .environmentObject(HabitEntityViewModel())  // Подключаем ViewModel
}
