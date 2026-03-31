//
//  Family+.swift
//  Family+
//
//  Created by CETYS Universidad on 14/10/25.
//

import SwiftUI

struct Family: View {
    var body: some View {
        ImageOverlay()
    }
}

struct ImageOverlay: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.0, blue: 0.0),   // tono oscuro vino
                                Color(red: 0.1, green: 0.05, blue: 0.0),  // transición suave
                                Color(red: 0.25, green: 0.15, blue: 0.0)  // toque dorado/ámbar al fondo
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        .overlay(
                            Text(NSLocalizedString("family_title", comment: "Título grande de la pantalla de bienvenida"))
                                .font(.system(size: 70, weight: .semibold, design: .default))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    Family()
}
