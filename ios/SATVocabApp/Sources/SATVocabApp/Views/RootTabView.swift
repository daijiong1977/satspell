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
                AdventureMapView()
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

// MARK: - Color hex extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 1; g = 1; b = 1
        }
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    RootTabView()
}
