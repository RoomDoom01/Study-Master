import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CanvasViewModel

    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var time = ""
    @State private var type = "assignment"
    @State private var courseName = ""
    @State private var groupMembersText = ""
    @State private var completedStudying = false

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Description", text: $description)
            DatePicker("Date", selection: $date, displayedComponents: .date)
            DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)            
            Picker("Type", selection: $type) {
                Text("Assignment").tag("assignment")
                Text("Test").tag("test")
                Text("General").tag("general")
            }
            TextField("Course Name", text: $courseName)

            if type == "assignment" {
                TextField("Group Members (comma-separated)", text: $groupMembersText)
            }

            if type == "test" {
                Toggle("Completed Studying", isOn: $completedStudying)
            }

            Button("Add Event") {
                let groupMembers = groupMembersText
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                let timeString = timeFormatter.string(from: time)
                viewModel.addUserEvent(
                    title: title,
                    description: description,
                    date: date,
                    time: time,
                    type: type,
                    courseName: courseName,
                    groupMembers: type == "assignment" ? groupMembers : nil,
                    completedStudying: completedStudying
                )
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Add Event")
    }
}
