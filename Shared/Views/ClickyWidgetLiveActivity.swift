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
            ClickyLiveActivityLockScreenContent(
                title: context.attributes.title,
                counterId: context.attributes.id.uuidString,
                contentState: context.state
            )
        } dynamicIsland: { context in
            ClickyLiveActivityDynamicIslandContent(context: context).island
        }
    }
}

private struct ClickyLiveActivityLockScreenContent: View {
    let title: String
    let counterId: String
    let contentState: ClickyWidgetAttributes.ContentState

    private var decrementIntent: DecrementCounterIntent {
        let intent = DecrementCounterIntent()
        intent.counterId = counterId
        return intent
    }

    private var incrementIntent: IncrementCounterIntent {
        let intent = IncrementCounterIntent()
        intent.counterId = counterId
        return intent
    }

    var body: some View {
        VStack {
            Text(LocalizedStringResource(stringLiteral: title))
            Text("\(contentState.count)")
            HStack(spacing: 24) {
                Button(intent: decrementIntent) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                }
                Button(intent: incrementIntent) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .activityBackgroundTint(Color.cyan)
        .activitySystemActionForegroundColor(Color.black)
    }
}

private struct ClickyLiveActivityDynamicIslandContent {
    let context: ActivityViewContext<ClickyWidgetAttributes>

    var island: DynamicIsland {
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
