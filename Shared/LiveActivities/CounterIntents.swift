//
//  CounterIntents.swift
//  Clicky
//
//  Created by Brandon Potts on 5/2/26.
//

#if os(iOS)
import ActivityKit
import AppIntents
import OSLog

struct IncrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Increment counter"

    func perform() async throws -> some IntentResult {
        Logger.liveActivity.info("Performing increment counter")
        for activity in Activity<ClickyWidgetAttributes>.activities {
            let newState = ClickyWidgetAttributes.ContentState(count: activity.content.state.count + 1)
            await activity.update(ActivityContent(state: newState, staleDate: nil))
        }
//        guard let activity = Activity<ClickyWidgetAttributes>.activities.first else {
//            Logger.liveActivity.error("Could not find an active widget activity to update")
//            return .result()
//        }
//        Logger.liveActivity.trace("Incremented counter to \(newState.count)")
        return .result()
    }
}

struct DecrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Decrement counter"

    func perform() async throws -> some IntentResult {
        Logger.liveActivity.info("Performing decrement counter")
//        guard let activity = Activity<ClickyWidgetAttributes>.activities.first else {
//            Logger.liveActivity.error("Could not find an active widget activity to update")
//            return .result()
//        }
        for activity in Activity<ClickyWidgetAttributes>.activities {
            let newState = ClickyWidgetAttributes.ContentState(count: max(0, activity.content.state.count - 1))
            await activity.update(ActivityContent(state: newState, staleDate: nil))
        }
//        Logger.liveActivity.trace("Decremented counter to \(newState.count)")
        return .result()
    }
}

#endif
