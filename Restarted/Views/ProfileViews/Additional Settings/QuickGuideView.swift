//
//  QuickGuideView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.10.2024.
//

import SwiftUI

struct QuickGuideView: View {
    @EnvironmentObject var timerVm: TimerViewModel
    
    var body: some View {
        TabView {
            QGHabitsView()
            QGArticlesView()
            QGTimerView()
            QGTestsView()
        }
        .multilineTextAlignment(.center)
        .background(Color.background)
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            let seconds = 10 * 60
            timerVm.selectRandomGame()
            timerVm.startTimer(seconds: seconds, forGameId: "nil")
        }
        .onDisappear { timerVm.stopTimer(forGameId: "nil") }
    }
}

#Preview {
    QuickGuideView()
        .environmentObject(TimerViewModel())
}
