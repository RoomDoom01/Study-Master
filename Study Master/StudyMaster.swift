import SwiftUI

// MARK: - Main App Content View
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
