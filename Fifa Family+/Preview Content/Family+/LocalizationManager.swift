import SwiftUI

// Idiomas soportados (un SOLO enum en todo el proyecto)
enum AppLanguage: String, CaseIterable, Identifiable {
    case es = "es"     // Español
    case en = "en"     // English
    case fr = "fr"     // Français
    case ar = "ar"     // العربية
    case pt = "pt"     // Português

    var id: String { rawValue }

    /// Nombre “autónimo” que verá el usuario
    var displayName: String {
        switch self {
        case .es: return "Español"
        case .en: return "English"
        case .fr: return "Français"
        case .ar: return "العربية"
        case .pt: return "Português"
        }
    }

    var isRTL: Bool { self == .ar }
}

// Manejador central de localización
final class L10n: ObservableObject {
    static let shared = L10n()

    @Published private(set) var language: AppLanguage
    private let storageKey = "app.language"

    private init() {
        let saved = UserDefaults.standard.string(forKey: storageKey)
        self.language = AppLanguage(rawValue: saved ?? "es") ?? .es
        applySemanticDirection()
    }

    /// Bundle del .lproj elegido
    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let b = Bundle(path: path) else { return .main }
        return b
    }

    /// Cambia idioma en caliente + persiste
    func setLanguage(_ lang: AppLanguage) {
        guard lang != language else { return }
        language = lang
        UserDefaults.standard.set(lang.rawValue, forKey: storageKey)
        applySemanticDirection()
        objectWillChange.send()
    }

    /// Traducción (usa con Text(l10n("clave")))
    func t(_ key: String) -> String {
        NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
    }

    private func applySemanticDirection() {
        let attr: UISemanticContentAttribute = language.isRTL ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attr
        UINavigationBar.appearance().semanticContentAttribute = attr
    }
}

// Helper global corto
@inline(__always) func l10n(_ key: String) -> String { L10n.shared.t(key) }
