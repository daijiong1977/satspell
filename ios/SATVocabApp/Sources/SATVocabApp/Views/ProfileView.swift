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
    @State private var displayName: String = LocalIdentity.displayName()
    @State private var avatarEmoji: String = LocalIdentity.avatarEmoji()
    @State private var isEditingName = false
    @State private var showAvatarPicker = false
    @State private var showResetConfirm = false

    private let userId = LocalIdentity.userId()

    private let avatarOptions = [
        "🧑‍🎓", "👩‍🎓", "👨‍🎓", "🦊", "🐱", "🐶",
        "🐼", "🦁", "🐯", "🐸", "🦉", "🐙",
        "🚀", "⭐", "🌟", "💎", "🔥", "🎯",
        "🎓", "📚", "🧠", "💡", "🏆", "👑"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // User info with editable avatar and name
                VStack(spacing: 10) {
                    // Tappable avatar
                    Button {
                        showAvatarPicker = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#58CC02").opacity(0.15))
                                .frame(width: 80, height: 80)
                            Text(avatarEmoji)
                                .font(.system(size: 40))
                            // Edit badge
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Color(hex: "#58CC02"))
                                .background(Circle().fill(.white).frame(width: 20, height: 20))
                                .offset(x: 28, y: 28)
                        }
                    }
                    .buttonStyle(.plain)

                    // Tappable name
                    if isEditingName {
                        HStack(spacing: 8) {
                            TextField("Your name", text: $displayName)
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 200)
                                .onSubmit { saveName() }

                            Button {
                                saveName()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color(hex: "#58CC02"))
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        Button {
                            isEditingName = true
                        } label: {
                            HStack(spacing: 6) {
                                Text(displayName)
                                    .font(.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(.primary)
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#AFAFAF"))
                            }
                        }
                        .buttonStyle(.plain)
                    }

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
                    .onChange(of: morningNotifications) { _, enabled in
                        NotificationScheduler.setMorningReminder(enabled: enabled)
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
                    .onChange(of: eveningNotifications) { _, enabled in
                        NotificationScheduler.setEveningReminder(enabled: enabled)
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

                // Danger zone
                VStack(spacing: 0) {
                    settingsHeader("Danger Zone")

                    Button(role: .destructive) {
                        showResetConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            Text("Reset All Progress")
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.red.opacity(0.15), lineWidth: 1)
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
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerSheet(
                options: avatarOptions,
                selected: avatarEmoji,
                onSelect: { emoji in
                    avatarEmoji = emoji
                    LocalIdentity.setAvatarEmoji(emoji)
                    showAvatarPicker = false
                }
            )
            .presentationDetents([.fraction(0.4)])
        }
        .alert("Reset All Progress?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset Everything", role: .destructive) {
                Task {
                    do {
                        let dm = DataManager.shared
                        try await dm.initializeIfNeeded()
                        try await dm.db.exec("DELETE FROM word_state;")
                        try await dm.db.exec("DELETE FROM day_state;")
                        try await dm.db.exec("DELETE FROM session_state;")
                        try await dm.db.exec("DELETE FROM review_log;")
                        try await dm.db.exec("DELETE FROM daily_stats;")
                        try await dm.db.exec("UPDATE streak_store SET current_streak=0, best_streak=0, total_xp=0, total_study_days=0, last_study_date=NULL;")
                        streak = StreakInfo(currentStreak: 0, bestStreak: 0, lastStudyDate: nil, totalXP: 0, totalStudyDays: 0, streak3Claimed: false, streak7Claimed: false, streak14Claimed: false, streak30Claimed: false)
                    } catch {
                        print("Reset error: \(error)")
                    }
                }
            }
        } message: {
            Text("This will erase all your learning progress, XP, streaks, and session history. This cannot be undone.")
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

    private func saveName() {
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        displayName = trimmed.isEmpty ? "SAT Learner" : trimmed
        LocalIdentity.setDisplayName(displayName)
        isEditingName = false
    }

    private func generateAndShare() {
        let image = ReportCardGenerator.render(streak: streak, userId: userId)
        shareImage = image
        showShareSheet = true
    }
}

// MARK: - Avatar Picker

private struct AvatarPickerSheet: View {
    let options: [String]
    let selected: String
    let onSelect: (String) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)

    var body: some View {
        VStack(spacing: 16) {
            Text("Choose Your Character")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .padding(.top, 16)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(options, id: \.self) { emoji in
                    Button {
                        onSelect(emoji)
                    } label: {
                        Text(emoji)
                            .font(.system(size: 36))
                            .frame(width: 52, height: 52)
                            .background(
                                emoji == selected
                                    ? Color(hex: "#58CC02").opacity(0.2)
                                    : Color(hex: "#F5F5F5")
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(
                                        emoji == selected ? Color(hex: "#58CC02") : .clear,
                                        lineWidth: 2
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)

            Spacer()
        }
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
