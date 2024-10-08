//
//  FakeHabitView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 31.05.2024.
//

import SwiftUI

struct FakeHabitView: View {
    let habit: FakeHabit
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
                .frame(height: 72)
                .background(.black)
            
            Image(habit.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .opacity(0.4)
            
            Text(habit.title)
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical, 4)
    }
}

#Preview {
    FakeHabitView(habit: FakeHabit(title: "Title", imageName: "Breathing"))
        .environmentObject(HabitViewModel())
}
