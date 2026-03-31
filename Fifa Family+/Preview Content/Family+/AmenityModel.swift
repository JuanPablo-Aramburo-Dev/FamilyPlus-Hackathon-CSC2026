import Foundation

struct Amenity: Identifiable {
    let id, name, stadiumId: String
    let votesUp, votesDown, trustPct: Int
}
