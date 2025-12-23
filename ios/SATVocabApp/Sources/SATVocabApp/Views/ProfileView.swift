import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 14) {
            Text("Profile")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Profile UI will follow your 4.jpg spec.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .navigationBarTitleDisplayMode(.inline)
    }
}
