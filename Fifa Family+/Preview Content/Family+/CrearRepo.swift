import FirebaseAuth
import FirebaseFirestore

enum ReportError: LocalizedError {
    case guestNotAllowed
    case emptyDescription

    var errorDescription: String? {
        switch self {
        case .guestNotAllowed:  return "Los invitados no pueden enviar reportes. Inicia sesión con Google."
        case .emptyDescription: return "Describe brevemente el problema del lugar."
        }
    }
}

final class ReportRepo {
    private let db = Firestore.firestore()

    @discardableResult
    func submitReport(amenityId: String,
                      stadiumId: String,
                      description: String,
                      extra: [String: Any] = [:]) async throws -> String {
        // Validaciones locales
        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { throw ReportError.emptyDescription }

        guard let user = Auth.auth().currentUser, !user.isAnonymous
        else { throw ReportError.guestNotAllowed }

        let ref = db.collection("reports").document()
        var data: [String: Any] = [
            "amenityId": amenityId,
            "stadiumId": stadiumId,
            "description": description,
            "uid": user.uid,
            "email": user.email ?? "",
            "createdAt": FieldValue.serverTimestamp()
        ]
        // Mezcla metadatos adicionales (opcional)
        data.merge(extra, uniquingKeysWith: { _, new in new })

        try await ref.setData(data)
        return ref.documentID
    }
}
