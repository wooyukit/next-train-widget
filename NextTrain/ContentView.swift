//
//  ContentView.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 19/12/2021.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var departureDataLHP: DepartureData? = nil
    @State var departureDataNOP: DepartureData? = nil
    @State var departureDataTIK: DepartureData? = nil
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("LHP".station)) {
                    ForEach((0..<(departureDataLHP?.down?.count ?? 0)), id: \.self) {
                        if let departure = departureDataLHP?.down?[$0] {
                            HStack {
                                Text("往 \(departure.dest.station)").frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(departure.ttnt)分鐘").frame(maxWidth: .infinity, alignment: .center)
                                Text(departure.time.timeString).frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                Section(header: Text("NOP".station)) {
                    ForEach((0..<(departureDataNOP?.up?.count ?? 0)), id: \.self) {
                        if let departure = departureDataNOP?.up?[$0] {
                            HStack {
                                Text("往 \(departure.dest.station)").frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(departure.ttnt)分鐘").frame(maxWidth: .infinity, alignment: .center)
                                Text(departure.time.timeString).frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                Section(header: Text("TIK".station)) {
                    ForEach((0..<(departureDataTIK?.up?.count ?? 0)), id: \.self) {
                        if let departure = departureDataTIK?.up?[$0] {
                            HStack {
                                Text("往 \(departure.dest.station)").frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(departure.ttnt)分鐘").frame(maxWidth: .infinity, alignment: .center)
                                Text(departure.time.timeString).frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                .navigationTitle("Next Train Widget")
            }
            .refreshable {
                Task {
                    await getData()
                }
            }
        }
        .task {
            await getData()
        }
    }
    
    private func getData() async {
        do {
            departureDataLHP = try await ApiService.shared.getDepartData(.LHP)
            departureDataNOP = try await ApiService.shared.getDepartData(.NOP)
            departureDataTIK = try await ApiService.shared.getDepartData(.TIK)
        } catch {
            print(error)
        }
        // reload widget data as well
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
