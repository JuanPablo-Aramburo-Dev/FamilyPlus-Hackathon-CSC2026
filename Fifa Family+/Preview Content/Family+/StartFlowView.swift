import SwiftUI
import UIKit

struct StartFlowView: View {
    @EnvironmentObject private var session: UserSession
    @EnvironmentObject private var i18n: L10n

    private enum Step { case logo, phrase, choice, family }
    @State private var step: Step = .logo

    var body: some View {
        Group {
            switch step {
            case .logo:
                Logo()
                    .onAppear {
                        // Muestra el logo un poco más de tiempo
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            withAnimation { step = .phrase }
                        }
                    }

            case .phrase:
                Phrase()
                    .onAppear {
                        // Cuando termina la frase, decide hacia dónde ir
                        let delay: Double = 5.5
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation {
                                step = (session.state == .signedIn) ? .family : .choice
                            }
                        }
                    }

            case .choice:
                StartChoiceView(
                    onGuest: {
                        session.becomeGuest()
                        withAnimation { step = .family }
                    },
                    onGoogle: {
                        // Pequeño retardo para evitar presentar VC durante una transición
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            guard let vc = UIApplication.shared.topMostViewController else {
                                print("No topMostViewController"); return
                            }
                            Task { @MainActor in
                                do {
                                    let user = try await AuthManager.shared.signInWithGoogle(presenting: vc)
                                    session.updateFromFirebase(user)
                                    withAnimation { step = .family }
                                } catch {
                                    print("Google sign-in error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                )
                // Re-render y dirección cuando cambie el idioma
                .id(i18n.language.rawValue)
                .environment(\.layoutDirection,
                    Locale.characterDirection(forLanguage: i18n.language.rawValue) == .rightToLeft
                    ? .rightToLeft : .leftToRight
                )

            case .family:
                Family() // Contenedor de tu app (lleva a Home)
            }
        }
        // Si cambia el estado de sesión, ajusta el flujo
        .onChange(of: session.state) { newValue in
            switch newValue {
            case .signedIn:
                if step == .choice { withAnimation { step = .family } }
            case .guest, .unknown:
                withAnimation { step = .choice }
            }
        }
        // Listener opcional por si posteas una notificación al cerrar sesión
        .onReceive(NotificationCenter.default.publisher(for: .goToStartChoice)) { _ in
            withAnimation { step = .choice }
        }
    }
}

// MARK: - Helpers



extension Notification.Name {
    /// Úsalo si quieres forzar volver a la pantalla de elección:
    /// NotificationCenter.default.post(name: .goToStartChoice, object: nil)
    static let goToStartChoice = Notification.Name("go.to.start.choice")
}
