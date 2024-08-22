//
//  WidgetApp.swift
//  WidgetApp
//
//  Created by Vincent Saranang on 23/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct WidgetAppEntryView: View {
    var entry: Provider.Entry
    var family: WidgetFamily

    var body: some View {
        let size = widgetHeight(forFamily: family)

        ZStack {
            Image(.avatarWidget1)
                .resizable()
                .frame(width: size.width / 2.5, height: size.width / 2.5)
                .padding(.bottom, 20)
            VStack {
                Text("Wanna walk today?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.buttonColor4)
                    .padding(.top, 4)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(.buttonColor7)
                    .frame(width: size.width - 16, height: size.height / 3.6)
                    .overlay(
                        Text("Yes, I am")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.fontColor1)
                    )
            }
            .frame(height: size.height - 16)
        }
        .frame(width: size.width, height: size.height)
        .padding()
        .background(.colorBackground1)
    }
}

struct WidgetApp: Widget {
    let kind: String = "WidgetApp"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetAppEntryView(entry: entry, family: .systemSmall)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Dandenion")
        .description("You are not alone!")
    }
}


func widgetHeight(forFamily family: WidgetFamily) -> CGSize {
    switch family {
        case .systemSmall:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return CGSize(width:170, height: 170)
            case CGSize(width: 414, height: 896):
                return CGSize(width:169, height: 169)
            case CGSize(width: 414, height: 736):
                return CGSize(width:159, height: 159)
            case CGSize(width: 390, height: 844):
                return CGSize(width:158, height: 158)
            case CGSize(width: 375, height: 812):
                return CGSize(width:155, height: 155)
            case CGSize(width: 375, height: 667):
                return CGSize(width:148, height: 148)
            case CGSize(width: 360, height: 780):
                return CGSize(width:155, height: 155)
            case CGSize(width: 320, height: 568):
                return CGSize(width:141, height: 141)
            default:
                return CGSize(width:155, height: 155)
            }
        case .systemMedium:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return CGSize(width:364, height: 170)
            case CGSize(width: 414, height: 896):
                return CGSize(width:360, height: 169)
            case CGSize(width: 414, height: 736):
                return CGSize(width:348, height: 159)
            case CGSize(width: 390, height: 844):
                return CGSize(width:338, height: 158)
            case CGSize(width: 375, height: 812):
                return CGSize(width:329, height: 155)
            case CGSize(width: 375, height: 667):
                return CGSize(width:321, height: 148)
            case CGSize(width: 360, height: 780):
                return CGSize(width:329, height: 155)
            case CGSize(width: 320, height: 568):
                return CGSize(width:292, height: 141)
            default:
                return CGSize(width:329, height: 155)
            }
        case .systemLarge:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return CGSize(width:364, height: 382)
            case CGSize(width: 414, height: 896):
                return CGSize(width:360, height: 379)
            case CGSize(width: 414, height: 736):
                return CGSize(width:348, height: 357)
            case CGSize(width: 390, height: 844):
                return CGSize(width:338, height: 354)
            case CGSize(width: 375, height: 812):
                return CGSize(width:329, height: 345)
            case CGSize(width: 375, height: 667):
                return CGSize(width:321, height: 324)
            case CGSize(width: 360, height: 780):
                return CGSize(width:329, height: 345)
            case CGSize(width: 320, height: 568):
                return CGSize(width:292, height: 311)
            default:
                return CGSize(width:329, height: 345)
            }
            
        default:
            return CGSize(width:329, height: 345)
        }
}

#Preview(as: .systemSmall) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
