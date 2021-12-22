//
//  LocationMapper.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 23/12/2021.
//

import Foundation

extension String {
    var station: String {
        switch (self) {
        case "TIK":
            return "調景嶺"
        case "NOP":
            return "北角"
        case "POA":
            return "寶林"
        default:
            return "康城"
        }
    }
}
