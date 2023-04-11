//
//  MapView.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/11.
//

import SwiftUI
import MapKit

final class Annotation: NSObject, Identifiable {
    let id = UUID()

    private let location: CLLocation
    private let name: String
    let image: String

    init(name: String, image: String, location: CLLocation) {
        self.name = name
        self.image = image
        self.location = location
    }
}

extension Annotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }

    var title: String? {
        name
    }

    var subtitle: String? {
        nil
    }
}

extension Annotation {
    enum K {
        static let user = "map_annotatopn_user"
    }
    static var items: [Annotation] {
        [
            .init(name: "Golden Gate Bridge",
                  image: "badge.plus.radiowaves.right",
                  location: CLLocation(latitude: 37.83266647135866, longitude: -122.47709319891423)),
            .init(name: "Statue of Liberty",
                  image: "pencil.circle",
                  location: CLLocation(latitude: 40.700005935766036, longitude: -74.044917569399)),
            .init(name: "Eiffel Tower",
                  image: "applepencil",
                  location: CLLocation(latitude: 40.748570526797614, longitude: -73.98560002833449)),
            .init(name: "Gilroy Garlic",
                  image: "pencil.and.outline",
                  location: CLLocation(latitude: 36.988917901109794, longitude: -121.55013690759337)),
            .init(name: "Sea World",
                  image: "airpodsmax",
                  location: CLLocation(latitude: 32.761804202349005, longitude: -117.2255336727055))
        ]
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion?
    @Binding var state: MainView.Bottom1stState?
    let mapType: MKMapType
    let items: [Annotation]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        if let region {
            mapView.setRegion(region, animated: true)
        }
        mapView.showsUserLocation = true
        mapView.mapType = mapType
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        mapView.addAnnotations(items)
        mapView.register(ClusterAnnotatioView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let region {
            uiView.setRegion(region, animated: true)
        }
        uiView.mapType = mapType
    }

    func makeCoordinator() -> Coordinator {
        .init(for: self)
    }
}

final class ClusterAnnotatioView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        displayPriority = .defaultHigh
        collisionMode = .circle

        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with annotation: MKAnnotation) {
        guard let annotation = annotation as? MKClusterAnnotation else { return }

        glyphImage = UIGraphicsImageRenderer(size: .init(width: 40.0, height: 40.0)).image { _ in
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0),]
            let count = annotation.memberAnnotations.count
            let text = 100 <= count ? "99+" : "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2,
                              width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}


fileprivate struct ThreadAnnotationView: UIViewRepresentable {
    let annotation: Annotation

    func makeUIView(context: Context) -> MKMarkerAnnotationView {
        .init(annotation: annotation, reuseIdentifier: "customMapAnnotation")
    }

    func updateUIView(_ uiView: MKMarkerAnnotationView, context: Context) {
        uiView.clusteringIdentifier = String(describing: MKMarkerAnnotationView.self)
        uiView.canShowCallout = true
        //        if let title = annotation.title {
        //            uiView.glyphText = title
        //        }
//        uiView.glyphImage = annotation.image.asUIImage
        uiView.markerTintColor = .systemPink
        uiView.titleVisibility = .visible
        //        annotationView.detailCalloutAccessoryView = UIImage(named: mapPlace.image).map(UIImageView.init)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
    }
}
