//
//  MapView+Coordinator.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/11.
//

import MapKit

extension MapView {
    final class Coordinator: NSObject, MKMapViewDelegate {
        let context: MapView

        init(for context: MapView) {
            self.context = context
            super.init()
        }

        func mapView(_ mapView: MKMapView,
                     viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
                case is MKUserLocation:
                    let view = reuseMKAnnotationView(mapView: mapView,
                                                     viewFor: annotation,
                                                     reuseIdentifier: Annotation.K.user)
                    view.glyphImage = .init(systemName: "badge.plus.radiowaves.right")
                    return view

                case is MKClusterAnnotation:
                    return reuseMKAnnotationView(mapView: mapView,
                                                 viewFor: annotation,
                                                 reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                case let annotation as Annotation:
                    let view = reuseMKAnnotationView(mapView: mapView,
                                                     viewFor: annotation,
                                                     reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

                    view.clusteringIdentifier = String(describing: MKMarkerAnnotationView.self)
                    view.canShowCallout = true
                    view.glyphText = "⛳️"
                    //                    view.glyphImage = annotation.image.asUIImage
                    view.markerTintColor = .systemPink
                    view.titleVisibility = .visible
                    //            annotationView.selectedGlyphImage = annotation.image.asUIImage
                    //            annotationView.detailCalloutAccessoryView = UIImageView(image: mapPlace.image.asUIImage)
                    return view

                default:
                    return nil
            }
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            guard nil != context.region else { return }
            Task { @MainActor in
                context.region = mapView.region
            }
        }

        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            switch annotation {
                case is MKUserLocation:
                    context.state = .currentNew

                case is MKClusterAnnotation:
                    return

                case let annotation as Annotation:
                    return

                default:
                    return
            }
        }

        func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            context.state = nil
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("MKAnnotationView")
        }
    }
}

private extension MapView.Coordinator {
    func reuseMKAnnotationView(mapView: MKMapView,
                               viewFor annotation: MKAnnotation,
                               reuseIdentifier: String) -> MKMarkerAnnotationView {
        mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView
        ?? .init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}
