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
        VStack {
            Text("LHP".station).font(.system(size: 16))
            Divider()
            HStack {
                ForEach((0..<(min(entry.departureData?.down?.count ?? 0, 3))), id: \.self) {
                    if let departure = entry.departureData?.down?[$0] {
                        VStack(spacing: 8) {
                            Text("\(departure.ttnt)分鐘").font(.caption)
                            Divider()
                            Text(departure.time.timeString).font(.caption)
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
    }
}

struct NextTrainWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextTrainWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), departureData: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
