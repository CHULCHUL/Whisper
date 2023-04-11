//
//  WhisperApp.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import SwiftUI

@main
struct WhisperApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            firstView
                .environmentObject(locationManager)
                .animation(.easeInOut(duration: 1), value: locationManager.hasAuth)
        }
    }
}

private extension WhisperApp {
    @ViewBuilder
    var firstView: some View {
        if locationManager.hasAuth {
            MainView(viewModel: .init())
                .transition(.opacity)
        }
        else {
            OnboardingView()
                .transition(.asymmetric(insertion: .move(edge: .bottom),
                                        removal: .move(edge: .bottom)))
        }
    }
}
