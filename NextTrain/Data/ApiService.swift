//
//  ApiService.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 22/12/2021.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
    let urlLHP = URL(string: "https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php?line=TKL&sta=LHP")
    let urlNOP = URL(string: "https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php?line=TKL&sta=NOP")
    let urlTIK = URL(string: "https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php?line=TKL&sta=TIK")
    
    private init() {}
    
    public func getLHPDepartData() async throws -> DepartureData {
        let (data, _) = try await URLSession.shared.data(from: urlLHP!)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let jsonData = try JSONSerialization.data(withJSONObject: (result["data"] as! [String: Any])["TKL-LHP"] as! [String: Any])
        let departureData = try JSONDecoder().decode(DepartureData.self, from: jsonData)
        return departureData
    }
    
    public func getNOPDepartData() async throws -> DepartureData {
        let (data, _) = try await URLSession.shared.data(from: urlNOP!)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let jsonData = try JSONSerialization.data(withJSONObject: (result["data"] as! [String: Any])["TKL-NOP"] as! [String: Any])
        let departureData = try JSONDecoder().decode(DepartureData.self, from: jsonData)
        return departureData
    }
    
    public func getTIKDepartData() async throws -> DepartureData {
        let (data, _) = try await URLSession.shared.data(from: urlTIK!)
        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let jsonData = try JSONSerialization.data(withJSONObject: (result["data"] as! [String: Any])["TKL-TIK"] as! [String: Any])
        let departureData = try JSONDecoder().decode(DepartureData.self, from: jsonData)
        return departureData
    }
}

