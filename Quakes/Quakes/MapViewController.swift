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

    lazy var modelController = MapViewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()


        modelController.getLatestEvents { (events, error) in
            events?.event?.forEach{ event in print(event) }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
