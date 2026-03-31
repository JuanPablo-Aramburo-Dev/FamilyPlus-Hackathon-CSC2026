import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Family_App: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var session = UserSession()

  @AppStorage("app.lang")
  private var appLang: String = Locale.current.language.languageCode?.identifier ?? "es"

  var body: some Scene {
    WindowGroup {
      StartFlowView()                                       // 👈 SIEMPRE arranca aquí
        .environmentObject(L10n.shared)
        .environmentObject(session)
        .environment(\.locale,
                     Locale(identifier: UserDefaults.standard.string(forKey: "app.language")
                                     ?? appLang))
    }
  }
}
