//
//  CalendarDayView.swift
//  Study Master
//
//  Created by Finley Room on 7/10/25.
//
import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let currentMonth: Date
    let isToday: Bool
    let cellHeight: CGFloat
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayNumber)
                .font(.system(size: min(16, cellHeight * 0.3), weight: isToday ? .bold : .medium))
                .foregroundColor(textColor)
            
            // Space for study events (placeholder dots)
            HStack(spacing: 2) {
                if shouldShowStudyIndicator {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 4)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 6)
            
            Spacer(minLength: 0)
        }
        .frame(height: cellHeight)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    private var textColor: Color {
        if isToday {
            return .blue
        } else if isCurrentMonth {
            return .primary
        } else {
            return .secondary
        }
    }
    
    private var backgroundColor: Color {
        if isToday {
            return Color.blue.opacity(0.1)
        } else {
            return .white.opacity(0.8)
        }
    }
    
    private var shouldShowStudyIndicator: Bool {
        // Placeholder logic - show indicators on some days
        let day = calendar.component(.day, from: date)
        return isCurrentMonth && (day % 3 == 0 || day % 5 == 0)
    }
}
