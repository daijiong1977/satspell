import SwiftUI

struct RootTabView: View {
    enum Tab: Hashable {
        case map
        case tasks
        case games
        case stats
        case profile
    }

    @State private var selected: Tab = .map
    @State private var selectedDayIndex: Int = AdventureSchedule.dayIndexForToday()

    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                AdventureMapView(selectedDayIndex: $selectedDayIndex)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(Tab.map)

            NavigationStack {
                DayTasksView(dayIndex: selectedDayIndex)
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(Tab.tasks)

            NavigationStack {
                GamesHubView(dayIndex: selectedDayIndex)
            }
            .tabItem {
                Label("Games", systemImage: "gamecontroller")
            }
            .tag(Tab.games)

            NavigationStack {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
            .tag(Tab.stats)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(Tab.profile)
        }
    }
}

#Preview {
    RootTabView()
}
