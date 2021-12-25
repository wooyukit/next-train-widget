//
//  ApiService.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 22/12/2021.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
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
        static func < (lhs: ApiService.Station, rhs: ApiService.Station) -> Bool {
            return lhs.sortOrder < rhs.sortOrder
        }
    }
    
    let apiString = "https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php?line=TKL&sta=%@"
    
    private init() {}
    
    public func getDepartData(_ station: Station) async throws -> DepartureData {
        let url = URL(string: String(format: apiString, station.rawValue))
        let (data, _) = try await URLSession.shared.data(from: url!)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let jsonData = try JSONSerialization.data(withJSONObject: (result["data"] as! [String: Any])[station.apiKey] as! [String: Any])
        let departureData = try JSONDecoder().decode(DepartureData.self, from: jsonData)
        return departureData
    }
}

