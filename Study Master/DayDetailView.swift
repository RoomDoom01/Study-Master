//
//  DayDetailView.swift
//  Study Master
//
//  Created by Finley Room on 7/12/25.
//


import SwiftUI

struct DayDetailView: View {
    let date: Date
    private let calendar = Calendar.current
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionView(
                        title: "📅 Classes",
                        items: [
                            "Math - 10:00 AM",
                            "Chemistry - 1:00 PM",
                            "CS Lecture - 3:30 PM"
                        ]
                    )
                    
                    SectionView(
                        title: "📝 Assignments Due",
                        items: [
                            "Math Homework 4",
                            "CS Lab Report",
                            "Read Ch. 5 of Chemistry Textbook"
                        ]
                    )
                    
                    SectionView(
                        title: "🧪 Tests",
                        items: [
                            "CS Quiz 3"
                        ]
                    )
                    
                    SectionView(
                        title: "📚 Study Plan",
                        items: [
                            "Revise CS Lecture Notes",
                            "Work on Math Problem Set",
                            "Flashcards: Chemistry Reactions"
                        ]
                    )
                }
                .padding()
            }
            .navigationTitle(formattedDate)
            #if os(IOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
