//
//  AIStudyAssistantView.swift
//  Study Master
//
//  Created by Finley Room on 7/13/25.
//
import SwiftUI

struct AIStudyAssistantView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("AI Study Assistant")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Get personalized study recommendations, schedule optimization, and smart break reminders.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {}) {
                    Text("Start Planning")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("AI Assistant")
            .background(.regularMaterial)
        }
    }
}
