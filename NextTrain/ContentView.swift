//
//  ContentView.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 19/12/2021.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var departureDatas: [Station: DepartureData?] = [:]
    
    var body: some View {
        let keys = departureDatas.map { $0.key }.sorted(by: <)
        return NavigationView {
            List {
                ForEach(keys.indices, id: \.self) { index in
                    let station = keys[index]
                    let value = departureDatas[station] ?? nil
                    Section(header: Text(station.stationName)) {
                        let departures = station == Station.LHP ? value?.down : value?.up
                        ForEach((0..<(departures?.count ?? 0)), id: \.self) {
                            if let departure = departures?[$0] {
                                HStack {
                                    Text("往 \(departure.dest.stationName)").frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(departure.ttnt) 分鐘").frame(maxWidth: .infinity, alignment: .center)
                                    Text(departure.time.timeString).frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Next Train")
            }
            .refreshable {
                Task { await getData() }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task { await getData() }
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
        // reload widget data as well
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
