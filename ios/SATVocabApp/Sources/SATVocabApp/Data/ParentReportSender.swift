import Foundation

enum ParentReportSender {
    private static let endpoint = "https://lfknsvavhiqrsasdfyrs.supabase.co/functions/v1/send-email-v2"

    static func sendReport(
        toEmail: String,
        studentName: String,
        streak: StreakInfo,
        studyDay: Int
    ) async throws -> Bool {
        let html = buildReportHTML(studentName: studentName, streak: streak, studyDay: studyDay)

        let body: [String: Any] = [
            "to_email": toEmail,
            "subject": "WordScholar Progress Report — \(studentName)",
            "message": "Progress report for \(studentName). View the HTML version for full details.",
            "html": html,
            "from_name": "WordScholar Admin"
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "ParentReport", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMsg])
        }

        return true
    }

    private static func buildReportHTML(studentName: String, streak: StreakInfo, studyDay: Int) -> String {
        let accuracy = streak.totalStudyDays > 0 ? "Active" : "Getting Started"
        let dateStr = DateFormatter.yyyyMMdd.string(from: Date())

        return """
        <!DOCTYPE html>
        <html>
        <head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
        <body style="font-family: -apple-system, Arial, sans-serif; max-width: 480px; margin: 0 auto; padding: 20px; background: #f5f5f5;">
            <div style="background: white; border-radius: 16px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                <div style="text-align: center; margin-bottom: 20px;">
                    <h1 style="color: #58CC02; font-size: 24px; margin: 0;">📚 WordScholar</h1>
                    <p style="color: #999; font-size: 12px; margin: 4px 0;">Progress Report — \(dateStr)</p>
                </div>

                <h2 style="color: #333; font-size: 18px; margin: 16px 0 8px;">Hi there!</h2>
                <p style="color: #666; font-size: 14px; line-height: 1.5;">
                    Here's <strong>\(studentName)</strong>'s vocabulary learning progress:
                </p>

                <div style="display: flex; justify-content: space-around; margin: 20px 0; text-align: center;">
                    <div style="flex: 1; padding: 12px;">
                        <div style="font-size: 32px; font-weight: 900; color: #FFC800;">\(streak.totalXP)</div>
                        <div style="font-size: 11px; color: #999; font-weight: 600;">TOTAL XP</div>
                    </div>
                    <div style="flex: 1; padding: 12px;">
                        <div style="font-size: 32px; font-weight: 900; color: #FF9600;">\(streak.currentStreak)</div>
                        <div style="font-size: 11px; color: #999; font-weight: 600;">DAY STREAK</div>
                    </div>
                    <div style="flex: 1; padding: 12px;">
                        <div style="font-size: 32px; font-weight: 900; color: #58CC02;">\(streak.totalStudyDays)</div>
                        <div style="font-size: 11px; color: #999; font-weight: 600;">STUDY DAYS</div>
                    </div>
                </div>

                <div style="background: #f0fdf0; border-radius: 12px; padding: 16px; margin: 16px 0;">
                    <p style="margin: 0; font-size: 14px; color: #333;">
                        <strong>Current Day:</strong> Day \(studyDay + 1)<br>
                        <strong>Best Streak:</strong> \(streak.bestStreak) days<br>
                        <strong>Status:</strong> \(accuracy)
                    </p>
                </div>

                <p style="color: #999; font-size: 12px; text-align: center; margin-top: 20px;">
                    Sent from WordScholar — SAT Vocabulary Learning App
                </p>
            </div>
        </body>
        </html>
        """
    }
}
