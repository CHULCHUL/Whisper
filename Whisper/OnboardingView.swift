//
//  OnboardingView.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var locationManager: LocationManager

    @State private var showMessage = false
    @State private var showButton = false

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 16)

            Spacer()

            if showMessage {
                Image(systemName: "map")
                    .foregroundColor(.orange)
                    .font(.largeTitle.bold())
                    .scaleEffect(x: 2, y: 2)

                Text("위치기반 서비스인데 위치 동의해라. 안하면 못써")
                    .foregroundColor(.primary)
                    .padding()
                    .padding()

                Spacer()
                    .frame(height: 24)
            }

            if showButton {
                Button {
                    locationManager.request()
                } label: {
                    Text("위치 동의하기")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 200)
                        .foregroundColor(.primary)
                        .background(.orange)
                        .cornerRadius(16)
                }
            }

            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                showMessage = true
            }
        }
        .toggleAnimation(bindValue: showMessage) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showButton = showMessage
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDevice(.init(rawValue: "iPhone 12 mini"))
            .previewDisplayName("iPhone 12 mini")
            .environmentObject(LocationManager())
        OnboardingView()
            .previewDevice(.init(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
            .environmentObject(LocationManager())
        OnboardingView()
            .previewDevice(.init(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
            .environmentObject(LocationManager())
    }
}
