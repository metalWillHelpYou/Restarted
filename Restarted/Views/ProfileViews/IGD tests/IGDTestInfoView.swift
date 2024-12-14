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
                
                Spacer()
                
                Text("The test results are not a definitive diagnosis. For an accurate assessment and professional help, please consult a specialist.")
                    .font(.headline)
                
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
            
            It consists of 20 questions about your life over the past 12 months.
            Answer as honestly and openly as possible — this is crucial for accurate results.
            
            ⚠️ All responses will be deleted immediately after you return to this screen. Your answers will remain completely confidential.
            """
        case .shortTest:
            return """
            It consists of 9 questions about your life over the past 12 months.
            Answer as honestly and openly as possible — this is crucial for accurate results.
            
            ⚠️ All responses will be deleted immediately after you return to this screen. Your answers will remain completely confidential.
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