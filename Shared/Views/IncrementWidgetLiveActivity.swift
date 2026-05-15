//
//  IncrementWidgetLiveActivity.swift
//  IncrementWidget
//
//  Created by Brandon Potts on 3/8/26.
//

#if os(iOS)
import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct IncrementWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IncrementWidgetAttributes.self) { context in
            IncrementLiveActivityLockScreenContent(
                title: context.attributes.title,
                counterId: context.attributes.id.uuidString,
                contentState: context.state
            )
        } dynamicIsland: { context in
            IncrementLiveActivityDynamicIslandContent(context: context).island
        }
    }
}

private struct IncrementLiveActivityLockScreenContent: View {
    let title: String
    let counterId: String
    let contentState: IncrementWidgetAttributes.ContentState

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
}

private struct IncrementLiveActivityDynamicIslandContent {
    let context: ActivityViewContext<IncrementWidgetAttributes>

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

private extension IncrementWidgetAttributes {
    static var preview: IncrementWidgetAttributes {
        IncrementWidgetAttributes(title: "Title", id: UUID())
    }
}

private extension IncrementWidgetAttributes.ContentState {
    static var smiley: IncrementWidgetAttributes.ContentState {
        IncrementWidgetAttributes.ContentState(count: 0)
    }

    static var starEyes: IncrementWidgetAttributes.ContentState {
        IncrementWidgetAttributes.ContentState(count: 42)
    }
}

#Preview("Notification", as: .content, using: IncrementWidgetAttributes.preview) {
    IncrementWidgetLiveActivity()
} contentStates: {
    IncrementWidgetAttributes.ContentState.smiley
    IncrementWidgetAttributes.ContentState.starEyes
}

#endif
