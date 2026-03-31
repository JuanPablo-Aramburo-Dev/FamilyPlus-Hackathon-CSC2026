import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FirestoreTestView: View {
    @State private var msg = "⏳ Probando conexión con Firestore..."
    let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text(msg)
                .multilineTextAlignment(.center)
                .padding()

            Button("Probar conexión") {
                Task { await runTest() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    func runTest() async {
        do {
            // iniciar sesión anónima
            if Auth.auth().currentUser == nil {
                try await Auth.auth().signInAnonymously()
            }

            // escribir un documento de prueba
            let ref = db.collection("tests").document("first-test")
            try await ref.setData([
                "name": "FamilyPlus MVP",
                "ok": true,
                "timestamp": FieldValue.serverTimestamp()
            ])

            // leerlo de vuelta
            let snap = try await ref.getDocument()
            if snap.exists {
                msg = "✅ Firestore conectado correctamente."
            } else {
                msg = "⚠️ Documento no encontrado."
            }
        } catch {
            msg = "❌ Error: \(error.localizedDescription)"
        }
    }
}
