import SwiftUI

struct About: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var i18n: L10n   // 🔑 observa idioma
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo degradado azul
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.12, green: 0.28, blue: 0.55),
                        Color(red: 0.20, green: 0.45, blue: 0.75)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // ===== Encabezado =====
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                                .accessibilityLabel(l10n("a11y.back"))
                        }

                        Spacer()

                        Text(l10n("about.title"))
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 20)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Sección principal
                            Text(l10n("about.mission.title"))
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text(l10n("about.mission.body"))
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            Divider()

                            Text(l10n("about.history.title"))
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text(l10n("about.history.body"))
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            Divider()

                            Text(l10n("about.team.title"))
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text(l10n("about.team.body"))
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                           isActive: $navigateToHome) { EmptyView() }

                            Button(action: { navigateToHome = true }) {
                                Text(l10n("about.backToHome"))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.15, green: 0.35, blue: 0.65))
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .padding(.top, 40)
                            }
                            .accessibilityHint(l10n("a11y.backToHome.hint"))
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
        .id(i18n.language.rawValue)
    }
}

#Preview {
    About()
        .environmentObject(L10n.shared)   // 👈 necesario en previews
}
