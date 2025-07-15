//
//  StatCard.swift
//  Study Master
//
//  Created by Finley Room on 7/13/25.
//
import SwiftUI

// MARK: - Study Stats View
struct StudyStatsView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Study Hours",
                    value: "24.5",
                    icon: "clock",
                    color: .blue
                )
                
                StatCard(
                    title: "Focus Sessions",
                    value: "12",
                    icon: "target",
                    color: .green
                )
                
                StatCard(
                    title: "Streak",
                    value: "7 days",
                    icon: "flame",
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
