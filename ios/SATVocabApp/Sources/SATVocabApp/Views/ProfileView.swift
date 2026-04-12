import SwiftUI

struct ProfileView: View {
    @State private var streak: StreakInfo = StreakInfo(
        currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
        totalXP: 0, totalStudyDays: 0,
        streak3Claimed: false, streak7Claimed: false,
        streak14Claimed: false, streak30Claimed: false
    )
    @State private var showShareSheet = false
    @State private var shareImage: UIImage? = nil
    @State private var morningNotifications = true
    @State private var eveningNotifications = true

    private let userId = LocalIdentity.userId()

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // User info
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#58CC02").opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: "person.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(Color(hex: "#58CC02"))
                    }

                    Text("SAT Learner")
                        .font(.system(.title2, design: .rounded).weight(.bold))

                    HStack(spacing: 20) {
                        VStack(spacing: 2) {
                            Text("\(streak.currentStreak)")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                            Text("Streak")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        VStack(spacing: 2) {
                            Text("\(streak.totalXP)")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                            Text("Total XP")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        VStack(spacing: 2) {
                            Text("\(streak.totalStudyDays)")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                            Text("Days")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)

                // Share button
                Button {
                    generateAndShare()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Share Today's Progress")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#58CC02"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)

                // Notification toggles
                VStack(spacing: 0) {
                    settingsHeader("Notifications")

                    Toggle(isOn: $morningNotifications) {
                        HStack(spacing: 10) {
                            Image(systemName: "sun.max.fill")
                                .foregroundStyle(.orange)
                            Text("Morning reminder")
                                .font(.system(.body, design: .rounded))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    Divider().padding(.horizontal, 16)

                    Toggle(isOn: $eveningNotifications) {
                        HStack(spacing: 10) {
                            Image(systemName: "moon.fill")
                                .foregroundStyle(.indigo)
                            Text("Evening reminder")
                                .font(.system(.body, design: .rounded))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )

                // About
                VStack(spacing: 0) {
                    settingsHeader("About")

                    settingsRow("App Version", value: "1.0.0")
                    Divider().padding(.horizontal, 16)
                    settingsRow("User ID", value: String(userId.prefix(8)) + "...")
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                let statsStore = StatsStore.shared
                streak = try await statsStore.getStreak(userId: userId)
            } catch {
                // ignore
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }

    private func settingsHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 6)
    }

    private func settingsRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(.body, design: .rounded))
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func generateAndShare() {
        let image = ReportCardGenerator.render(streak: streak, userId: userId)
        shareImage = image
        showShareSheet = true
    }
}

// MARK: - ShareSheet wrapper

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
