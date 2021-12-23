//
//  Departure.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 22/12/2021.
//

import Foundation
import SwiftUI

struct DepartureData: Codable {
    let currentTime: String
    let systemTime: String
    let down: [Departure]?
    let up: [Departure]?
    
    enum CodingKeys: String, CodingKey {
        case currentTime = "curr_time"
        case systemTime = "sys_time"
        case down = "DOWN"
        case up = "UP"
    }
}
