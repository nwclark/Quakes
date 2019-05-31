//
//  EventFilterTypeTableViewCell.swift
//  Quakes
//
//  Created by Nathan Clark on 5/31/19.
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

import Foundation
import UIKit

class EventFilterTypeTableViewCell: UITableViewCell {

    // ----------------------------------------------------------------------
    // MARK: - IBOutlets

    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventTypeSwitch: UISwitch!

    /// The view controller managing this cell.
    weak fileprivate var eventTableViewModelController: EventFilterTableViewModelController?

    /// Event type represented by this cell.
    fileprivate var event: EventType?

    // ----------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    fileprivate func initializeUI() {
        guard let model = self.eventTableViewModelController else {
            fatalError("Cell must be connected to an EventTableViewModelController")
        }

        guard let event = self.event else {
            fatalError("Expected event to be set")
        }

        self.eventTypeLabel.text = event.userText
        self.eventTypeSwitch.isOn = model.userEventTypes.contains(event)
        self.eventTypeSwitch.onTintColor = event.markerTintColor
     }

    @IBAction func switchValueChanged(_ sender: Any) {
        guard let model = self.eventTableViewModelController else {
            fatalError("Cell must be connected to an EventTableViewModelController")
        }

        guard let event = self.event else {
            fatalError("Expected event to be set")
        }

        if let toggle = sender as? UISwitch {
            if toggle.isOn == true {
                if model.userEventTypes.contains(event) == false {
                    model.userEventTypes.append(event)
                }
            } else { // Toggle is off.
                if model.userEventTypes.contains(event) == true {
                    model.userEventTypes = model.userEventTypes.filter{ $0 != event }
                }
            }
        }
    }
}

// ----------------------------------------------------------------------
// MARK: - EventFilterTableViewCell Compliance

extension EventFilterTypeTableViewCell: EventFilterTableViewCell {
    func connect(with eventTableViewModelController: EventFilterTableViewModelController, for indexPath: IndexPath) {
        self.eventTableViewModelController = eventTableViewModelController
        self.event = eventTableViewModelController.allEventTypes[indexPath.row]
        self.initializeUI()
    }

    static var sectionTitle: String { return "Event Type" }
    static var cellHeight: CGFloat  { return 42 }
    static var identifier: String   { return "EventFilterTypeTableViewCell" }
}
