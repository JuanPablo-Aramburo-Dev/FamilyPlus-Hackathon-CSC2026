import SwiftUI
import MapKit

// ✅ Usa SIEMPRE l10n(_:), que ya apunta a L10n.shared.bundle
struct Home: View {
    @EnvironmentObject private var i18n: L10n   // 🔑 observa el idioma activo

    // Estado existente
    @State private var searchText = ""
    @State private var showSideMenu = false
    @State private var navigateToProfile = false
    @State private var navigateToHome = false
    @State private var navigateToSettings = false
    @State private var navigateToLanguages = false
    @State private var navigateToBBVA = false
    @State private var navigateToAbout = false
    @State private var showSearchBar = false
    @EnvironmentObject private var session: UserSession

    // Alturas para sincronizar el grid
    private let leftTopHeight: CGFloat = 140     // mapa
    private let gridSpacing: CGFloat = 16        // el spacing del HStack

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.5149, longitude: -117.0382), // Tijuana, BC
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 0) {
                        // ====== Top image / header ======
                        ZStack {
                            Image("Estadio BBVA")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()

                            Color.black.opacity(0.25)

                            // 🔍 Barra de búsqueda condicional
                            VStack {
                                if showSearchBar {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)

                                        TextField(l10n("search_placeholder"), text: $searchText)
                                            .foregroundColor(.black)

                                        Button(action: {
                                            withAnimation {
                                                showSearchBar = false
                                                searchText = ""
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 120)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                                Spacer()
                            }
                        }
                        .frame(height: 200)

                        // ====== CONTENIDO PRINCIPAL ======
                        ZStack {
                            Color.white.ignoresSafeArea()

                            VStack(spacing: 18) {
                                // ---------- Banner rojo ----------
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color(red: 230/255, green: 80/255, blue: 60/255))
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                        .padding(.top, 18)

                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(l10n("discover_routes"))
                                                .font(.system(size: 32, weight: .heavy))
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)

                                            Text(l10n("no_one_left_behind"))
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                        .padding(.leading, 20)
                                        .padding(.vertical, 18)

                                        Spacer()
                                    }
                                }
                                .frame(height: 170)
                                .padding(.horizontal, 20)
                                .overlay(alignment: .topTrailing) {
                                    Image("world cup")
                                        .resizable()
                                        .frame(width: 220, height: 300)
                                        .foregroundColor(.yellow.opacity(0.95))
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 37, trailing: 0))
                                        .offset(x:40)
                                }

                                // ---------- Grid principal ----------
                                HStack(alignment: .top, spacing: 16) {

                                    // Columna izquierda
                                    VStack(spacing: 16) {
                                        // Mini mapa con label
                                        ZStack(alignment: .bottomLeading) {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)

                                            Map(coordinateRegion: $region)
                                                .disabled(true)
                                                .cornerRadius(20)

                                            Text(l10n("you_are_here"))
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(Color(red: 230/255, green: 80/255, blue: 60/255))
                                                .clipShape(Capsule())
                                                .padding(10)
                                        }
                                        .frame(width: 150, height: leftTopHeight)

                                        // Card roja cuadrada
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    LinearGradient(colors: [Color.red, Color.orange.opacity(0.9)],
                                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                            VStack(spacing: 6) {
                                                Image(systemName: "mappin.circle.fill")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.white)
                                                Text(l10n("nearby_services"))
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .frame(width: 150)
                                        .onTapGesture { navigateToBBVA = true }
                                    }
                                    .frame(width: 150)

                                    // Columna derecha: tarjeta con imagen, overlay y CTA
                                    RightTipCard(
                                        title: l10n("inclusive_tip"),
                                        message: l10n("inclusive_tip_message"),
                                        chips: [l10n("chip_access"), l10n("chip_nursing"), l10n("chip_firstaid")],
                                        imageName: "families-bg",
                                        ctaTitle: l10n("view_nearby_services")
                                    ) { }
                                    .frame(maxWidth: .infinity, minHeight: 270, maxHeight: 320)
                                }
                                .padding(.horizontal, 20)

                                Spacer(minLength: 10)

                                // ---------- Bottom Bar azul ----------
                                HStack(spacing: 0) {
                                    BottomBarButton(system: "mappin.circle") { navigateToBBVA = true }
                                    BottomBarButton(system: "house") { navigateToHome = true }
                                    BottomBarButton(system: "person") { navigateToProfile = true }
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 22)
                                .background(Color(red: 30/255, green: 70/255, blue: 130/255))
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)

                    // Navegaciones invisibles
                    NavigationLink(destination: Profile().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToProfile) { EmptyView() }
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToHome) { EmptyView() }
                    NavigationLink(destination: Settings().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToSettings) { EmptyView() }
                    NavigationLink(destination: Languages().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToLanguages) { EmptyView() }
                    NavigationLink(destination: MapaExteriorView().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToBBVA) { EmptyView() }
                    NavigationLink(destination: About().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToAbout) { EmptyView() }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Menú lateral
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { withAnimation { showSideMenu.toggle() } }) {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    // Buscar
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { withAnimation { showSearchBar.toggle() } }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            // ====== Side Menu overlay ======
            if showSideMenu {
                HStack(spacing: 0) {
                    SideMenuView(
                        showSideMenu: $showSideMenu,
                        navigateToProfile: $navigateToProfile,
                        navigateToHome: $navigateToHome,
                        navigateToSettings: $navigateToSettings,
                        navigateToLanguages: $navigateToLanguages,
                        navigateToAbout: $navigateToAbout
                    )
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)

                    Spacer()
                }
                .background(
                    Color.black.opacity(0.3)
                        .onTapGesture { withAnimation { showSideMenu = false } }
                )
                .zIndex(1)
            }
        }
        .id(i18n.language.rawValue)
    }
}

// ====== Componentes auxiliares ======
private struct BottomBarButton: View {
    let system: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

struct SideMenuView: View {
    @Binding var showSideMenu: Bool
    @Binding var navigateToProfile: Bool
    @Binding var navigateToHome: Bool
    @Binding var navigateToSettings: Bool
    @Binding var navigateToLanguages: Bool
    @Binding var navigateToAbout: Bool
    @EnvironmentObject private var session: UserSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Perfil
            VStack(alignment: .leading, spacing: 5) {
                Button(action: {
                    withAnimation {
                        showSideMenu = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToProfile = true }
                    }
                }) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                }

                Text(session.displayName)
                    .font(.headline)

                                // ✅ Correo dinámico
                Text(session.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)

            Divider().padding(.vertical, 10)

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToHome = true }
                }
            }) {
                MenuItem(icon: "house", title: l10n("home"))
            }

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToLanguages = true }
                }
            }) {
                MenuItem(icon: "globe", title: l10n("languages"))
            }

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToAbout = true }
                }
            }) {
                MenuItem(icon: "info.circle", title: l10n("about_us"))
            }

            Spacer()

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToSettings = true }
                }
            }) {
                MenuItem(icon: "gear", title: l10n("settings"))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: 250, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .shadow(radius: 5)
    }
}

struct MenuItem: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(title)
                .font(.system(size: 18))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.red)
        }
        .foregroundColor(.black)
    }
}

private struct RightTipCard: View {
    let title: String
    let message: String
    let chips: [String]
    let imageName: String?
    let ctaTitle: String
    let action: () -> Void

    var body: some View {
        ZStack {
            Group {
                if let imageName, UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            LinearGradient(
                                colors: [.black.opacity(0.05), .black.opacity(0.65)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipped()
                } else {
                    LinearGradient(
                        colors: [
                            Color(red: 255/255, green: 205/255, blue: 80/255),
                            Color(red: 255/255, green: 190/255, blue: 50/255)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

            // Contenido
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.25))
                    .clipShape(Capsule())
                    .accessibilityAddTraits(.isHeader)

                Text(message)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)

                Spacer(minLength: 0)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), alignment: .leading),
                        GridItem(.flexible(), alignment: .leading)
                    ],
                    alignment: .leading,
                    spacing: 8
                ) {
                    ForEach(chips, id: \.self) { chip in
                        Text(chip)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                            .fixedSize()
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview { Home().environmentObject(L10n.shared)
    .environmentObject(UserSession()) }
