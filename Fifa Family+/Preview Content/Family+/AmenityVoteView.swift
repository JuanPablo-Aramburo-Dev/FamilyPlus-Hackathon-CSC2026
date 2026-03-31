import SwiftUI
import FirebaseFirestore

struct AmenityVoteView: View {
    let amenityId: String
    @State private var amenity: Amenity?          // o AmenityDoc si lo renombraste
    @StateObject private var repo = VoteRepo()
    @State private var listener: ListenerRegistration?

    var body: some View {
        VStack(spacing: 16) {
            if let a = amenity {
                Text(a.name).font(.title3).bold()
                TrustBadgeMini(trust: a.trustPct)
                Text("👍 \(a.votesUp)   👎 \(a.votesDown)").font(.subheadline)
            }

            HStack(spacing: 12) {
                Button {
                    Task {
                        let fallbackName = amenity?.name ?? "Amenity"
                        let stadId = amenity?.stadiumId ?? stadiumId(from: amenityId)
                        try? await repo.setVote(
                            amenityId: amenityId,
                            fallbackName: fallbackName,
                            stadiumId: stadId,
                            value: 1
                        )
                    }
                } label: { Label("Seguro", systemImage: "hand.thumbsup.fill") }
                .buttonStyle(.borderedProminent)

                Button {
                    Task {
                        let fallbackName = amenity?.name ?? "Amenity"
                        let stadId = amenity?.stadiumId ?? stadiumId(from: amenityId)
                        try? await repo.setVote(
                            amenityId: amenityId,
                            fallbackName: fallbackName,
                            stadiumId: stadId,
                            value: -1
                        )
                    }
                } label: { Label("No seguro", systemImage: "hand.thumbsdown.fill") }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    Task {
                        let fallbackName = amenity?.name ?? "Amenity"
                        let stadId = amenity?.stadiumId ?? stadiumId(from: amenityId)
                        try? await repo.setVote(
                            amenityId: amenityId,
                            fallbackName: fallbackName,
                            stadiumId: stadId,
                            value: 0
                        )
                    }
                } label: { Text("Quitar voto") }
            }
        }
        .onAppear {
            listener = repo.listenAmenity(amenityId: amenityId) { a in
                self.amenity = a
            }
        }
        .onDisappear { listener?.remove() }
    }
}
