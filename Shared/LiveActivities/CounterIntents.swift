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

nonisolated struct ClickyWidgetAttributes: ActivityAttributes, Sendable {
    nonisolated struct ContentState: Codable, Hashable, Sendable {
        var count: Int
    }

    let title: String
    let id: UUID
}


// MARK: Shared Operation

func performCountOperation(_ operation: CountOperation, for counterId: UUID) async throws {
    let context = ModelContext(ModelContainer.shared)

    let descriptor = FetchDescriptor<Counter>(predicate: #Predicate { $0.id == counterId })
    guard let counter = try context.fetch(descriptor).first else {
        Logger.liveActivity.error("Counter not found for id: \(counterId)")
        return
    }

    switch operation {
    case .increment: counter.increment()
    case .decrement: counter.decrement()
    }

    try context.save()

    for activity in Activity<ClickyWidgetAttributes>.activities where activity.attributes.id == counterId {
        let newState = ClickyWidgetAttributes.ContentState(count: counter.count)
        await activity.update(ActivityContent(state: newState, staleDate: nil))
    }
}

// MARK: Activity Intents

struct IncrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Increment counter"

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

struct DecrementCounterIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Decrement counter"

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
