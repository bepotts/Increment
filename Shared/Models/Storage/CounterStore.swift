//
//  CounterStore.swift
//  Clicky
//
//  Created by Brandon Potts on 5/12/26.
//

import Foundation
import SwiftData

/// Centralizes all persistence operations for `Counter` objects.
/// Callers pass a `ModelContext` at init and use the provided methods
/// rather than calling `modelContext.save()` directly.
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

    /// Fetches the counter with the given id, applies the operation, saves, and returns the updated counter.
    /// Returns `nil` if no counter with that id exists.
    func apply(_ operation: CountOperation, to counterId: UUID) throws -> Counter? {
        let descriptor = FetchDescriptor<Counter>(predicate: #Predicate { $0.id == counterId })
        guard let counter = try context.fetch(descriptor).first else { return nil }

        switch operation {
        case .increment: counter.increment()
        case .decrement: counter.decrement()
        }

        try context.save()
        return counter
    }
}
