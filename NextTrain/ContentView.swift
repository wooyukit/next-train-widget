//
//  ContentView.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State var departureDataLHP: DepartureData? = nil
    @State var departureDataNOP: DepartureData? = nil
    @State var departureDataTIK: DepartureData? = nil
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("LHP".station)) {
                    ForEach((0..<(departureDataLHP?.departures?.count ?? 0)), id: \.self) {
                        if let departure = departureDataLHP?.departures?[$0] {
                            Text("\(departure.dest.station) - \(departure.ttnt)分鐘")
                        }
                    }
                }
                Section(header: Text("NOP".station)) {
                    ForEach((0..<(departureDataNOP?.departures?.count ?? 0)), id: \.self) {
                        if let departure = departureDataNOP?.departures?[$0] {
                            Text("\(departure.dest.station) - \(departure.ttnt)分鐘")
                        }
                    }
                }
                Section(header: Text("TIK".station)) {
                    ForEach((0..<(departureDataTIK?.departures?.count ?? 0)), id: \.self) {
                        if let departure = departureDataTIK?.departures?[$0] {
                            Text("\(departure.dest.station) - \(departure.ttnt)分鐘")
                        }
                    }
                }
                .navigationTitle("Next Train Widget")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button("Reload") {
                            Task {
                                await getData()
                            }
                        }
                    })
                }
            }
        }
        .task {
            await getData()
        }
    }
    
    private func getData() async {
        do {
            departureDataLHP = try await ApiService.shared.getLHPDepartData()
            departureDataNOP = try await ApiService.shared.getNOPDepartData()
            departureDataTIK = try await ApiService.shared.getTIKDepartData()
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
