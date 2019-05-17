//
//  MapViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/15/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    /// Model controller associated with this view.
    lazy var modelController = MapViewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMapView()
        getEvents()
    }
    
    /// Sets the mapView properties to desired initial
    fileprivate func initializeMapView() {
        self.mapView.delegate = self
    }

    /// Fetch events from the webservice and display on map.
    fileprivate func getEvents() {
        modelController.getLatestEvents {
            (events, error) in
            if let quakes = events?.event {
                print("Adding \(quakes.count) events")
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(quakes)
                }
            }
        }
    }
}

// ----------------------------------------------------------------------
// MARK: - MKMapViewDelegate Support

    extension MapViewController: MKMapViewDelegate {

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            view.setSelected(false, animated: true)
            if let event = view.annotation as? MapViewModelController.SeismicEvent {
                let eventPopupVC = EventPopoverViewController()
                self.present(eventPopupVC, animated: true)
                eventPopupVC.event = event
            }
        }

        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseIdentifier = "EventAnnotation"
            if let event = annotation as? MapViewModelController.SeismicEvent {

                let annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)

                annotationView.markerTintColor = event.type?.markerTintColor
                return annotationView
            }
            return nil
        }
}
