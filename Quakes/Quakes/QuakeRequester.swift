//
//  QuakeRequester.swift
//  Quakes
//
//  Created by Nathan Clark on 5/14/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//

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

        let endtime = Date()
        let starttime = endtime - secondsInADay

        queryParams.append(URLQueryItem(name: "starttime", value: dateFormatter.string(from: starttime)))
        queryParams.append(URLQueryItem(name: "endtime", value: dateFormatter.string(from:endtime)))

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
