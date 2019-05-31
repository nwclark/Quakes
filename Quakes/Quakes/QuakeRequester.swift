//
//  QuakeRequester.swift
//  Quakes
//
//  Created by Nathan Clark on 5/14/19.
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

/// Queries the USGS webservice for FDSN earthquake information.
/// Docs: https://earthquake.usgs.gov/fdsnws/event/1/
class QuakeRequester {

    /// Earthquake webservice API endpoint
    fileprivate let queryEndpoint = "https://earthquake.usgs.gov/fdsnws/event/1/query"

    /// Common parameters always included in query requests.
    fileprivate let baseQueryItems = [URLQueryItem(name: "format", value: "geojson")]

    fileprivate let defaultSession = URLSession(configuration: .default)

    fileprivate let secondsInADay: TimeInterval = 24 * 60 * 60

    /// Formats dates to ISO8601 specs required by webservice.
    fileprivate let dateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()

    /// Request quakes for the past 24 hours.
    ///
    /// - Parameters:
    ///     - completion: completion handler
    ///     - response: response object from webservice
    ///     - error: errors encountered while processing request
    func getLastDaysEvents(_ completion: @escaping (_ response: QueryResponse?, _ error: Error?) -> Void) {
        var queryParams = baseQueryItems

        queryParams += self.buildQueryParams()

        var urlComponents = URLComponents(string: queryEndpoint)
        urlComponents?.queryItems = queryParams

        guard let url = urlComponents?.url else {
            fatalError("request URL not generated")
        }

        let dataTask: URLSessionDataTask = self.defaultSession.dataTask(with: url) {
            data, response, error in

            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(QueryResponse.self, from: data)
                    completion(product, nil)
                    return
                } catch let err {
                    completion(nil, err)
                    return
                }
            }
        }
        dataTask.resume()
    }

    // ----------------------------------------------------------------------
    // MARK: - Building Query Parameters

    /// Creates request params from `EventFilter`
    ///
    /// - Returns: An array of `URLQueryItem`s
    fileprivate func buildQueryParams() -> [URLQueryItem] {
        return self.buildDateQueryParams() + self.buildMagnitudeQueryParms() + self.buildEventQueryParams()
    }

    fileprivate func buildDateQueryParams() -> [URLQueryItem]  {
        let endtime = Date()
        let starttime = endtime - secondsInADay

        let startParam = URLQueryItem(name: "starttime", value: dateFormatter.string(from: starttime))
        let endParam = URLQueryItem(name: "endtime", value: dateFormatter.string(from:endtime))
        return [startParam, endParam]
    }

    fileprivate func buildMagnitudeQueryParms() -> [URLQueryItem] {
        let minimumMagnitude = EventFilter.shared().userMinimumMaginitude
        let maximumMagnitude = EventFilter.shared().userMaximumMagnitude
        let minQueryParam = URLQueryItem(name: "minmagnitude", value: String(minimumMagnitude))
        let maxQueryParam = URLQueryItem(name: "maxmagnitude", value: String(maximumMagnitude))
        return [minQueryParam, maxQueryParam]
    }

    fileprivate func buildEventQueryParams() -> [URLQueryItem] {
        let userEvents = EventFilter.shared().userEvents
        let eventString = userEvents.map {
            (event) -> String in
            event.queryParamString
        }.joined(separator: ",")

        let eventQueryParam = URLQueryItem(name: "eventtype", value: eventString)
        return [eventQueryParam]
    }
}

// ----------------------------------------------------------------------
// MARK: - JSON Response Objects

extension QuakeRequester {
    /// Datastructure matching a query json response object from the server.
    /// "type": "FeatureCollection
    struct QueryResponse : Codable {
        let type: String?
        let metadata: QueryResponseMetadata?
        let features: [QueryResponseFeature]?
        let bbox: [Double]?
    }

    /// Type matching the `metadata` json object in query responses.
    struct QueryResponseMetadata : Codable {
        let generated: Int?
        let url: String?
        let title: String?
        let status: Int?
        let api: String?
        let count: Int?
    }

    /// Datastructure matching "type": "Feature" json response object.
    struct QueryResponseFeature : Codable {
        let type: String?
        let properties: QueryResponseFeatureProperties?
        let geometry: QueryResponseFeatureGeometry?
        let id: String?
    }

    /// Datastructure matching "Feature" properties json response object.
    struct QueryResponseFeatureProperties : Codable {
        let mag: Double?
        let place: String?
        /// Timestamp in milliseconds since 1970 epoch.
        let time: Int?
        let updated: Int?
        let tz: Int?
        let url: String?
        let detail : String?
        let felt: Int?
        let cdi: Double?
        let mmi: Double?
        let alert: String?
        let status: String?
        let tsunami: Int?
        let sig: Int?
        let net: String?
        let code: String?
        let ids: String?
        let sources: String?
        let types: String?
        let nst: Int?
        let dmin: Double?
        let rms: Double?
        let gap: Double?
        let magType: String?
        let type: String?
        let title: String?
    }

    /// Datastructure meatching "geometry" json response object.
    struct QueryResponseFeatureGeometry : Codable {
        let type: String?
        let coordinates: [Double]?
    }
}
