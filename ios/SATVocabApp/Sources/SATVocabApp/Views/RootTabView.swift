import SwiftUI

struct RootTabView: View {
    enum Tab: Hashable {
        case map
        case practice
        case stats
        case profile
    }

    @State private var selected: Tab = .practice

    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                AdventureMapView(switchToPractice: { selected = .practice })
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(Tab.map)

            NavigationStack {
                PracticeTabView()
            }
            .tabItem {
                Label("Practice", systemImage: "pencil.and.list.clipboard")
            }
            .tag(Tab.practice)

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
        .tint(Color(hex: "#58CC02"))
    }
}

// Color(hex:) extension is in Views/Components/Button3D.swift

#Preview {
    RootTabView()
}
