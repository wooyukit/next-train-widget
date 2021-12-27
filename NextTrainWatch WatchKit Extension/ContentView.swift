//
//  ContentView.swift
//  NextTrainWatch WatchKit Extension
//
//  Created by WOO Yu Kit Vincent on 26/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State var departureDatas: [Station: DepartureData?] = [:]
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        let keys = departureDatas.map { $0.key }.sorted(by: <)
        return ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(keys.indices, id: \.self) { index in
                    let station = keys[index]
                    let value = departureDatas[station] ?? nil
                    Section(header: VStack(alignment: .leading) {
                        Text(station.stationName).padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 0))
                        Divider() }.background(.black)
                    ) {
                        let departures = station == Station.LHP ? value?.down : value?.up
                        ForEach((0..<(departures?.count ?? 0)), id: \.self) {
                            if let departure = departures?[$0] {
                                Button(action: {}) {
                                    HStack {
                                        Text("往 \(departure.dest.stationName)").frame(maxWidth: .infinity, alignment: .leading)
                                        Text(departure.time.timeString).frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("watch app become active")
                Task { await getData() }
            case .background:
                print("watch app go background")
            case .inactive:
                print("watch app inactive")
            @unknown default:
                print("watch app default state")
            }
        }
        .task { await getData() }
    }
    
    private func getData() async {
        do {
            departureDatas[.LHP] = try await ApiService.shared.getDepartData(.LHP)
            departureDatas[.NOP] = try await ApiService.shared.getDepartData(.NOP)
            departureDatas[.TIK] = try await ApiService.shared.getDepartData(.TIK)
            departureDatas[.TKO] = try await ApiService.shared.getDepartData(.TKO)
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
