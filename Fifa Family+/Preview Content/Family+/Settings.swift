//
//  Settings.swift
//  Family+
//
//  Created by CETYS Universidad  on 11/10/25.
//

import SwiftUI

struct Settings: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome = false
    @State private var navigateToLanguages = false
    @State private var navigateToNotifications = false
    @State private var navigateToAbout = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            // Fondo degradado azul
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 30/255, green: 70/255, blue: 140/255),
                    Color(red: 40/255, green: 90/255, blue: 180/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text(l10n("settings.title"))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Contenedor blanco con opciones
                VStack(spacing: 0) {
                    // Navegaciones invisibles
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToHome) { EmptyView() }
                    
                    NavigationLink(destination: Languages().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToLanguages) { EmptyView() }
                    
                    NavigationLink(destination: About().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToAbout) { EmptyView() }
                    
                    // Opción Home
                    Button(action: { navigateToHome = true }) {
                        SettingsOptionRow(
                            icon: "house.fill",
                            title: l10n("settings.option.home")
                        )
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    // Opción Idiomas
                    Button(action: { navigateToLanguages = true }) {
                        SettingsOptionRow(
                            icon: "character.textbox",
                            title: l10n("settings.option.languages")
                        )
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    // Opción Sobre nosotros
                    Button(action: { navigateToAbout = true }) {
                        SettingsOptionRow(
                            icon: "face.smiling.fill",
                            title: l10n("settings.option.about")
                        )
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    // Opción Cerrar sesión
                    Button(action: { showLogoutAlert = true }) {
                        SettingsOptionRow(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: l10n("settings.option.logout")
                        )
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text(l10n("settings.logout.alert.title")),
                            message: Text(l10n("settings.logout.alert.message")),
                            primaryButton: .destructive(Text(l10n("settings.logout.confirm"))) {
                                // TODO: Lógica real de logout (si la agregan después)
                                // Por ahora, solo cerrar alerta o navegar si quieren.
                            },
                            secondaryButton: .cancel(Text(l10n("settings.logout.cancel")))
                        )
                    }
                    
                    Spacer()
                }
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .navigationBarHidden(true)
    }
}

// Componente para cada fila de opción
struct SettingsOptionRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.black)
                .frame(width: 40)
            
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(red: 230/255, green: 80/255, blue: 60/255))
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background(Color.white)
    }
}

// Extensión para redondear esquinas específicas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Settings()
}
