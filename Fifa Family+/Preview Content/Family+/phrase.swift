//
//  Phrase.swift
//  Family+
//

import SwiftUI

struct Phrase: View {
    var body: some View {
        Context()
    }
}

struct Context: View {
    @ObservedObject private var l10n = L10n.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var textOpacity: Double = 0
    @State private var navigateToNext = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con degradado
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.0, blue: 0.0),   // vino oscuro
                        Color(red: 0.1, green: 0.05, blue: 0.0),  // transición
                        Color(red: 0.25, green: 0.15, blue: 0.0)  // ámbar/dorado
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Frase localizada
                Text(l10n.t("splash.quote"))
                    .font(.title2) // Dynamic Type friendly
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .opacity(textOpacity)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityLabel(Text(l10n.t("splash.quote")))
            }
            .overlay(
                NavigationLink(
                    destination: Family().navigationBarBackButtonHidden(true),
                    isActive: $navigateToNext
                ) { EmptyView() }
            )
            .onAppear {
                // Respetar "Reduce Motion"
                if reduceMotion {
                    textOpacity = 1.0
                } else {
                    withAnimation(.easeIn(duration: 3.0)) {
                        textOpacity = 1.0
                    }
                }

                // Pasar a la siguiente pantalla
                let delay: Double = reduceMotion ? 0.8 : 5.5
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    navigateToNext = true
                }
            }
        }
    }
}

#Preview {
    Phrase()
}
