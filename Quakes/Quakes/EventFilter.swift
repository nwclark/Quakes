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

    /// `UserDefaults` key for `userEvents`.
    private static let userEventsKey = "userEventsKey"

    /// Default events to include in queries.
    private static let defaultUserEvents: [EventType] = [.earthquake, .iceQuake, .quaryBlast,
                                                         .landslide, .rockSlide, .snowAvalanche]

    /// `UserDefaults` key for `userStartTime`.
    private static let userStartTimeKey = "userStartTime"

    /// `UserDefaults` key for `userEndTime`.
    private static let userEndTimeKey = "userEndTime"

    /// `UserDefaults` key for `userDateRange`.
    private static let userDateRangeKey = "userDatesRange"

    private static let userDefaultDateRange = false

    private static let secondsInADay: TimeInterval = 24 * 60 * 60

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

    /// User-selected maximum magnitude.
    var userMaximumMagnitude: Double {
        get {
            return UserDefaults.standard.object(forKey: EventFilter.userMaximumMagnitudeKey) as? Double ?? EventFilter.defaultUserMaximumMagnitude
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userMaximumMagnitudeKey)
        }
    }

    /// User-selected events to include in query.
    var userEvents: [EventType] {
        get {
            guard let asData = UserDefaults.standard.object(forKey: EventFilter.userEventsKey) as? [EventType.RawValue]  else {
                return EventFilter.defaultUserEvents
            }

            let asEventTypes = asData.map { EventType(rawValue: $0)! }
            return asEventTypes
        }
        set {
            let asData = newValue.map { $0.rawValue }
            UserDefaults.standard.set(asData, forKey: EventFilter.userEventsKey)
        }
    }

    /// When set to `false`, the date range will be automatically generated to include the last 24 hours.
    /// When set to `true`, the dates stored in `UserDefaults` will be used.
    var userDateRange: Bool {
        get {
            return UserDefaults.standard.object(forKey: EventFilter.userDateRangeKey) as? Bool ?? EventFilter.userDefaultDateRange
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userDateRangeKey)
        }
    }

    /// User-selected search start time.
    var userStartTime: Date {
        get {
            if self.userDateRange == true {
                return UserDefaults.standard.object(forKey: EventFilter.userStartTimeKey) as? Date ?? Date() - EventFilter.secondsInADay
            } else {
                return Date() - EventFilter.secondsInADay
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userStartTimeKey)
        }
    }

    /// User-selected search end time.
    var userEndTime: Date {
        get {
            if self.userDateRange == true {
                return UserDefaults.standard.object(forKey: EventFilter.userEndTimeKey) as? Date ?? Date()
            } else {
                return Date()
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EventFilter.userEndTimeKey)
        }
    }

    /// Allows access to the shared `EventFilter` instance.
    /// - Returns: The singleton instance of `EventFilter`.
    class func shared() -> EventFilter {
        return instance
    }
}
