import SwiftUI

struct TrustShieldBadge: View {
    let trust: Int   // 0...100
    
    private var color: Color {
        switch trust {
        case 80...:      return .green
        case 50..<80:    return .yellow
        default:         return .red
        }
    }
    private var label: String { "\(trust)%" }

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(0.18))
                Image(systemName: "shield.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(color)
            }
            .frame(width: 42, height: 34)

            Text(label)
                .font(.subheadline).bold()
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
        )
        .accessibilityLabel("\(trust)")
    }
}
