//
//  NextTrainWidget.swift
//  NextTrainWidget
//
//  Created by WOO Yu Kit Vincent on 19/12/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), departureData: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let departureData = try await ApiService.shared.getDepartData(.LHP)
            let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), departureData: departureData)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let departureData = try await ApiService.shared.getDepartData(.LHP)
                let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), departureData: departureData)
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60)))
                completion(timeline)
            } catch {
                print(error)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let departureData: DepartureData?
}

struct NextTrainWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.departureData == nil {
            ProgressView()
        } else {
            VStack {
                Text(Station.LHP.stationName).font(.system(size: 18))
                Divider()
                HStack {
                    ForEach((0..<(min(entry.departureData?.down?.count ?? 0, 3))), id: \.self) {
                        if let departure = entry.departureData?.down?[$0] {
                            VStack(spacing: 8) {
                                Text(departure.dest.stationName).font(.caption)
                                Divider()
                                Text("\(departure.ttnt) ??????").font(.caption)
                                Divider()
                                Text(departure.time.timeString).font(.caption)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

@main
struct NextTrainWidget: Widget {
    let kind: String = "NextTrainWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextTrainWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct NextTrainWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextTrainWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), departureData: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
