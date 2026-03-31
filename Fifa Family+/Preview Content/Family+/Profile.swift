import SwiftUI
import MapKit
import FirebaseAuth

// Mantén tu entrypoint anterior
struct Profile: View {
    var body: some View { ProfileView() }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    // 🌐 i18n y sesión desde el environment (igual que en Home)
    @EnvironmentObject private var i18n: L10n
    @EnvironmentObject private var session: UserSession

    @State private var showEdit = false
    @State private var showSettings = false
    @State private var selectedTab = 0
    @State private var navigateToHome = false
    @State private var showSignedOutAlert = false

    var body: some View {
        ZStack {
            // Fondo sutil con degradado
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.30, blue: 0.60),
                         Color(red: 0.15, green: 0.35, blue: 0.65)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // HEADER con botón regresar
                ZStack {
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.70, blue: 0.10),
                                 Color(red: 1.0, green: 0.62, blue: 0.00)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 96)
                    .overlay(
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.2))
                                    .clipShape(Circle())
                                    .accessibilityLabel(Text(l10n("a11y.back")))
                            }
                            Spacer()
                            Text(l10n("profile.title"))
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // Tarjeta principal del usuario (hero)
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)

                            VStack(spacing: 12) {
                                // Avatar
                                ZStack {
                                    Circle()
                                        .fill(Color(UIColor.systemGray6))
                                        .frame(width: 96, height: 96)
                                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .accessibilityHidden(true)
                                }
                                .padding(.top, 20)

                                // Nombre y handle dinámicos (Guest vs Google)
                                VStack(spacing: 4) {
                                    Text(session.displayName)
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.primary)

                                    Text(session.isGuest ? "@guest"
                                         : "@\(session.email.split(separator: "@").first ?? "user")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                // Métricas rápidas (mock)
                                HStack(spacing: 18) {
                                    ProfileMetric(value: "8", label: l10n("profile.metrics.savedPlaces"))
                                    Divider().frame(height: 28).background(Color.black.opacity(0.08))
                                    ProfileMetric(value: "3", label: l10n("profile.metrics.recentRoutes"))
                                    Divider().frame(height: 28).background(Color.black.opacity(0.08))
                                    ProfileMetric(value: "2", label: l10n("profile.metrics.reports"))
                                }
                                .padding(.bottom, 16)
                            }

                            // Botón Editar
                            Button { showEdit = true } label: {
                                Label(l10n("profile.edit"), systemImage: "pencil")
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.75))
                                    .clipShape(Capsule())
                            }
                            .padding(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)

                        // Invitado => banner + CTA. Autenticado => cerrar sesión
                        if session.isGuest {
                            GuestBannerAndCTA()
                        } else {
                            SignOutButton()
                        }

                        // Tabs
                        SegmentedTabs(
                            selected: $selectedTab,
                            items: [l10n("profile.tab.info"),
                                    l10n("profile.tab.family"),
                                    l10n("profile.tab.favorites")]
                        )

                        Group {
                            if selectedTab == 0 {
                                ProfileSectionCard(
                                    title: l10n("profile.tab.info"),
                                    rows: [
                                        .init(icon: "envelope.fill",
                                              title: l10n("profile.info.email"),
                                              value: session.email),
                                        .init(icon: "mappin.and.ellipse",
                                              title: l10n("profile.info.city"),
                                              value: "Monterrey, N.L."),
                                        .init(icon: "globe.americas.fill",
                                              title: l10n("profile.info.language"),
                                              value: l10n("language.name.es"))
                                    ]
                                )
                            } else if selectedTab == 1 {
                                ProfileSectionCard(
                                    title: l10n("profile.tab.family"),
                                    rows: [
                                        .init(icon: "person.2.fill",
                                              title: l10n("profile.family.members"),
                                              value: "2 " + l10n("profile.family.adults") + ", 1 " + l10n("profile.family.child")),
                                        .init(icon: "figure.and.child.holdinghands",
                                              title: l10n("profile.family.needs"),
                                              value: l10n("profile.family.sampleNeeds"))
                                    ],
                                    primaryAction: .init(
                                        title: l10n("profile.family.manage"),
                                        systemImage: "plus.circle.fill"
                                    ) { }
                                )
                            } else {
                                ProfileSectionCard(
                                    title: l10n("profile.tab.favorites"),
                                    rows: [
                                        .init(icon: "star.fill",
                                              title: l10n("profile.favorites.places"),
                                              value: l10n("profile.favorites.samplePlaces")),
                                        .init(icon: "map.fill",
                                              title: l10n("profile.favorites.routes"),
                                              value: l10n("profile.favorites.sampleRoutes"))
                                    ],
                                    primaryAction: .init(
                                        title: l10n("profile.favorites.viewAll"),
                                        systemImage: "arrow.right"
                                    ) { }
                                )
                            }
                        }
                        .padding(.horizontal, 16)

                        // CTA grande para volver a Home
                        Button { navigateToHome = true } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "house.fill")
                                Text(l10n("profile.goHome"))
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.65)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                            .accessibilityHint(Text(l10n("a11y.backToHome.hint")))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)

                        NavigationLink(
                            destination: Home().navigationBarBackButtonHidden(true),
                            isActive: $navigateToHome
                        ) { EmptyView() }
                    }
                }
            }
        }
        // Alerta de sesión cerrada
        .alert(l10n("profile.signout.title"), isPresented: $showSignedOutAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(l10n("profile.signout.msg"))
        }
        // Sheets
        .sheet(isPresented: $showEdit) {
            VStack(spacing: 12) {
                Text(l10n("profile.editSheet.title")).font(.title2.bold())
                Text(l10n("profile.editSheet.subtitle"))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button(l10n("profile.close")) { showEdit = false }
                    .padding(.top, 8)
            }
            .padding(24)
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSettings) {
            Settings()
        }
        // 🔁 Re-render cuando cambia el idioma + RTL
        .id(i18n.language.rawValue)
        .environment(\.layoutDirection,
            Locale.characterDirection(forLanguage: i18n.language.rawValue) == .rightToLeft ? .rightToLeft : .leftToRight
        )
    }

    // MARK: - Subvistas internas

    @ViewBuilder
    private func GuestBannerAndCTA() -> some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text(l10n("profile.guest.warning"))
                    .font(.subheadline)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.95)))

            Button {
                Task {
                    try? await Task.sleep(nanoseconds: 200_000_000)   // pequeño delay opcional

                    if let vc = UIApplication.shared.topMostViewController {
                        do {
                            let user = try await AuthManager.shared.signInWithGoogle(presenting: vc)
                            session.updateFromFirebase(user)
                        } catch {
                            print("Google sign-in error:", error.localizedDescription)
                        }
                    }
                }
            } label: {
                Label(l10n("profile.guest.google"), systemImage: "globe")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func SignOutButton() -> some View {
        Button(role: .destructive) {
            session.signOut()
          
        } label: {
            Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal, 16)
    }
}

// MARK: - Componentes

private struct ProfileMetric: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

private struct SegmentedTabs: View {
    @Binding var selected: Int
    let items: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        selected = i
                    }
                } label: {
                    Text(items[i])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selected == i ? .white : .primary)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if selected == i {
                                    LinearGradient(
                                        colors: [Color(red: 0.15, green: 0.35, blue: 0.65),
                                                 Color(red: 0.10, green: 0.30, blue: 0.60)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                } else {
                                    Color.white
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(selected == i ? 0.15 : 0.08),
                                radius: selected == i ? 6 : 3, y: 2)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(items[i]))
                .accessibilityAddTraits(selected == i ? .isSelected : [])
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6))
                Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundColor(.primary)
            }
            .frame(width: 36, height: 36)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

private struct ProfileSectionCard: View {
    struct Row { let icon: String; let title: String; let value: String }
    struct PrimaryAction { let title: String; let systemImage: String; let action: () -> Void }

    let title: String
    let rows: [Row]
    var primaryAction: PrimaryAction? = nil

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                if let pa = primaryAction {
                    Button(action: pa.action) {
                        Label(pa.title, systemImage: pa.systemImage)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            VStack(spacing: 10) {
                ForEach(rows.indices, id: \.self) { i in
                    let r = rows[i]
                    ProfileRow(icon: r.icon, title: r.title, value: r.value)
                }
            }
            .padding(.bottom, 12)
        }
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white))
        .shadow(color: .black.opacity(0.10), radius: 8, y: 3)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(title))
    }
}

// MARK: - Helper para presentar Google Sign-In
extension UIApplication {
    /// VC visible para presentar Google Sign-In de forma segura
    var topMostViewController: UIViewController? {
        guard let keyWindow = connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return nil }

        var top = keyWindow.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
// MARK: - Preview
private struct ProfilePreviewContainer: View {
    @StateObject var session = UserSession()
    var body: some View {
        Profile()
            .environmentObject(L10n.shared)
            .environmentObject(session)
            .onAppear {
                // solo para preview
                session.displayName = "Guest"
                session.email = "guest@local"
            }
    }
}

#Preview { ProfilePreviewContainer() }
