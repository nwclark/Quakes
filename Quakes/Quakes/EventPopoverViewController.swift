//
//  EventPopoverViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/16/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import UIKit

class EventPopoverViewController: UIViewController {

    // ----------------------------------------------------------------------
    // MARK: - IBOutlets

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    // ----------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



    /// Backing store for the `event` property.
    fileprivate var _event: MapViewModelController.SeismicEvent?

    /// `SeismicEvent` containing information for the popover.
    /// Setting this value has the effect of updating the display.
    var event: MapViewModelController.SeismicEvent? {
        get {
            return _event
        }

        set {
            self._event = newValue
            self.typeLabel.text = newValue?.type?.userText
            self.placeLabel.text = newValue?.place

            if let magnitude = newValue?.magnitude {
                self.magnitudeLabel.text = magnitudeFormatter.string(for: magnitude)
            } else {
                self.magnitudeLabel.text = nil
            }

            if let depth = newValue?.location?.depth {
                let depthString = locationFormatter.string(for: depth)
                self.depthLabel.text = depthString! + " m"
            } else {
                self.depthLabel.text = nil
            }

            if let lat = newValue?.location?.coordinate.latitude,
                let long = newValue?.location?.coordinate.longitude {
                let latString = locationFormatter.string(for: lat)
                let longString = locationFormatter.string(for: long)
                self.coordinateLabel.text = "(" + latString! + ", " + longString! + ")"
            }

            if let date = newValue?.time {
                self.timestampLabel.text = dateFormatter.string(from: date)
            } else {
                self.timestampLabel.text = nil
            }
        }
    }


    /// Applies formatting to the displayed magnitude values.
    fileprivate var magnitudeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 3
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        return formatter
    } ()

    /// Applies formatting to the displayed latitude, longitude, and depth values.
    fileprivate var locationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 4
        return formatter
    } ()

    fileprivate var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    } ()
}
