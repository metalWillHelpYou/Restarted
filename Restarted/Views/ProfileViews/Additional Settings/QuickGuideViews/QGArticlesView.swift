//
//  QGArticlesView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGArticlesView: View {
    @State private var shouldAnimate = false
    @State private var isArticlechanged = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Articles")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("Read tips to better understand the problem and find ways to overcome it.")
                .font(.title3)
                .padding(.bottom, 70)
            
            ZStack {
                HStack {
                    Text("The first steps to understanding the problem")
                        .foregroundColor(Color.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.vertical, 26)
                    
                    Spacer()
                    
                    Image(systemName: isArticlechanged ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.highlight)
                        .padding()
                }
                .background(isArticlechanged ? Color.green.opacity(0.3) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .strokeBackground(Color.highlight)
                .padding(.horizontal)
                .animation(shouldAnimate ? .easeInOut(duration: 0.5) : nil, value: isArticlechanged)
                .onAppear {
                    shouldAnimate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isArticlechanged = true
                    }
                }
                .onDisappear {
                    shouldAnimate = false
                    isArticlechanged = false
                }
            }
            
            ZStack {
                HStack {
                    Text("How to recognize the signs of videogame addiction?")
                        .foregroundColor(Color.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.vertical, 26)
                    
                    Spacer()
                    
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.highlight)
                        .padding()
                }
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .strokeBackground(Color.highlight)
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    QGArticlesView()
}
