//
//  EventPopoverViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/16/19.
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
    fileprivate var _event: SeismicEvent?

    /// `SeismicEvent` containing information for the popover.
    /// Setting this value has the effect of updating the display.
    var event: SeismicEvent? {
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
                let depthString = depthFormatter.string(for: depth)
                self.depthLabel.text = depthString! + " km"
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

    /// Applies formatting to the displayed latitude and longitude values.
    fileprivate var locationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 4
        return formatter
    } ()

    /// Applies formatting for the displayed event time.
    fileprivate var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    } ()

    /// Applies formatting for the displayed event depth.
    fileprivate var depthFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 1
        return formatter
    } ()
}
