//
//  CustomModifires.swift
//  Restarted
//
//  Created by metalWillHelpYou on 13.02.2025.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .padding(.trailing)
            .padding(.leading, 8)
            .background(Color.gray.opacity(0.4))
            .foregroundStyle(Color.highlight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .keyboardType(.emailAddress)
    }
}

extension View {
    func withTextFieldModifires() -> some View {
        modifier(TextFieldModifier())
    }
}

struct AnimatedButtonModifires: ViewModifier {
    let stateObserver: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(!stateObserver ? Color.text : Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .strokeBackground(!stateObserver ? Color.highlight : Color.gray)
            .animation(.easeInOut(duration: 0.3), value: stateObserver)
    }
}

extension View {
    func withAnimatedButtonFormatting(_ stateObserver: Bool) -> some View {
        modifier(AnimatedButtonModifires(stateObserver: stateObserver))
    }
}

struct SinpleButtonModifires: ViewModifier {
    let foregroundStyle: Color
    let strokeBackground: Color
    
    init(foregroundStyle: Color, strokeBackground: Color = .highlight) {
        self.foregroundStyle = foregroundStyle
        self.strokeBackground = strokeBackground
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundStyle)
            .padding()
            .padding(.horizontal)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .strokeBackground(strokeBackground)
    }
}

extension View {
    func withSimpleButtonFormatting(foregroundStyle: Color, strokeBackground: Color = .highlight) -> some View {
        modifier(SinpleButtonModifires(foregroundStyle: foregroundStyle, strokeBackground: strokeBackground))
    }
}

struct AnswerButtonModifires: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.text)
            .strokeBackground(Color.highlight)
            .padding(.horizontal)
    }
}

extension View {
    func withAnswerButtonFormatting() -> some View {
        modifier(AnswerButtonModifires())
    }
}
