import SwiftUI

struct TrustBadgeMini: View {
    let trust: Int
    private var color: Color {
        switch trust { case 80...: .green; case 50..<80: .yellow; default: .red }
    }
    var body: some View {
        Text("\(trust)% confiable")
            .font(.caption).bold()
            .padding(.horizontal, 8).padding(.vertical, 5)
            .background(color.opacity(0.18))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
