//
//  MapViewModelController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/15/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModelController {

    lazy var quakeRequester: QuakeRequester = QuakeRequester()

    /// Fetches all seismic events from the past 24 hours.
    ///
    /// - Parameters:
    ///    - completion: Completion handler executed asynchronously with results/
    ///    - events: List of seismic events
    ///    - error: Errors, if any, from processing request.
    func getLatestEvents(_ completion: @escaping (_ events: EventList?, _ error: Error?) -> Void) {
        quakeRequester.getLastDaysEvents {
            response, error in
            var completionResponse: EventList?

            if let response = response {
                completionResponse = EventList(queryResponse: response)
            }

            completion(completionResponse, error)
        }
    }
}

extension MapViewModelController {

    /// Contains a list of `SeismicEvents` retrieved from the webservice.
    class EventList {
        let event: [SeismicEvent]?
        let generated: Date?
        let boundingBox: [Double]? = nil

        init(queryResponse query: QuakeRequester.QueryResponse) {
            generated = Date(timeIntervalSince1970: TimeInterval(query.metadata?.generated ?? 0))
            event = query.features?.map{ event in SeismicEvent(queryResponseFeature: event) }
        }
    }


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
            time = Date(timeIntervalSince1970: TimeInterval(feature.properties?.time ?? 0))
            updated = Date(timeIntervalSince1970: TimeInterval(feature.properties?.time ?? 0))
            timezone = TimeZone(secondsFromGMT: feature.properties?.tz ?? 0)
            type = EventType.decode(string: feature.properties?.type)
            title = feature.properties?.title
            location = EventLocation(queryResponseFeature: feature)
        }

        // ----------------------------------------------------------------------
        // MARK: - CustomStringConvertable
        override var description: String {
            let descPlace = place ?? "Unknown"
            let descMag = magnitude ?? 0.0
            return "\(descMag): \(descPlace)"
        }

        // ----------------------------------------------------------------------
        // MARK: - MKAnnotation
        var coordinate: CLLocationCoordinate2D {
            return location?.coordinate ?? kCLLocationCoordinate2DInvalid
        }

        var subtitle: String? {
            let subtitle = type?.description ?? "Unknown"
            return subtitle
        }
    }

    struct EventLocation {
        let coordinate: CLLocationCoordinate2D
        let depth: CLLocationDistance

        init (queryResponseFeature feature: QuakeRequester.QueryResponseFeature) {
            coordinate = CLLocationCoordinate2D(latitude: feature.geometry?.coordinates?[1] ?? 0,
                                                longitude: feature.geometry?.coordinates?[0] ?? 0)
            depth = feature.geometry?.coordinates?[2] ?? 0
        }
    }

    enum EventType : CustomStringConvertible {
        case earthquake


        /// Translates the event type from strings returned by the webservice to
        /// an `EventType`.
        ///
        /// - Parameter string: String to decode
        /// - Returns: Equivalent `EventType`.
        static func decode(string: String?) -> EventType? {
            return .earthquake
        }

        var description: String {
            switch self {
            case .earthquake:
                return "Earthquake"
             }
        }
    }
}
