//
//  QGTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGTimerView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    var body: some View {
        VStack {
            if timerVM.showEasterEgg {
                Spacer()
                Text("You're breathtaking!")
                    .font(.largeTitle)
                    .foregroundStyle(Color.highlight)
                    .padding(.vertical)
                
                Text("Your curiosity knows no bounds.")
                    .font(.title3)
                
                Spacer()
            } else {
                Spacer()
                Spacer()
                Text("Game Timer")
                    .font(.largeTitle)
                    .foregroundStyle(Color.highlight)
                    .padding(.vertical)
                
                Text("Timer allows you to track how much time you spend on games. Add your favorite games, set the timer and go ahead.")
                    .font(.title3)
                    .padding(.bottom, 40)
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: circleProgress)
                        .stroke(Color.highlight, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timerVM.timeRemaining)
                    
                    VStack {
                        Text(timerVM.currentGame)
                            .font(.headline)
                        
                        Text(timerVM.timeString())
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .frame(maxWidth: 280, maxHeight: 280)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
        .foregroundStyle(Color.primary)
    }
    
    private var circleProgress: CGFloat {
        let totalTime = 10 * 60
        return CGFloat(timerVM.timeRemaining) / CGFloat(totalTime)
    }
}

#Preview {
    QGTimerView()
        .environmentObject(TimerViewModel())
}
