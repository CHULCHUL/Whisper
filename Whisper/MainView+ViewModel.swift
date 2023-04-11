//
//  MainView+ViewModel.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/11.
//

import Combine

extension MainView {
    final class ViewModel: ObservableObject {
        private var bag: Set<AnyCancellable> = []

        //        var region: MKCoordinateRegion?
        init() {
        }
    }
}

//extension MainView.ViewModel {
//    static let defaultRegion = MKCoordinateRegion(center: .init(latitude: 51.507222,
//                                                                longitude: -0.1275),
//                                                  span: .init(latitudeDelta: 0.015,
//                                                              longitudeDelta: 0.015))
//    func move(to location: CLLocation?, span: MKCoordinateSpan) {
//        guard let coordinate = location?.coordinate else { return }
//        guard CLLocationCoordinate2DIsValid(coordinate) else { return }
//        self.region = .init(center: coordinate, span: span)
//    }
//}
