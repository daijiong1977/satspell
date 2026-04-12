import SwiftUI

// MARK: - SessionFlowViewModel (placeholder for Plan 2)

@MainActor
final class SessionFlowViewModel: ObservableObject {
    let sessionType: SessionType
    let studyDay: Int

    init(sessionType: SessionType, studyDay: Int) {
        self.sessionType = sessionType
        self.studyDay = studyDay
    }
}

// MARK: - SessionFlowView (placeholder for Plan 2)

struct SessionFlowView: View {
    @ObservedObject var vm: SessionFlowViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Session View")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))

            Text("\(vm.sessionType.rawValue.capitalized) session - Day \(vm.studyDay)")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.secondary)

            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
