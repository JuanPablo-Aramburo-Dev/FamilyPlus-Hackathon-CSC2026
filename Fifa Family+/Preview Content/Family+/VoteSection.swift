import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct VoteSection: View {
    let amenityId: String
    let fallbackName: String
    let stadiumId: String

    @State private var amenity: Amenity?
    @State private var myVote: Int = 0            // -1, 0, 1
    @State private var isBusy = false
    @State private var showLoginAlert = false

    @StateObject private var repo = VoteRepo()
    @State private var amenityListener: ListenerRegistration?
    @State private var myVoteListener: ListenerRegistration?

    @EnvironmentObject private var session: UserSession

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Confianza del lugar").font(.headline)
                Spacer()
                TrustBadgeMini(trust: amenity?.trustPct ?? 0)
            }

            if let a = amenity {
                Text("👍 \(a.votesUp)   👎 \(a.votesDown)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                // 👍
                Button {
                    handleVoteTap(target: 1)
                } label: {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical, 10).padding(.horizontal, 14)
                        .background(myVote == 1 ? Color.green.opacity(0.18) : Color.clear)
                        .foregroundStyle(myVote == 1 ? Color.green : Color.primary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(myVote == 1 ? Color.green : Color.secondary.opacity(0.25), lineWidth: 1)
                        )
                }
                .disabled(isBusy)

                // 👎
                Button {
                    handleVoteTap(target: -1)
                } label: {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical, 10).padding(.horizontal, 14)
                        .background(myVote == -1 ? Color.red.opacity(0.18) : Color.clear)
                        .foregroundStyle(myVote == -1 ? Color.red : Color.primary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(myVote == -1 ? Color.red : Color.secondary.opacity(0.25), lineWidth: 1)
                        )
                }
                .disabled(isBusy)

                if session.isGuest {
                    Spacer()
                    Text("Inicia sesión para votar")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
        }
        .alert("Necesitas iniciar sesión", isPresented: $showLoginAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Los invitados no pueden votar.")
        }
        .onAppear {
            // Amenity agregado
            amenityListener = repo.listenAmenity(amenityId: amenityId) { a in
                self.amenity = a
            }
            // Mi voto (si hay usuario)
            myVoteListener = repo.listenMyVote(amenityId: amenityId) { v in
                self.myVote = v
            }
        }
        .onDisappear {
            amenityListener?.remove()
            myVoteListener?.remove()
        }
    }

    private func handleVoteTap(target: Int) {
        // Invitados: no dejar pasar
        guard !session.isGuest else {
            showLoginAlert = true
            return
        }
        // Evitar taps mientras escribimos
        guard !isBusy else { return }

        isBusy = true
        Task {
            // Toggle: si toco el mismo, quitar voto (0)
            let next = (myVote == target) ? 0 : target
            do {
                try await repo.setVote(
                    amenityId: amenityId,
                    fallbackName: fallbackName,
                    stadiumId: stadiumId,
                    value: next
                )
            } catch {
                // opcional: mostrar un toast / print
                print("setVote error:", error.localizedDescription)
            }
            isBusy = false
        }
    }
}
