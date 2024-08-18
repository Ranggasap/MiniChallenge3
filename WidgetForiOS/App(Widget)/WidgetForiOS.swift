//
//  WidgetForiOS.swift
//  WidgetForiOS
//
//  Created by Bryan Vernanda on 18/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", title: "Dandelion")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", title: "Dandelion")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀", title: "Dandelion")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let title: String
}

struct WidgetForiOSEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.title)
            .widgetURL(URL(string: "myapp://")!)
    }
}

struct WidgetForiOS: Widget {
    let kind: String = "WidgetForiOS"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetForiOSEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetForiOSEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Dandelion Widget")
        .description("This is Dandelion widget.")
    }
}

#Preview(as: .systemSmall) {
    WidgetForiOS()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", title: "Dandelion")
    SimpleEntry(date: .now, emoji: "🤩", title: "Dandelion")
}
