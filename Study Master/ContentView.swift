import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1 // Calendar tab active by default
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // AI Study Assistant Tab
            AIStudyAssistantView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI Assistant")
                }
                .tag(0)
            
            // Calendar Tab (Active by default)
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            // Focus Mode Tab
            FocusModeView()
                .tabItem {
                    Image(systemName: "lock.shield")
                    Text("Focus Mode")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

// MARK: - Calendar View
struct CalendarView: View {
    @State private var currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthYearString: String {
        dateFormatter.string(from: currentDate)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1)
        else { return [] }
        
        var dates: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Month/Year Header
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Text(monthYearString)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Weekday Headers
                    HStack(spacing: 0) {
                        ForEach(weekdayHeaders, id: \.self) { weekday in
                            Text(weekday)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    
                    // Calendar Grid - Uses flexible height based on available space
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                        ForEach(daysInMonth, id: \.self) { date in
                            CalendarDayView(
                                date: date,
                                currentMonth: currentDate,
                                isToday: calendar.isDateInToday(date),
                                cellHeight: max(40, (geometry.size.height * 0.4) / CGFloat(daysInMonth.count / 7))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .layoutPriority(1) // Give calendar priority in layout
                    
                    Spacer(minLength: 20)
                    
                    // Study Stats Section
                    StudyStatsView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            #endif
            .background(.regularMaterial)
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
    }
}

// MARK: - Calendar Day View
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

// MARK: - AI Study Assistant View (Placeholder)
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

// MARK: - Focus Mode View (Placeholder)
struct FocusModeView: View {
    @State private var isFocusModeActive = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(isFocusModeActive ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: isFocusModeActive ? "lock.shield.fill" : "lock.shield")
                        .font(.system(size: 50))
                        .foregroundColor(isFocusModeActive ? .red : .gray)
                }
                
                VStack(spacing: 16) {
                    Text(isFocusModeActive ? "Focus Mode Active" : "Focus Mode")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(isFocusModeActive ?
                         "Your phone is locked. Stay focused on your studies!" :
                         "Block distracting apps and notifications to maintain deep focus during study sessions.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFocusModeActive.toggle()
                    }
                }) {
                    Text(isFocusModeActive ? "End Focus Session" : "Start Focus Session")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFocusModeActive ? Color.red : Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                if isFocusModeActive {
                    VStack(spacing: 8) {
                        Text("Session Duration")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("25:00")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Focus Mode")
            .background(.regularMaterial)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone 15 Pro Preview - This will show the proper iOS formatting
            ContentView()
                .previewDevice("iPhone 15 Pro")
                .previewDisplayName("iPhone 15 Pro")
            
            // iPhone SE Preview - Smaller screen
            ContentView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            
            // Dark Mode Preview
            ContentView()
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.dark)
                .previewDisplayName("iPhone 15 Pro (Dark)")
        }
    }
}
