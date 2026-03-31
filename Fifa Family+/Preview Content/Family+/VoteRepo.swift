import FirebaseAuth
import FirebaseFirestore

enum VoteError: Error {
    case notSignedIn
}

final class VoteRepo: ObservableObject {
    private let db = Firestore.firestore()

    // Escucha el amenity (conteos/trust agregados)
    func listenAmenity(amenityId: String, onChange: @escaping (Amenity) -> Void) -> ListenerRegistration {
        db.collection("amenities").document(amenityId)
            .addSnapshotListener { snap, _ in
                guard let d = snap?.data() else { return }
                onChange(
                    Amenity(
                        id: snap!.documentID,
                        name: d["name"] as? String ?? "",
                        stadiumId: d["stadiumId"] as? String ?? "",
                        votesUp: d["votesUp"] as? Int ?? 0,
                        votesDown: d["votesDown"] as? Int ?? 0,
                        trustPct: d["trustPct"] as? Int ?? 0
                    )
                )
            }
    }

    // Escucha MI voto (para pintar el pulgar seleccionado)
    func listenMyVote(amenityId: String, onChange: @escaping (Int) -> Void) -> ListenerRegistration? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil } // invitado: no hay uid
        return db.collection("amenityVotes").document(amenityId)
            .collection("userVotes").document(uid)
            .addSnapshotListener { snap, _ in
                let v = (snap?.data()?["value"] as? Int) ?? 0
                onChange(v)
            }
    }

    // Crea el doc del amenity si no existe
    private func ensureDocIfMissing(amenityId: String, name: String, stadiumId: String) async throws {
        let ref = db.collection("amenities").document(amenityId)
        let doc = try await ref.getDocument()
        if !doc.exists {
            try await ref.setData([
                "name": name,
                "stadiumId": stadiumId,
                "votesUp": 0,
                "votesDown": 0,
                "trustPct": 0,
                "updatedAt": FieldValue.serverTimestamp()
            ], merge: true)
        }
    }

    /// Escribe el voto del usuario (1, 0, -1) con consistencia.
    /// Requiere estar autenticado **NO anónimo**. Invitado ⇒ `VoteError.notSignedIn`.
    func setVote(
            amenityId: String,
            fallbackName: String,
            stadiumId: String,
            value: Int
        ) async throws {
            // 1) Bloquea invitados
            guard let user = Auth.auth().currentUser, !user.isAnonymous else {
                throw VoteError.notSignedIn
            }

            // 2) Asegura el documento del amenity
            try await ensureDocIfMissing(amenityId: amenityId, name: fallbackName, stadiumId: stadiumId)

            let amenityRef = db.collection("amenities").document(amenityId)
            let voteRef = db.collection("amenityVotes").document(amenityId)
                .collection("userVotes").document(user.uid)

            // 3) Transacción SIN throws en el closure
            try await db.runTransaction { (txn, errorPointer) -> Any? in
                do {
                    // lee mi voto anterior
                    let oldSnap = try txn.getDocument(voteRef)
                    let oldVal = (oldSnap.data()?["value"] as? Int) ?? 0

                    // lee contadores actuales
                    let amenSnap = try txn.getDocument(amenityRef)
                    var up   = (amenSnap.data()?["votesUp"] as? Int) ?? 0
                    var down = (amenSnap.data()?["votesDown"] as? Int) ?? 0

                    // revierte contribución anterior
                    if oldVal == 1   { up   -= 1 }
                    if oldVal == -1  { down -= 1 }

                    // aplica nueva
                    if value == 1    { up   += 1 }
                    if value == -1   { down += 1 }

                    let total = max(0, up + down)
                    let trust = total > 0 ? Int((Double(up) / Double(total) * 100.0).rounded()) : 0

                    // escribe mi voto
                    txn.setData([
                        "value": value,
                        "updatedAt": FieldValue.serverTimestamp()
                    ], forDocument: voteRef, merge: true)

                    // actualiza agregados
                    txn.updateData([
                        "votesUp": up,
                        "votesDown": down,
                        "trustPct": trust,
                        "updatedAt": FieldValue.serverTimestamp()
                    ], forDocument: amenityRef)

                    return nil
                } catch let e as NSError {
                    errorPointer?.pointee = e
                    return nil
                }
            }
        }
    }
