//
//  EventFilter.swift
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

import Foundation


/// A singleton object managing the user's event filter settings.
/// The shared instance should be accessed through the `shared()` method.
class EventFilter {

    // ----------------------------------------------------------------------
    // MARK: - Private Members

    private static let instance: EventFilter = {
        let eventFilter = EventFilter()
        return eventFilter
    } ()

    /// `UserDefaults` key for `userMinimumMagnitude`.
    private static let userMinimumMagnitudeKey = "userMinimumMagnitude"

    /// `UserDefaults` key for `userMaximumMagnitudeKey`.
    private static let userMaximumMagnitudeKey = "userMaximumMagnitude"

    /// Default minimum magnitude to use if none is set in `UserDefaults`.
    private static let defaultUserMinimumMagnitude: Double = 4.0

    /// Default maximum magnitude to use if none is set in `UserDefaults`.
    private static let defaultUserMaximumMagnitude: Double = 10.0

    /// Hide init from outsiders.
    private init () { }

    // ----------------------------------------------------------------------
    // MARK: - Public Interface

    /// Upper magnitude bounds.
    /// - TODO: Both `maximumAllowableMagnitude` and `minimumAllowableMagnitude` are being enforced
    ///       outside `EventManager`. This should be fixed.
    static let maximumAllowableMagnitude: Double = 10.0

    /// Lower magnitude bounds.
    /// - TODO: Both `maximumAllowableMagnitude` and `minimumAllowableMagnitude` are being enforced
    ///       outside `EventManager`. This should be fixed.
    static let minimumAllowableMagnitude : Double = 0.0

    /// User-selected minimum magnitude.
    var userMinimumMaginitude: Double {
        get {
            return UserDefaults.standard.object(forKey: EventFilter.userMinimumMagnitudeKey) as? Double ?? EventFilter.defaultUserMinimumMagnitude
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userMinimumMagnitudeKey)
        }
    }

    /// User-selected maximum magnitude
    var userMaximumMagnitude: Double {
        get {
            return UserDefaults.standard.object(forKey: EventFilter.userMaximumMagnitudeKey) as? Double ?? EventFilter.defaultUserMaximumMagnitude
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userMaximumMagnitudeKey)
        }
    }

    /// Allows access to the shared `EventFilter` instance.
    /// - Returns: The singleton instance of `EventFilter`.
    class func shared() -> EventFilter {
        return instance
    }

    /// Determines whether the `magnitude` of a `SeismicEvent` should be included based on the
    /// current filter settings.
    ///
    /// - Parameter seismicEvent: The event to test.
    /// - Returns: `true` if the event should be included, `false` if not.
    func isIncluded(seismicEvent: MapViewModelController.SeismicEvent) -> Bool {
        guard let magnitude = seismicEvent.magnitude else {
            return false
        }

        if magnitude <= userMaximumMagnitude && magnitude >= userMinimumMaginitude {
            return true
        }

        return false
    }
}
