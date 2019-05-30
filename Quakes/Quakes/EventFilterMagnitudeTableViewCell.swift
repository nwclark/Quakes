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

class EventFilterMagnitudeTableViewCell: UITableViewCell, EventFilterTableViewCell {

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

    // ----------------------------------------------------------------------
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // ----------------------------------------------------------------------
    // MARK: - IBActions
    @IBAction func minimumStepperValueChanged(_ sender: Any) {
        print("minimum value: \(self.minimumStepper.value)")
    }

    @IBAction func maximumStepperValueChanged(_ sender: Any) {
        print("maximum value: \(self.maximumStepper.value)")
    }


    // ----------------------------------------------------------------------
    // MARK: - EventFilterTableViewCell Compliance

    static var sectionTitle: String { return "Magnitude" }
    static var cellHeight: CGFloat { return 100 }
    static var identifier: String { return "EventFilterMagnitudeTableViewCell" }
}
