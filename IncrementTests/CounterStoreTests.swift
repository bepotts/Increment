//
//  CounterStoreTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

import Foundation
@testable import Increment
import SwiftData
import Testing

/// Tests for the CounterStore class.
@MainActor
struct CounterStoreTests {
    @Test func insertPersistsCounter() throws {
        let context = try makeContext()
        let store = CounterStore(context: context)
        let counter = Counter(count: 7, name: "Steps", incrementBy: 2)

        try store.insert(counter)

        let savedCounter = try #require(try fetchCounter(id: counter.id, in: context))
        #expect(savedCounter.count == 7)
        #expect(savedCounter.name == "Steps")
        #expect(savedCounter.incrementBy == 2)
    }

    @Test func deleteRemovesCounter() throws {
        let context = try makeContext()
        let store = CounterStore(context: context)
        let counter = Counter(name: "Deleted")
        try store.insert(counter)

        try store.delete(counter)

        #expect(try fetchCounter(id: counter.id, in: context) == nil)
    }

    @Test func deleteAllRemovesCounters() throws {
        let context = try makeContext()
        let store = CounterStore(context: context)
        let counters = [
            Counter(name: "First"),
            Counter(name: "Second")
        ]
        for counter in counters {
            try store.insert(counter)
        }

        try store.deleteAll(counters)

        #expect(try context.fetch(FetchDescriptor<Counter>()).isEmpty)
    }

    private func makeContext() throws -> ModelContext {
        let schema = Schema([Counter.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: configuration)
        return ModelContext(container)
    }

    private func fetchCounter(id: UUID, in context: ModelContext) throws -> Counter? {
        let descriptor = FetchDescriptor<Counter>(predicate: #Predicate { $0.id == id })
        return try context.fetch(descriptor).first
    }
}
