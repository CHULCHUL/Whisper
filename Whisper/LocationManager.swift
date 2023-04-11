//
//  LocationManager.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import Combine
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var status: CLAuthorizationStatus {
        didSet {
            switch status {
                case .notDetermined:
                    hasAuth = false
                case .restricted:
                    hasAuth = false
                case .denied:
                    hasAuth = false
                case .authorizedAlways:
                    hasAuth = true
                case .authorizedWhenInUse:
                    hasAuth = true
                @unknown default:
                    hasAuth = true
            }
        }
    }

    @Published private(set) var address = "위치 찾는 중"
    @Published private(set) var location: CLLocation? {
        didSet {
            Task { @MainActor in
                address = await geocoder.address(for: location) ?? ""
            }
        }
    }
    @Published private(set) var hasAuth = false {
        didSet {
            if hasAuth {
                manager.startUpdatingLocation()
            }
        }
    }

    override init() {
        status = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }
}

extension LocationManager {
    func request() {
        if case .notDetermined = self.status {
            self.manager.requestWhenInUseAuthorization()
        }
        else if case .denied = self.status {
            //TODO: 얼럿으로 묻고 설정화면으로 보내야함.
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
}

extension CLGeocoder {
    func address(for location: CLLocation?) async -> String? {
        guard let location else { return nil }
        guard let placemarks = try? await self.reverseGeocodeLocation(location) else { return nil }
        guard let placemark = placemarks.first else { return nil }

        if let name = placemark.name {
            return name + (placemark.subLocality.map { ", " + $0 } ?? "")
        }
        else if let thoroughfare = placemark.subThoroughfare {
            return (placemark.subThoroughfare ?? " ") + thoroughfare
        }
        else {
            return placemark.areasOfInterest?.first
            ?? placemark.subLocality
            ?? placemark.locality
            ?? placemark.subAdministrativeArea
            ?? placemark.administrativeArea
            ?? "위치 찾는 중"
        }
    }
}

extension CLLocationCoordinate2D {
    var toLocation: CLLocation {
        .init(latitude: self.latitude,
              longitude: self.longitude)
    }
}
