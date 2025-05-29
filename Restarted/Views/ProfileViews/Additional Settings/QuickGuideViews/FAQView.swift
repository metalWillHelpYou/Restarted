//
//  FAQView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.05.2025.
//

import SwiftUI
import MarkdownUI

struct FAQView: View {
    let markdown = NSLocalizedString("FAQ", comment: "faq")
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Markdown(markdown)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        .background(Color.background)
    }
}

#Preview {
    FAQView()
}
