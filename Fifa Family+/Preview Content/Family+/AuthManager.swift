import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class AuthManager {
    static let shared = AuthManager()

    private init() {}

    func signInWithGoogle(presenting viewController: UIViewController) async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing clientID"])
        }

        // Config de Google
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Flujo de Google
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw NSError(domain: "Auth", code: -2, userInfo: [NSLocalizedDescriptionKey: "Missing idToken"])
        }
        let accessToken = user.accessToken.tokenString

        // Credenciales Firebase
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user
    }
}
