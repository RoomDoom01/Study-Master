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

    @StateObject private var viewModel = CanvasViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoggedIn {
                    if viewModel.isLoading {
                        ProgressView("Loading assignments...")
                            .padding()
                    } else if viewModel.assignments.isEmpty {
                        Text("No upcoming assignments 🎉")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List {
                            if !viewModel.upcomingAssignments.isEmpty {
                                Section(header: Text("📝 Assignments Due")) {
                                    ForEach(viewModel.upcomingAssignments) { assignment in
                                        AssignmentRow(assignment: assignment)
                                    }
                                }
                            }

                            if !viewModel.upcomingQuizzes.isEmpty {
                                Section(header: Text("🧪 Tests & Quizzes")) {
                                    ForEach(viewModel.upcomingQuizzes) { quiz in
                                        AssignmentRow(assignment: quiz)
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }
                //Show all other events
                
            }
            .navigationTitle(formattedDate)
            #if os(IOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onOpenURL { url in
                viewModel.handleOAuthCallback(url: url)
            }
            .onAppear {
                viewModel.checkLoginStatus()
            }
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
