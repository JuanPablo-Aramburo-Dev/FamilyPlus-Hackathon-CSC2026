import SwiftUI

struct StartChoiceView: View {
    @EnvironmentObject private var i18n: L10n   // observa el idioma activo

    // ✅ Callbacks con valores por defecto para evitar “Missing arguments…”
    let onGuest: () -> Void
    let onGoogle: () -> Void

    init(onGuest: @escaping () -> Void = {},
         onGoogle: @escaping () -> Void = {}) {
        self.onGuest = onGuest
        self.onGoogle = onGoogle
    }

    var body: some View {
        ZStack {
            // Mismo fondo que Phrase / Logo
            LinearGradient(
                colors: [
                    Color(red: 0.20, green: 0.00, blue: 0.00),
                    Color(red: 0.10, green: 0.05, blue: 0.00),
                    Color(red: 0.25, green: 0.15, blue: 0.00)
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                VStack(spacing: 0) {
                    Text(l10n("start.title.line1")) // “Bienvenido”
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(l10n("start.title.line2")) // “a Family+”
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 14) {
                    Button(action: onGuest) {
                        Text(l10n("start.guest")) // “Entrar como Invitado”
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Button(action: onGoogle) {
                        Label(l10n("start.google"), systemImage: "globe") // “Continuar con Google”
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding(.horizontal, 28)
            }
            .padding(.horizontal, 20)
        }
        // 🔁 Re-render con cambio de idioma + RTL
        .id(i18n.language.rawValue)
        .environment(\.layoutDirection,
            Locale.characterDirection(forLanguage: i18n.language.rawValue) == .rightToLeft ? .rightToLeft : .leftToRight
        )
    }
}

#Preview {
    StartChoiceView()
        .environmentObject(L10n.shared)
}
