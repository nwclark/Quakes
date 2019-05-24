//
//  EventFilterViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/22/19.
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

class EventFilterViewController: UIViewController {

    // ----------------------------------------------------------------------
    // MARK: - IBOutlets

    @IBOutlet weak var magMinStepper: UIStepper!
    @IBOutlet weak var magMinDisplay: UILabel!
    @IBOutlet weak var magMaxStepper: UIStepper!
    @IBOutlet weak var magMaxDisplay: UILabel!

    // ----------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeMagnitudeFilterUI()
        self.initializeNavBar()
    }

    /// Adds this view's custom items to the nav bar.
    fileprivate func initializeNavBar() {
        let applyButton = UIBarButtonItem(title: "Apply", style: .plain, target: self,
                                          action: #selector(EventFilterViewController.saveAndExit))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(EventFilterViewController.popToRoot))
        self.navigationItem.leftBarButtonItem = applyButton
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationItem.title = "Filters"
    }
    
    /// Updates the UI to display values stored by the event filter.
    fileprivate func initializeMagnitudeFilterUI() {
        self.magMinDisplay.text = String(EventFilter.shared().minimumMaginitude)
        self.magMaxDisplay.text = String(EventFilter.shared().maximumMagnitude)
    }

    /// Saves changes to `EventFilter` and exits.
    @objc fileprivate func saveAndExit() {
        // TODO: Write vals to EventFilter
        self.popToRoot()
    }

    /// Returns to the root view controller without saving changes.
    @objc fileprivate func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
