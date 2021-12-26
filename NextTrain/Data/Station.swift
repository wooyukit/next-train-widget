//
//  Station.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 26/12/2021.
//

import Foundation

enum Station: String, Comparable {
    
    case LHP, NOP, TIK, TKO
    var apiKey: String { get { "TKL-\(self.rawValue)" } }
    var stationName: String { get { self.rawValue.stationName } }
    
    private var sortOrder: Int {
        switch self {
        case .LHP:
            return 0
        case .NOP:
            return 1
        case .TIK:
            return 2
        case .TKO:
            return 3
        }
    }
    static func < (lhs: Station, rhs: Station) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}
