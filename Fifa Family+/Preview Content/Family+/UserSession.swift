import Foundation
import FirebaseAuth
import FirebaseCore
import UIKit
import GoogleSignIn   // ⬅️ Asegúrate de tener el SDK agregado

@MainActor
final class UserSession: ObservableObject {
    enum State { case unknown, guest, signedIn }

    @Published var state: State = .unknown
    @Published var displayName: String = "Guest"
    @Published var email: String = "guest@local"

    /// Útil para tu UI (p.ej. bloquear votos a invitados)
    var canVote: Bool { state == .signedIn }
    var isGuest: Bool { state == .guest }

    // MARK: - Init: levanta el estado desde Firebase si existe
    init() {
        if let user = Auth.auth().currentUser {
            updateFromFirebase(user)
        } else {
            state = .unknown
        }
    }

    // MARK: - Invitado (sin Auth anónimo para que NO pueda votar)
    func becomeGuest() {
        state = .guest
        displayName = "Guest"
        email = "guest@local"
    }

    /// Alias para compatibilidad con las llamadas previas
    func setGuest() { becomeGuest() }

    // MARK: - Google Sign-In → Firebase Auth
    enum SignInError: Error { case noPresentingVC, noToken }

    /// Llama esto desde App con un UIViewController para presentar el flujo
    func signInWithGoogle(presenting: UIViewController) async {
        do {
            // 1) Flujo de Google (SDK 7+)
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)

            guard let idToken = result.user.idToken?.tokenString else {
                throw SignInError.noToken
            }
            let accessToken = result.user.accessToken.tokenString

            // 2) Intercambio credencial con Firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credential)

            // 3) Actualiza estado local
            updateFromFirebase(authResult.user)
        } catch {
            // Puedes mostrar un alert/Toast si quieres
            print("Google Sign-In error: \(error)")
        }
    }

    // MARK: - Helpers
    func updateFromFirebase(_ user: User) {
        if user.isAnonymous {
            state = .guest
            displayName = "Guest"
            email = "guest@local"
        } else {
            state = .signedIn
            displayName = user.displayName ?? "Usuario"
            email = user.email ?? "usuario@desconocido"
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        state = .unknown
        displayName = "Guest"
        email = "guest@local"
    }
}
