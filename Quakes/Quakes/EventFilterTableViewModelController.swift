//
//  EventFilterTableViewModelController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/30/19.
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

class EventFilterTableViewModelController {

    /// Upper magnitude limit for user filters.
    let maximumAllowableMagnitude = EventFilter.maximumAllowableMagnitude

    /// User-selected minimum magnitude.
    var userMinimumMagnitude = EventFilter.shared().userMinimumMaginitude

    /// Lower magnitude limit for user filters.
    let minimumAllowableMagnitude = EventFilter.minimumAllowableMagnitude

    /// User-selected maximum magnitude.
    var userMaximumMagnitude = EventFilter.shared().userMaximumMagnitude

    /// User-selected event types.
    var userEventTypes: [EventType] = EventFilter.shared().userEvents

    /// All event types available for filtering.
    let allEventTypes: [EventType] = EventType.allCases

    /// Write the current settings to the `EventFilter`.
    func saveChanges() {
        EventFilter.shared().userMaximumMagnitude = userMaximumMagnitude
        EventFilter.shared().userMinimumMaginitude = userMinimumMagnitude
        EventFilter.shared().userEvents = userEventTypes
    }

}
