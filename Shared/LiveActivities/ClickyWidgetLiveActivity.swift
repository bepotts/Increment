//
//  ClickyWidgetLiveActivity.swift
//  ClickyWidget
//
//  Created by Brandon Potts on 3/8/26.
//

#if os(iOS)
import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct ClickyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ClickyWidgetAttributes.self) { context in
            ClickyLiveActivityLockScreenContent(context: context, contentState: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.count)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.count)")
            } minimal: {
                Text("\(context.state.count)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

private struct ClickyLiveActivityLockScreenContent: View {
    let context: ActivityViewContext<ClickyWidgetAttributes>
    let contentState: ClickyWidgetAttributes.ContentState

    var body: some View {
        VStack {
            Text("\(context.attributes.title):")
            Text("\(contentState.count)")
            HStack(spacing: 24) {
                Button(intent: DecrementCounterIntent()) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                }
                Button(intent: IncrementCounterIntent()) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .activityBackgroundTint(Color.cyan)
        .activitySystemActionForegroundColor(Color.black)
    }
}

private extension ClickyWidgetAttributes {
    static var preview: ClickyWidgetAttributes {
        ClickyWidgetAttributes(title: "Title", id: UUID())
    }
}

private extension ClickyWidgetAttributes.ContentState {
    static var smiley: ClickyWidgetAttributes.ContentState {
        ClickyWidgetAttributes.ContentState(count: 0)
    }

    static var starEyes: ClickyWidgetAttributes.ContentState {
        ClickyWidgetAttributes.ContentState(count: 42)
    }
}

#Preview("Notification", as: .content, using: ClickyWidgetAttributes.preview) {
    ClickyWidgetLiveActivity()
} contentStates: {
    ClickyWidgetAttributes.ContentState.smiley
    ClickyWidgetAttributes.ContentState.starEyes
}

#endif
