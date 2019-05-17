//
//  EventPopoverViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/16/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import UIKit

class EventPopoverViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.closeButton.addTarget(self, action: #selector(EventPopoverViewController.closeButtonPressed), for: .touchDown)

        // Do any additional setup after loading the view.
    }

    fileprivate var _event: MapViewModelController.SeismicEvent?
    var event: MapViewModelController.SeismicEvent? {
        get {
            return _event
        }

        set {
            self._event = newValue
            self.typeLabel.text = newValue?.type?.text
            self.summaryLabel.text = newValue?.title
            if let magnitude = newValue?.magnitude {
                self.magnitudeLabel.text = String(magnitude)
            } else {
                self.magnitudeLabel.text = nil
            }
            self.placeLabel.text = newValue?.place
        }
    }

    @objc func closeButtonPressed() {
        print("close me")
        self.dismiss(animated: true)
    }



}
