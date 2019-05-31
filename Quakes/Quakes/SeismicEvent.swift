//
//  SeismicEvent.swift
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
import MapKit

/// A seismic event detected by the FDSN and retrieved from the webservice.,
class SeismicEvent : NSObject, MKAnnotation {
    let magnitude: Double?
    let place: String?
    let time: Date?
    let updated: Date?
    let timezone: TimeZone?
    let type: EventType?
    let title: String?
    let location: EventLocation?

    init(queryResponseFeature feature: QuakeRequester.QueryResponseFeature) {
        magnitude = feature.properties?.mag
        place = feature.properties?.place
        type = EventType.decode(string: feature.properties?.type)
        title = feature.properties?.title
        location = EventLocation(queryResponseFeature: feature)

        if let timestamp = feature.properties?.time {
            time = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0) // time is milliseconds, convert to seconds for Date
        } else {
            time = nil
        }

        if let updatedTime = feature.properties?.updated {
            updated = Date(timeIntervalSince1970: TimeInterval(updatedTime) / 1000.0)
        } else {
            updated = nil
        }

        if let tz = feature.properties?.tz {
            timezone = TimeZone(secondsFromGMT: tz)
        } else {
            timezone = nil
        }
    }

    /// Returns an image to be used as a map marker. Image size
    /// depends on the event's magitude, while the color denotes
    /// the event type.
    var mapMarkerImage: UIImage? {
        let diameter = self.mapMarkerSize
        let size = CGSize(width: diameter, height: diameter)
        let scale: CGFloat = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        let rect = CGRect(origin: .zero, size: size)
        let color = self.type?.markerTintColor.cgColor ?? UIColor.black.cgColor
        ctx?.setFillColor(color)
        ctx?.fillEllipse(in: rect)
        ctx?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    /// Calculates the map marker size from the event magnitude.
    fileprivate var mapMarkerSize: CGFloat {
        let baseMarkerSize = 5.0
        guard let mag = self.magnitude else {
            return CGFloat(baseMarkerSize)
        }
        return CGFloat(abs(mag) * baseMarkerSize)
    }

    // ----------------------------------------------------------------------
    // MARK: - CustomStringConvertable
    override var description: String {
        let descPlace = place ?? "Unknown"
        let descMag = magnitude ?? 0.0
        return "\(descMag): \(descPlace)"
    }

    // ----------------------------------------------------------------------
    // MARK: - MKAnnotation Conformance

    /// Coordinate property required by `MKAnnotation`.
    var coordinate: CLLocationCoordinate2D {
        return location?.coordinate ?? kCLLocationCoordinate2DInvalid
    }

    /// Subtitle property for `MKAnnotation`.
    var subtitle: String? {
        let subtitle = type?.userText ?? "Unknown"
        return subtitle
    }
}
