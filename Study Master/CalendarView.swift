//
//  CalendarView.swift
//  Study Master
//
//  Created by Finley Room on 7/10/25.
//

import SwiftUI


struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: IdentifiableDate? = nil
    private var events: [LocalCalendarEvent] = []
    //@State private var isShowingSheet = false
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
                        
                        Button(action: addEvent){
                            Text("Add Calendar Event")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .background(.secondary)
                                .foregroundColor(.primary)
                        }  

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
                            Button {
                                selectedDate = IdentifiableDate(date: date)
                                //isShowingSheet = true
                            } label: {
                                CalendarDayView(
                                    date: date,
                                    currentMonth: currentDate,
                                    isToday: calendar.isDateInToday(date),
                                    cellHeight: max(40, (geometry.size.height * 0.4) / CGFloat(daysInMonth.count / 7))
                                )
                            }.buttonStyle(PlainButtonStyle())
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
        }.sheet(item: $selectedDate) { identifiableDate in
            DayDetailView(date: identifiableDate.date)
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
    
    func addEvent(
    title: String,
    description: String,
    date: Date,
    time: String,
    type: String,
    courseName: String,
    groupMembers: [String]? = nil,
    completedStudying: Bool = false
) {
    var newEvent: CalendarEventItem

    switch type.lowercased() {
    case "test":
        newEvent = TestEvent(
            title: title,
            description: description,
            date: date,
            time: time,
            courseName: courseName,
            completedStudying: completedStudying
        )
    case "assignment":
        newEvent = AssignmentEvent(
            title: title,
            description: description,
            date: date,
            time: time,
            courseName: courseName,
            groupMembers: groupMembers
        )
    default:
        newEvent = CanvasEvent(
            title: title,
            description: description,
            date: date,
            time: time,
            courseName: courseName
        )
    }

    DispatchQueue.main.async {
        self.events.append(newEvent)
        self.events.sort { $0.date < $1.date }
    }
}

    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "localEvents")
        }
    }
    private func loadEvents() {
        if let savedData = UserDefaults.standard.data(forKey: "localEvents"),
        let decoded = try? JSONDecoder().decode([CalendarEvent].self, from: savedData) {
            events = decoded
        }
    }
}
