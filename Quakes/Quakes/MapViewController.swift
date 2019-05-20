//
//  MapViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/15/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    /// Model controller associated with this view.
    lazy var modelController = MapViewModelController()

    /// Preferred content size for event popovers on the map.
    fileprivate static let eventPopoverContentSize = CGSize(width: 350, height: 200)

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

    /// Displays a popover with event details when a user selects an event.
    /// - Parameters:
    ///   - mapView: map view containing the annotation
    ///   - view: view that was selected by the user
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /// Deselect the annotation and show the popover with details.
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if let event = view.annotation as? MapViewModelController.SeismicEvent {
            let eventPopoverVC = EventPopoverViewController()
            eventPopoverVC.preferredContentSize = MapViewController.eventPopoverContentSize
            eventPopoverVC.modalPresentationStyle = .popover
            if let presentationController = eventPopoverVC.presentationController {
                presentationController.delegate = self
            }
            self.present(eventPopoverVC, animated: true)
            if let popoverPresentationController = eventPopoverVC.popoverPresentationController {
                popoverPresentationController.sourceView = view
                popoverPresentationController.sourceRect = view.bounds
            }
            eventPopoverVC.event = event
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

    }


    /// Returns the `MKAnnotationView` used to represent the event on the map.
    ///
    /// - Parameters:
    ///   - mapView: map view containing the annotation marker
    ///   - annotation: Event the view should represent.
    /// - Returns: The `MKAnnotationView` that should be placed on the map.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "EventAnnotation"
        if let event = annotation as? MapViewModelController.SeismicEvent {

            let annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            let markerImage = event.mapMarkerImage
            annotationView.image = markerImage
            annotationView.annotation = annotation
            return annotationView
        }
        return nil
    }
}

// ----------------------------------------------------------------------
// MARK: - UIPopoverPresentationControllerDelegate

extension MapViewController : UIPopoverPresentationControllerDelegate {

    /// By returning `.none`, forces popover to always be a popover, even on an iPhone.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
