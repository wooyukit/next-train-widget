//
//  LocationMapper.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 23/12/2021.
//

import Foundation

extension String {
    var stationName: String {
        switch (self) {
        case "TIK":
            return "調景嶺"
        case "NOP":
            return "北角"
        case "POA":
            return "寶林"
        case "TKO":
            return "將軍澳"
        default:
            return "康城"
        }
    }
}
