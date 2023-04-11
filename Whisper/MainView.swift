//
//  MainView.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import SwiftUI
import MapKit

extension MainView {
    enum Bottom1stState {
        case currentNew
        case currentOld
        case far
        case farCluster

        var title: String {
            switch self {
                case .currentNew:
                    return "첫 쓰레드 열기, 첫쇽닥!"
                case .currentOld:
                    return "쇽닥하기"
                case .far:
                    return "몰래보기"
                case .farCluster:
                    return "크게 몰래보기"
            }
        }
    }

    enum Bottom2ndState {
        case firstWrite

        var title: String {
            switch self {
                case .firstWrite:
                    return "쇽닥하기"
            }
        }
    }

    enum Field: Hashable {
        case firstBimil
    }
}

struct MainView: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var locationManager: LocationManager

    @State private var region: MKCoordinateRegion?
//    {
//        didSet {
//            Task {
//                address = await CLGeocoder().address(for: region.center.toLocation) ?? ""
//            }
//        }
//    }
//    @State private var selectedPinAddress = "현재위치"
    @State private var state1st: Bottom1stState?
    @State private var state2nd: Bottom2ndState?
//    @State private var trackingMode: MapUserTrackingMode = .none
//    @State private var isUserLocation = false

    @State private var bimil = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        contentView
            .multilineTextAlignment(.center)
            .ignoresSafeArea()
            .overlay { overlayView }
            .onReceive(locationManager.$location.filter { _ in nil == region }.compactMap { $0 }) {
                move(to: $0,
                     span: .init(latitudeDelta: 0.5,
                                 longitudeDelta: 0.5))
            }
    }
}

private extension MainView {
    func move(to location: CLLocation?, span: MKCoordinateSpan) {
        guard let coordinate = location?.coordinate else { return }
        guard CLLocationCoordinate2DIsValid(coordinate) else { return }
        region = .init(center: coordinate, span: span)
    }

    var buttonTitle: String? {
        state2nd?.title ?? state1st?.title
    }

    var buttonForegroundColor: Color {
        if nil != state2nd {
            return bimil.isEmpty ? .white.opacity(0.5) : .white
        }
        else if nil != state1st {
            return .white
        }
        else {
            return .white.opacity(0.5)
        }
    }

    var buttonBackgroundColor: Color {
        if nil != state2nd {
            return bimil.isEmpty ? .orange.opacity(0.25) : .orange
        }
        else if nil != state1st {
            return .orange
        }
        else {
            return .orange.opacity(0.25)
        }
    }
}

private extension MainView {
    @ViewBuilder
    var contentView: some View {
        MapView(region: $region,
                state: $state1st,
                mapType: .standard,
                items: Annotation.items)
        //        Map(coordinateRegion: $region,
        //            showsUserLocation: true,
        //            userTrackingMode: $trackingMode,
        //            annotationItems: MainView.Annotation.mapPlaces) { item in
        //            MapAnnotation(coordinate: item.coordinate) {
        ////                ThreadAnnotationView(annotation: item)
        //                item.image
        //                    .font(.callout)
        //                    .foregroundColor(.purple)
        //            }
        //        }
    }

    @ViewBuilder
    var overlayView: some View {
        if case .firstWrite = state2nd {
            DimView()
                .zIndex(50)
                .contentShape(Rectangle())
                .onTapGesture {
                    state2nd = nil
                }
        }
        
        VStack {
            if .firstWrite != state2nd {
                HStack {
                    Spacer()
                    functionView
                        .shadow(radius: 8)
                }
            }

            Spacer()

            bottomView
                .shadow(radius: 8)
        }
        .zIndex(60)
        .padding()
        .padding(.bottom)
    }

    @ViewBuilder
    var functionView: some View {
        VStack(spacing: 0) {
            Button {
                move(to: locationManager.location,
                     span: .init(latitudeDelta: 0.015,
                                 longitudeDelta: 0.015))
            } label: {
                Image(systemName: "location.magnifyingglass")
                    .padding(6)
            }

            Divider()

            Button {
            } label: {
                Image(systemName: "location.fill.viewfinder")
                    .padding(6)
            }
        }
        .font(.title2)
        .foregroundColor(.white)
        .padding(4)
        .background(.secondary)
        .cornerRadius(8)
        .fixedSize()
    }

    @ViewBuilder
    var bottomView: some View  {
        VStack {
            if case .firstWrite = state2nd {
                HStack {
                    Spacer()
                    Text("익명보장. 믿고 쓰는 쇽닥")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()

                promptTextEditor
                    .zIndex(70)
                    .transition(.move(edge: .bottom))
            }
            
            HStack {
                Spacer()
                Image(systemName: "scope")
                    .foregroundColor(.orange)
//                Text(address)
                Text(locationManager.address)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            .offset(x: -10)
            .foregroundColor(.white)
            .font(.headline)
            .padding(.horizontal)

            Spacer()
                .frame(height: 16)

            Button {
                if let state2nd {
                    switch state2nd {
                        case .firstWrite:
                            break
                    }
                }
                else {
                    switch state1st {
                        case .currentNew:
                            withAnimation(.easeInOut(duration: 2)) {
                                state2nd = .firstWrite
                            }
                        case .currentOld:
                            break
                        case .far:
                            break
                        case .farCluster:
                            break
                        case .none:
                            break
                    }
                }
            } label: {
                Text(buttonTitle ?? "쓰레드를 선택해주세요")
                    .font(.headline.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(buttonForegroundColor)
                    .background(buttonBackgroundColor)
                    .cornerRadius(16)
                    .animation(nil, value: UUID())
            }

        }
        .padding()
        .background(.secondary)
        .cornerRadius(24)
    }

    @ViewBuilder
    var promptTextEditor: some View {
        TextEditor(text: $bimil)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .foregroundColor(.white)
            .focused($focusedField, equals: .firstBimil)
            .onAppear {
                focusedField = .firstBimil
            }
            .onDisappear() {
                focusedField = nil
            }
            .overlay {
                TextEditor(text: .constant("어떤 이야기를 익명으로 공유하고 싶으신가요?"))
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom)
                    .foregroundColor(.white.opacity(bimil.isEmpty ? 0.5 : 0))
                    .disabled(true)
                    .background(.clear)
            }
            .font(.headline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init())
            .previewDevice(.init(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE 3")
            .environmentObject(LocationManager())
        MainView(viewModel: .init())
            .previewDevice(.init(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
            .environmentObject(LocationManager())
        MainView(viewModel: .init())
            .previewDevice(.init(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
            .environmentObject(LocationManager())
    }
}
