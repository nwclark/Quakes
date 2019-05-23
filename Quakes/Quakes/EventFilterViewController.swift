//
//  EventFilterViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/22/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import UIKit

class EventFilterViewController: UIViewController {

    // ----------------------------------------------------------------------
    // MARK: - 

    @IBOutlet weak var magMinStepper: UIStepper!
    @IBOutlet weak var magMinDisplay: UILabel!
    @IBOutlet weak var magMaxStepper: UIStepper!
    @IBOutlet weak var magMaxDisplay: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayFilterValues()
    }


    /// Updates the UI to display values stored by the event filter.
    fileprivate func displayFilterValues() {
        self.magMinDisplay.text = String(EventFilter.shared().minimumMaginitude)
        self.magMaxDisplay.text = String(EventFilter.shared().maximumMagnitude)
    }

}
