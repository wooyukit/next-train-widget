//
//  ApiService.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 22/12/2021.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
    
    let apiString = "https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php?line=%@&sta=%@"
    
    private init() {}
    
    public func getDepartData(_ station: Station) async throws -> DepartureData {
        let url = URL(string: String(format: apiString, station.line, station.rawValue))
        let (data, _) = try await URLSession.shared.data(from: url!)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let jsonData = try JSONSerialization.data(withJSONObject: (result["data"] as! [String: Any])[station.apiKey] as! [String: Any])
        let departureData = try JSONDecoder().decode(DepartureData.self, from: jsonData)
        return departureData
    }
}

