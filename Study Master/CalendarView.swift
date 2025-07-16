//
//  CalendarView.swift
//  Study Master
//
//  Created by Finley Room on 7/10/25.
//

import SwiftUI


class Event {
    var title: String
    var description: String
    var date: Date
    var time: Date

    init(title: String, description: String, date: Date, time: Date) {
        self.title = title
        self.description = description
        self.date = date
        self.time = time
    }
}

class CanvasEvent: Event {
    var courseName: String  // Represents the class object

    init(title: String, description: String, date: Date, time: Date, courseName: String) {
        self.courseName = courseName
        super.init(title: title, description: description, date: date, time: time)
    }
}

class Assignment: CanvasEvent {
    var groupMembers: [String]

    init(title: String,
         description: String,
         date: Date,
         time: Date,
         courseName: String,
         groupMembers: [String]) {
        self.groupMembers = groupMembers
        super.init(title: title, description: description, date: date, time: time, courseName: courseName)
    }
}




/*
Breakdown for structure of event storage
    Month
        Assignments (Title, Class object, description, due date, time, group members)
        Tests (Title, Class object, date, time)
        Manual/study event (Title, date, time, description)

assignments and tests will be pulled from canvas,
manual event will be created by user, study event created by app
Event class structure:
    Title, description, date, time

    Canvas event subclass: (Tests will use this)
        Class object

        Assignment subclass:
            group members
            

 */

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
                        /*
                        Button(action: addEvent){
                            Text("Add Calendar Event")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .background(.secondary)
                                .foregroundColor(.primary)
                        }
                        */                    
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
    
    private func addEvent(title: String, description: String, start: Date, end: Date) {
        let newEvent = CalendarEvent(title: title, description: description, startDate: start, endDate: end)
        events.append(newEvent)
        saveEvents()
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
