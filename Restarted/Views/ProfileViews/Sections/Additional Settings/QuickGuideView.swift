//
//  QuickGuideView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.10.2024.
//

import SwiftUI

struct QuickGuideView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    
    var body: some View {
        TabView {
            QGHabitsView()
            QGArticlesView()
            QGTimerView()
            QGDiaryView()
        }
        .multilineTextAlignment(.center)
        .background(Color.background)
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            timerVM.selectRandomGame()
            timerVM.startTimer(hours: 0, minutes: 10)
        }
        .onDisappear { timerVM.stopTimer() }
    }
}

#Preview {
    QuickGuideView()
        .environmentObject(TimerViewModel())
}
