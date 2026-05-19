//
//  Enums.swift
//  Increment
//
//  Created by Brandon Potts on 3/7/26.
//

import Foundation

/// Namespace for app-wide constant strings that need to be shared across targets
/// (e.g. the main app and the widget extension).
enum AppStrings {
    nonisolated static let bundle = Bundle.main.bundleIdentifier ?? "No bundle identifier found"
}

/// Analytics event names emitted by the app and shared extension code.
enum AppAnalyticsEvent: String {
    case counterCreated = "counter_created"
    case liveActivityStarted = "live_activity_started"
    case incrementFromLiveActivity = "increment_from_live_activity"
    case decrementFromLiveActivity = "decrement_from_live_activity"
    case deleteCounter = "delete_counter"
    case deleteAllCounters = "delete_all_counters"
    case incrementFromApp = "increment_from_app"
    case decrementFromApp = "decrement_from_app"
}

/// Represents a mutation to apply to a `Counter`'s value.
///
/// Used by intents and views to describe whether a button or action should
/// raise or lower the count, rather than passing raw integers around.
enum CountOperation {
    case increment
    case decrement
}
