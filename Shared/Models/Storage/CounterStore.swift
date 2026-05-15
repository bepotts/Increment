//
//  CounterStore.swift
//  Increment
//
//  Created by Brandon Potts on 5/12/26.
//

import Foundation
import OSLog
import SwiftData
#if os(iOS)
import ActivityKit
#endif

/// Errors thrown by `CounterStore` when an operation can't be completed.
enum CounterStoreError: Error {
    /// No `Counter` with the supplied id exists in the backing store.
    case counterNotFound(UUID)
}

/// Centralizes all persistence operations for `Counter` objects.
/// Callers pass a `ModelContext` at init and use the provided methods
/// rather than calling `modelContext.save()` directly.
@MainActor
struct CounterStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func insert(_ counter: Counter) throws {
        context.insert(counter)
        try context.save()
    }

    func delete(_ counter: Counter) throws {
        context.delete(counter)
        try context.save()
    }

    func deleteAll(_ counters: [Counter]) throws {
        counters.forEach(context.delete)
        try context.save()
    }

    /// Fetches the counter with the given id, applies the operation, saves, and returns the updated counter.
    /// - Throws: `CounterStoreError.counterNotFound` if no counter with the given id exists,
    ///   plus any error thrown by the underlying `ModelContext` fetch/save.
    private func apply(_ operation: CountOperation, to counterId: UUID) throws -> Counter {
        let descriptor = FetchDescriptor<Counter>(predicate: #Predicate { $0.id == counterId })
        guard let counter = try context.fetch(descriptor).first else {
            Logger.liveActivity.error("No counter with id: \(counterId)")
            throw CounterStoreError.counterNotFound(counterId)
        }

        switch operation {
        case .increment: counter.increment()
        case .decrement: counter.decrement()
        }

        try context.save()
        return counter
    }

    #if os(iOS)
    /// Applies the operation to the counter and pushes the new count to any
    /// Live Activity whose attributes id matches `counterId`.
    /// - Throws: `CounterStoreError.counterNotFound` if no counter with that id exists.
    func updateLiveActivity(for counterId: UUID, operation: CountOperation) async throws {
        Logger.liveActivity.info("Updating Live Activity for counterId: \(counterId)")
        let counter = try apply(operation, to: counterId)
        for activity in Activity<IncrementWidgetAttributes>.activities where activity.attributes.id == counterId {
            Logger.liveActivity.info("Updating Live Activity for counter: \(counter.id) inside the real function")
            await activity.update(ActivityContent(
                state: IncrementWidgetAttributes.ContentState(count: counter.count),
                staleDate: nil
            ))
        }
    }
    #endif
}
