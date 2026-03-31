//
//  Logo1.swift
//  Family+
//
//  Created by CETYS Universidad  on 15/10/25.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        Init()
    }
}

struct Init: View {
    @State private var logoOpacity: Double = 0
    @State private var navigateToNext = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Image("Logo")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(logoOpacity)
                
                // NavigationLink invisible que se activa automáticamente
                NavigationLink(
                    destination: Phrase().navigationBarBackButtonHidden(true),
                    isActive: $navigateToNext
                ) {
                    EmptyView()
                }
            }
            .onAppear {
                // Animación de aparición
                withAnimation(.easeIn(duration: 5.0)) {
                    logoOpacity = 1.0
                }
                
                // Animación de desvanecido y navegación
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    navigateToNext = true
                }
            }
        }
    }
}

#Preview {
    Logo()
}
