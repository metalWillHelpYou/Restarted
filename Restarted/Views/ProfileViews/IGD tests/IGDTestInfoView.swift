//
//  IGDTestInfoView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.11.2024.
//

import SwiftUI

struct IGDTestInfoView: View {
    @State var testType: TestType

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Internet Gaming Disorder Test")
                        .font(.largeTitle)

                    Spacer()

                    infoLink
                }

                if testType == .shortTest {
                    Text("Short Form")
                        .foregroundStyle(Color.highlight)
                        .font(.title)
                }

                Spacer()

                Text(descriptionText)
                    .font(.title3)
                    .padding(.top)

                Spacer()

                NavigationLink(destination: destinationView) {
                    Text("Start Test")
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.text)
                        .strokeBackground(Color.highlight)
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            .background(Color.background)
        }
    }
}

// MARK: - Subviews

extension IGDTestInfoView {
    private var infoLink: some View {
        let urlString: String
        switch testType {
        case .longTest:
            urlString = "https://pubmed.ncbi.nlm.nih.gov/25313515/"
        case .shortTest:
            urlString = "https://pmc.ncbi.nlm.nih.gov/articles/PMC8953588/"
        }

        return Group {
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    Image(systemName: "info.circle")
                        .font(.title)
                        .tint(Color.highlight)
                }
            }
        }
    }
    
    private var descriptionText: String {
        switch testType {
        case .longTest:
            return """
            These questions will ask you about your gaming activity during the past year (i.e., last 12 months).
            By gaming activity we understand any gaming-related activity that has been played either from a computer/laptop or from a gaming console or any other kind of device (e.g., mobile phone, tablet, etc.) both online and/or offline.
            """
        case .shortTest:
            return """
            This short form of the Internet Gaming Disorder Test provides a quick screening for gaming behavior over the past 12 months.
            """
        }
    }

    private var destinationView: AnyView {
        switch testType {
        case .longTest:
            return AnyView(LongTestView())
        case .shortTest:
            return AnyView(ShortTestView())
        }
    }
}

#Preview {
    IGDTestInfoView(testType: .longTest)
}
