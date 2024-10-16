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
            QGDiaryView()
        }
        .multilineTextAlignment(.center)
        .background(Color.background)
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            let seconds = 10 * 60
            timerVm.startTimer(seconds: seconds)
        }
        .onDisappear { timerVm.stopTimer() }
    }
}

#Preview {
    QuickGuideView()
        .environmentObject(TimerViewModel())
}
