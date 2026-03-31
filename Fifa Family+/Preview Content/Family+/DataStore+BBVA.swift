import Foundation
import CoreLocation

extension DataStore {
    /// Servicios familiares cercanos al Estadio BBVA (Monterrey)
    /// Coordenadas aproximadas para desarrollo; puedes ajustar según datos reales.
    static func familyServicesNearBBVA() -> [FamilyService] {
        [
            // 🌳 Parques y áreas recreativas
            FamilyService(
                name: String(localized: "svc.bbva.parqueLaPastora.name"),
                category: .parque,
                coordinate: CLLocationCoordinate2D(latitude: 25.6739, longitude: -100.2389),
                description: String(localized: "svc.bbva.parqueLaPastora.desc"),
                amenities: [
                    String(localized: "amenity.playground"),
                    String(localized: "amenity.shade"),
                    String(localized: "amenity.publicRestrooms")
                ],
                hours: String(localized: "hours.6_19"),
                phone: nil
            ),
            FamilyService(
                name: String(localized: "svc.bbva.zooLaPastora.name"),
                category: .parque,
                coordinate: CLLocationCoordinate2D(latitude: 25.6718, longitude: -100.2406),
                description: String(localized: "svc.bbva.zooLaPastora.desc"),
                amenities: [
                    String(localized: "amenity.kidsPlay"),
                    String(localized: "amenity.restrooms"),
                    String(localized: "amenity.parking")
                ],
                hours: String(localized: "hours.9_17"),
                phone: nil
            ),

            // 🏥 Clínicas y servicios médicos
            FamilyService(
                name: String(localized: "svc.bbva.christusSur.name"),
                category: .clinica,
                coordinate: CLLocationCoordinate2D(latitude: 25.6709, longitude: -100.2437),
                description: String(localized: "svc.bbva.christusSur.desc"),
                amenities: [
                    String(localized: "amenity.emergency24h"),
                    String(localized: "amenity.pediatrics"),
                    String(localized: "amenity.pharmacy")
                ],
                hours: String(localized: "hours.open24"),
                phone: "81 8123 0300"
            ),
            FamilyService(
                name: String(localized: "svc.bbva.clinicaEmergencias.name"),
                category: .clinica,
                coordinate: CLLocationCoordinate2D(latitude: 25.6751, longitude: -100.2452),
                description: String(localized: "svc.bbva.clinicaEmergencias.desc"),
                amenities: [
                    String(localized: "amenity.fastCare"),
                    String(localized: "amenity.parking"),
                    String(localized: "amenity.attachedPharmacy")
                ],
                hours: String(localized: "hours.8_22"),
                phone: "81 8346 9020"
            ),
            FamilyService(
                name: String(localized: "svc.bbva.fahorro.name"),
                category: .farmacia,
                coordinate: CLLocationCoordinate2D(latitude: 25.6768, longitude: -100.2408),
                description: String(localized: "svc.bbva.fahorro.desc"),
                amenities: [
                    String(localized: "amenity.diapersAndFormula"),
                    String(localized: "amenity.pediatricMeds"),
                    String(localized: "amenity.parking")
                ],
                hours: String(localized: "hours.8_23"),
                phone: "81 8399 1111"
            ),
            FamilyService(
                name: String(localized: "svc.bbva.farmaciaGdl.name"),
                category: .farmacia,
                coordinate: CLLocationCoordinate2D(latitude: 25.6763, longitude: -100.2423),
                description: String(localized: "svc.bbva.farmaciaGdl.desc"),
                amenities: [
                    String(localized: "amenity.driveThruPharmacy"),
                    String(localized: "amenity.babyProducts"),
                    String(localized: "amenity.service24h")
                ],
                hours: String(localized: "hours.open24"),
                phone: "81 8124 3030"
            ),

            // 🛒 Supermercados y tiendas
            FamilyService(
                name: String(localized: "svc.bbva.heb.name"),
                category: .supermercado,
                coordinate: CLLocationCoordinate2D(latitude: 25.6769, longitude: -100.2359),
                description: String(localized: "svc.bbva.heb.desc"),
                amenities: [
                    String(localized: "amenity.highChairs"),
                    String(localized: "amenity.foodArea"),
                    String(localized: "amenity.babySection")
                ],
                hours: String(localized: "hours.7_22"),
                phone: "81 8030 4000"
            ),
            FamilyService(
                name: String(localized: "svc.bbva.oxxo.name"),
                category: .supermercado,
                coordinate: CLLocationCoordinate2D(latitude: 25.6748, longitude: -100.2411),
                description: String(localized: "svc.bbva.oxxo.desc"),
                amenities: [
                    String(localized: "amenity.diapers"),
                    String(localized: "amenity.snacks"),
                    String(localized: "amenity.atm")
                ],
                hours: String(localized: "hours.open24"),
                phone: nil
            ),

            // ☕ Cafeterías y restaurantes
            FamilyService(
                name: String(localized: "svc.bbva.cafeLocal.name"),
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6726, longitude: -100.2434),
                description: String(localized: "svc.bbva.cafeLocal.desc"),
                amenities: [
                    String(localized: "amenity.wifi"),
                    String(localized: "amenity.changingTable"),
                    String(localized: "amenity.highChairs")
                ],
                hours: String(localized: "hours.7_21"),
                phone: nil
            ),
            FamilyService(
                name: String(localized: "svc.bbva.starbucks.name"),
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6773, longitude: -100.2367),
                description: String(localized: "svc.bbva.starbucks.desc"),
                amenities: [
                    String(localized: "amenity.wifi"),
                    String(localized: "amenity.restrooms"),
                    String(localized: "amenity.acArea")
                ],
                hours: String(localized: "hours.6_22"),
                phone: "81 8359 1200"
            ),
            FamilyService(
                name: String(localized: "svc.bbva.laspampas.name"),
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6754, longitude: -100.2458),
                description: String(localized: "svc.bbva.laspampas.desc"),
                amenities: [
                    String(localized: "amenity.kidsMenu"),
                    String(localized: "amenity.playground"),
                    String(localized: "amenity.wideRestrooms")
                ],
                hours: String(localized: "hours.12_23"),
                phone: "81 8098 9901"
            ),

            // 🅿️ Estacionamientos
            FamilyService(
                name: String(localized: "svc.bbva.parkingOficial.name"),
                category: .estacionamiento,
                coordinate: CLLocationCoordinate2D(latitude: 25.6731, longitude: -100.2461),
                description: String(localized: "svc.bbva.parkingOficial.desc"),
                amenities: [
                    String(localized: "amenity.ramps"),
                    String(localized: "amenity.security"),
                    String(localized: "amenity.wideSpots")
                ],
                hours: String(localized: "hours.events"),
                phone: nil
            ),
            FamilyService(
                name: String(localized: "svc.bbva.parkingNorte.name"),
                category: .estacionamiento,
                coordinate: CLLocationCoordinate2D(latitude: 25.6741, longitude: -100.2431),
                description: String(localized: "svc.bbva.parkingNorte.desc"),
                amenities: [
                    String(localized: "amenity.ramps"),
                    String(localized: "amenity.shade"),
                    String(localized: "amenity.security")
                ],
                hours: String(localized: "hours.6_22"),
                phone: nil
            )
        ]
    }
}
