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
import SwiftData

/// Attributes describing a Clicky Live Activity for a single `Counter`.
nonisolated struct ClickyWidgetAttributes: ActivityAttributes, Sendable {
    nonisolated struct ContentState: Codable, Hashable, Sendable {
        /// The current count to display in the Live Activity UI.
        var count: Int
    }
    /// Human-readable name of the counter, shown in the Live Activity UI.
    let title: String
    /// Stable identifier of the underlying `Counter` model.
    let id: UUID
}


// MARK: Shared Operation

/// Applies a `CountOperation` to the `Counter` with the given id and
/// propagates the new value to any in-flight Live Activities.
///
/// This is the single shared entry point used by both the in-app UI and
/// the Live Activity intents so that mutation, persistence, and UI
/// updates stay in sync regardless of where the action originates.
///
/// The function:
/// 1. Resolves the target `Counter` via a fresh `ModelContext` backed by
///    the shared `ModelContainer` (necessary because intents may run
///    outside the main app process).
/// 2. Applies `increment()` / `decrement()` according to `operation`.
///    `decrement()` clamps at zero, so calling this with `.decrement`
///    on a counter at `0` is a no-op.
/// 3. Saves the context and pushes a new `ContentState` to every
///    active `ClickyWidgetAttributes` activity whose `id` matches.
///
/// If no matching counter is found, the function logs and returns
/// without throwing so that stale intents don't crash the widget.
///
/// - Parameters:
///   - operation: The mutation to apply to the counter.
///   - counterId: The id of the `Counter` to mutate.
func performCountOperation(_ operation: CountOperation, for counterId: UUID) async throws {
    let context = ModelContext(ModelContainer.shared)
    let store = CounterStore(context: context)

    guard let counter = try store.apply(operation, to: counterId) else {
        Logger.liveActivity.error("Counter not found for id: \(counterId)")
        return
    }

    for activity in Activity<ClickyWidgetAttributes>.activities where activity.attributes.id == counterId {
        let newState = ClickyWidgetAttributes.ContentState(count: counter.count)
        await activity.update(ActivityContent(state: newState, staleDate: nil))
    }
}

// MARK: Activity Intents

/// Live Activity intent that increments a specific counter when the user
/// taps the "+" button on the Live Activity or Dynamic Island.
///
/// The intent receives the target counter's id as a string parameter so
/// that the same intent type can be reused across activities for any
/// counter in the app.
struct IncrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Increment counter"

    /// Stringified UUID of the counter to increment. Stored as `String`
    /// because `AppIntents` parameters don't natively support `UUID`.
    @Parameter(title: "Counter ID")
    var counterId: String

    func perform() async throws -> some IntentResult {
        guard let uuid = UUID(uuidString: counterId) else {
            Logger.liveActivity.error("Invalid counter ID string: \(counterId)")
            return .result()
        }
        Logger.liveActivity.info("Performing increment counter for id: \(counterId)")
        try await performCountOperation(.increment, for: uuid)
        return .result()
    }
}

/// Live Activity intent that decrements a specific counter when the user
/// taps the "-" button on the Live Activity or Dynamic Island.
///
/// Mirrors `IncrementCounterIntent` but invokes `Counter.decrement()`,
/// which clamps the value at zero so the counter cannot go negative.
struct DecrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Decrement counter"

    /// Stringified UUID of the counter to decrement. Stored as `String`
    /// because `AppIntents` parameters don't natively support `UUID`.
    @Parameter(title: "Counter ID")
    var counterId: String

    func perform() async throws -> some IntentResult {
        guard let uuid = UUID(uuidString: counterId) else {
            Logger.liveActivity.error("Invalid counter ID string: \(counterId)")
            return .result()
        }
        Logger.liveActivity.info("Performing decrement counter for id: \(counterId)")
        try await performCountOperation(.decrement, for: uuid)
        return .result()
    }
}

#endif
