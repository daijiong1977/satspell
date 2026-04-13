import WidgetKit
import SwiftUI
import ActivityKit

struct SATVocabLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionActivityAttributes.self) { context in
            // Lock screen / banner view
            lockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded regions
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.sessionType.capitalized)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text("Step \(context.state.stepNumber)/\(context.state.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("+\(context.state.xpEarned) XP")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                        Text(context.state.progress)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.stepLabel)
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .lineLimit(1)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    // Progress bar
                    if context.state.totalSteps > 0 {
                        ProgressView(
                            value: Double(context.state.stepNumber),
                            total: Double(context.state.totalSteps)
                        )
                        .tint(.green)
                        .padding(.horizontal, 8)
                    }
                }
            } compactLeading: {
                // Compact leading: word name
                Text(context.state.stepLabel)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .lineLimit(1)
            } compactTrailing: {
                // Compact trailing: progress
                Text(context.state.progress)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            } minimal: {
                // Minimal: just XP
                Text("\(context.state.xpEarned)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.yellow)
            }
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<SessionActivityAttributes>) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(context.attributes.sessionType.capitalized) Session")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)

                Text(context.state.stepLabel)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))

                if context.state.totalSteps > 0 {
                    ProgressView(
                        value: Double(context.state.stepNumber),
                        total: Double(context.state.totalSteps)
                    )
                    .tint(.green)
                }
            }

            Spacer()

            VStack(spacing: 2) {
                Text("+\(context.state.xpEarned)")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.yellow)
                Text("XP")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 2) {
                Text(context.state.progress)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text("Progress")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
    }
}

@main
struct SATVocabWidgetBundle: WidgetBundle {
    var body: some Widget {
        SATVocabLiveActivity()
    }
}
