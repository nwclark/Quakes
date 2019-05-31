//
//  EventType.swift
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

/// Event type assigned by FDSN.
///
/// - acousticNoise:
/// - anthropogenicEvent:
/// - buildingCollapse:
/// - chemicalExplosion:
/// - collapse:
/// - earthquake:
/// - experimentalExplosion:
/// - explosion:
/// - iceQuake:
/// - inducedEvent:
/// - landslide:
/// - meteor:
/// - meteorite:
/// - mineCollapse:
/// - mineExplosion:
/// - notReported:
/// - nuclearExplosion:
/// - other:
/// - quaryBlast:
/// - rockBurst:
/// - rockSlide:
/// - snowAvalanche:
/// - sonicBoom:
/// - unknown:
/// - volcanicEruption:
/// - volcanicExplosion:
/// - earthquake:
enum EventType : CustomStringConvertible {
    case acousticNoise
    case anthropogenicEvent
    case buildingCollapse
    case chemicalExplosion
    case collapse
    case earthquake
    case experimentalExplosion
    case explosion
    case iceQuake
    case inducedEvent
    case landslide
    case meteor
    case meteorite
    case mineCollapse
    case mineExplosion
    case notReported
    case nuclearExplosion
    case other
    case quaryBlast
    case rockBurst
    case rockSlide
    case snowAvalanche
    case sonicBoom
    case unknown
    case volcanicEruption
    case volcanicExplosion


    /// Translates the event type from strings returned by the webservice to
    /// an `EventType`.
    ///
    /// - Parameter string: String to decode
    /// - Returns: Equivalent `EventType`.
    static func decode(string: String?) -> EventType? {
        guard let eventString = string else {
            return .unknown
        }

        switch eventString {
        case "acoustic noise",
             "acoustic_noise":
            return .acousticNoise

        case "anthropogenic_event":
            return .anthropogenicEvent

        case "building collapse":
            return .buildingCollapse

        case "chemical explosion",
             "chemical_explosion":
            return .chemicalExplosion

        case "collapse":
            return .collapse

        case "earthquake",
             "eq":
            return .earthquake

        case "experimental explosion":
            return .experimentalExplosion

        case "explosion":
            return .explosion

        case "ice quake":
            return .iceQuake

        case "induced or triggered event":
            return .inducedEvent

        case "landslide":
            return .landslide

        case "meteor":
            return .meteor

        case "meteorite":
            return .meteorite

        case "mine collapse",
             "mine_collapse":
            return .mineCollapse

        case "mining_explosion",
             "mining explosion":
            return .mineExplosion

        case "not reported",
             "not_reported":
            return .notReported

        case "nuclear explosion",
             "nuclear_explosion":
            return .nuclearExplosion

        case "other event",
             "other_event":
            return .other

        case "quarry",
             "quarry blast",
             "quarry_blast":
            return .quaryBlast

        case "rock burst",
             "rock_burst":
            return .rockBurst

        case "Rock Slide",
             "rock_slide":
            return .rockSlide

        case "snow_avalanche":
            return .snowAvalanche

        case "sonic boom",
             "sonic_boom",
             "sonicboom":
            return .sonicBoom

        case "volcanic erruption":
            return .volcanicEruption

        case "volcanic explosion":
            return .volcanicExplosion

        default:
            return .unknown
        }
    }

    /// A developmental descriptive string, usually used in debugging.
    var description: String {
        return self.userText
    }

    /// A display-ready descriptive string, meant to be displayed to the user.
    var userText: String {
        switch self {
        case .earthquake:
            return "Earthquake"
        case .acousticNoise:
            return "Acoustic Noise"
        case .anthropogenicEvent:
            return "Anthropologic Event"
        case .buildingCollapse:
            return "Building Collapse"
        case .chemicalExplosion:
            return "Chemical Explosion"
        case .collapse:
            return "Collapse"
        case .experimentalExplosion:
            return "Experimental Explosion"
        case .explosion:
            return "Explosion"
        case .iceQuake:
            return "Ice Quake"
        case .inducedEvent:
            return "Induced Event"
        case .landslide:
            return "Landslide"
        case .meteor:
            return "Meteor"
        case .meteorite:
            return "Meterorite"
        case .mineCollapse:
            return "Mine Collapse"
        case .mineExplosion:
            return "Mine Explosion"
        case .notReported:
            return "Not Reported"
        case .nuclearExplosion:
            return "Nuclear Explosion"
        case .other:
            return "Other"
        case .quaryBlast:
            return "Quarry Blast"
        case .rockBurst:
            return "Rock Burst"
        case .rockSlide:
            return "Rock Slide"
        case .snowAvalanche:
            return "Snow Avalanche"
        case .sonicBoom:
            return "Sonic Boom"
        case .unknown:
            return "Unknown"
        case .volcanicEruption:
            return "Volcanic Eruption"
        case .volcanicExplosion:
            return "Volcanic Explosion"
        }
    }

    /// Background color of the Map View marker.
    var markerTintColor: UIColor {
        switch self {

        case .acousticNoise:
            return UIColor.init(red: 25/255, green: 195/255, blue: 237/255, alpha: 1.0)
        case .anthropogenicEvent:
            return UIColor.gray
        case .buildingCollapse, .chemicalExplosion, .collapse, .inducedEvent:
            return UIColor.cyan
        case .earthquake:
            return UIColor.init(red: 251/255, green: 127/255, blue: 6/255, alpha: 1.0)
        case .experimentalExplosion:
            return UIColor.darkGray
        case .explosion:
            return UIColor.red
        case .iceQuake:
            return UIColor.init(red: 255/255, green: 214/255, blue: 174/255, alpha: 1.0)
        case .landslide:
            return UIColor.brown
        case .meteor, .meteorite, .mineCollapse, .mineExplosion,
             .notReported, .nuclearExplosion, .other:
            return UIColor.blue
        case .quaryBlast:
            return UIColor.init(red: 50/255, green: 145/255, blue: 38/255, alpha: 1.0)
        case .rockBurst, .rockSlide:
            return UIColor.lightGray
        case .snowAvalanche:
            return UIColor.white
        case .sonicBoom:
            return UIColor.white
        case .unknown:
            return UIColor.yellow
        case .volcanicEruption, .volcanicExplosion:
            return UIColor.purple
        }
    }


    /// The query parameter string representing this event type.
    /// + TODO: These are undocumented guesses.
    var queryParamString: String {
        switch  self {
        case .acousticNoise:
            return "acoustic_noise,acoustic noise"
        case .anthropogenicEvent:
            return "anthropogenic_event"
        case .buildingCollapse:
            return "building_collapse"
        case .chemicalExplosion:
            return "chemical_explosion,chemical explosion"
        case .collapse:
            return "collapse"
        case .earthquake:
            return "earthquake,eq"
        case .experimentalExplosion:
            return "experimental_explosion,experimental explosion"
        case .explosion:
            return "explosion"
        case .iceQuake:
            return "ice_quake"
        case .inducedEvent:
            return "induced_event"
        case .landslide:
            return "landslide"
        case .meteor:
            return "meteor"
        case .meteorite:
            return "meteorite"
        case .mineCollapse:
            return "mine_collapse,mine collapse"
        case .mineExplosion:
            return "mining_explosion,mining explosion"
        case .notReported:
            return "not_reported,not reported"
        case .nuclearExplosion:
            return "nuclear_explosion,nuclear explosion"
        case .other:
            return "other_event,other event"
        case .quaryBlast:
            return "quarry,quarry_blast,quarry blast"
        case .rockBurst:
            return "rock_burst,rock burst"
        case .rockSlide:
            return "rock_slide,Rock Slide"
        case .snowAvalanche:
            return "snow_avalanche"
        case .sonicBoom:
            return "sonic_boom,sonic boom,sonicboom"
        case .unknown:
            return "unknown"
        case .volcanicEruption:
            return "volcanic_erruption"
        case .volcanicExplosion:
            return "volcanic_explostion"
        }
    }
}
