import UserNotifications

enum NotificationScheduler {
    private static let morningId = "morning-reminder"
    private static let eveningId = "evening-reminder"

    static func setMorningReminder(enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [morningId])

        guard enabled else {
            UserDefaults.standard.set(false, forKey: "notif.morning")
            return
        }

        requestPermissionThen {
            let content = UNMutableNotificationContent()
            content.title = "Good morning! ☀️"
            content.body = "Time for your SAT vocabulary session."
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = 8
            dateComponents.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: morningId, content: content, trigger: trigger)
            center.add(request)
            UserDefaults.standard.set(true, forKey: "notif.morning")
        }
    }

    static func setEveningReminder(enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [eveningId])

        guard enabled else {
            UserDefaults.standard.set(false, forKey: "notif.evening")
            return
        }

        requestPermissionThen {
            let content = UNMutableNotificationContent()
            content.title = "Evening review time 🌙"
            content.body = "Let's reinforce today's vocabulary words."
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = 19
            dateComponents.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: eveningId, content: content, trigger: trigger)
            center.add(request)
            UserDefaults.standard.set(true, forKey: "notif.evening")
        }
    }

    private static func requestPermissionThen(_ completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                DispatchQueue.main.async { completion() }
            }
        }
    }
}
