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

}
