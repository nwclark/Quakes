//
//  EventFilterMagnitudeTableViewCell.swift
//  Quakes
//
//  Created by Nathan Clark on 5/29/19.
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

class EventFilterMagnitudeTableViewCell: UITableViewCell {

    // ----------------------------------------------------------------------
    // MARK: - IBOutlets

    /// UIControl displaying the current minimum magnitude value.
    @IBOutlet weak var minimumValueLabel: UILabel!

    /// UIControl displaying the current maximum magnitude value.
    @IBOutlet weak var maximumValueLabel: UILabel!

    /// UIControl for changing the minimum magnitude value.
    @IBOutlet weak var minimumStepper: UIStepper!

    /// UIControl for changing the maximum magnitude value.
    @IBOutlet weak var maximumStepper: UIStepper!

    /// The view controller managing this cell.
    weak fileprivate var eventTableViewModelController: EventFilterTableViewModelController?

    // ----------------------------------------------------------------------
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    fileprivate func initializeUI() {
        guard let modelController = self.eventTableViewModelController else {
            fatalError("EventTableViewModelController not connected")
        }

        let minimumMagnitude = modelController.userMinimumMagnitude
        let maximumMagnitude = modelController.userMaximumMagnitude

        // Minimum magnitude init.
        self.minimumValueLabel.text      = String(minimumMagnitude)
        self.minimumStepper.value        = minimumMagnitude
        self.minimumStepper.maximumValue = maximumMagnitude
        self.minimumStepper.minimumValue = modelController.minimumAllowableMagnitude
        self.minimumStepper.stepValue    = 1.0

        // Maximum magnitude init.
        self.maximumValueLabel.text      = String(maximumMagnitude)
        self.maximumStepper.value        = maximumMagnitude
        self.maximumStepper.minimumValue = self.minimumStepper.value
        self.maximumStepper.maximumValue = modelController.maximumAllowableMagnitude
        self.maximumStepper.stepValue    = 1.0
    }

    // ----------------------------------------------------------------------
    // MARK: - IBActions

    @IBAction func minimumStepperValueChanged(_ sender: Any) {
        guard let modelController = self.eventTableViewModelController else {
            fatalError("EventTableViewModelController not connected")
        }

        var newValue = self.minimumStepper.value
        print ("newValue: \(newValue)")
        if newValue >= self.maximumStepper.value {
            newValue = self.maximumStepper.value - 1.0
            self.minimumStepper.value = newValue
            print("Changed newValue to \(newValue)")
        }

        self.minimumValueLabel.text = String(newValue)
        modelController.userMinimumMagnitude = newValue
        self.maximumStepper.minimumValue = newValue
    }

    @IBAction func maximumStepperValueChanged(_ sender: Any) {
        guard let modelController = self.eventTableViewModelController else {
            fatalError("EventTableViewModelController not connected")
        }
        var newValue = self.maximumStepper.value
        print("newValue: \(newValue)")
        if newValue <= self.minimumStepper.value {
            newValue = self.minimumStepper.value + 1.0
            self.maximumStepper.value = newValue
            print("Changed newValue to \(newValue)")
        }

        self.maximumValueLabel.text = String(newValue)
        modelController.userMaximumMagnitude = newValue
        self.minimumStepper.maximumValue = newValue
    }


    // ----------------------------------------------------------------------
    // MARK: - EventFilterTableViewCell Compliance
}

extension EventFilterMagnitudeTableViewCell: EventFilterTableViewCell {
    func connect(with eventTableViewModelController: EventFilterTableViewModelController) {
        self.eventTableViewModelController = eventTableViewModelController
        self.initializeUI()
    }

    static var sectionTitle: String { return "Magnitude" }
    static var cellHeight: CGFloat { return 100 }
    static var identifier: String { return "EventFilterMagnitudeTableViewCell" }
}
