//
//  ModelContainerTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

import Foundation
@testable import Increment
import SwiftData
import Testing

/// Tests for the shared SwiftData container configuration.
@MainActor
struct ModelContainerTests {
    @Test func sharedReturnsSameContainerInstance() {
        let firstContainer = ModelContainer.shared
        let secondContainer = ModelContainer.shared

        #expect(firstContainer === secondContainer)
    }

    @Test func sharedContainerPersistsCounters() throws {
        let context = ModelContext(ModelContainer.shared)
        let counterID = UUID()
        let counter = Counter(id: counterID, count: 42, name: "Shared Container Test", incrementBy: 3)

        context.insert(counter)
        try context.save()

        defer {
            do {
                if let savedCounter = try fetchCounter(id: counterID, in: context) {
                    context.delete(savedCounter)
                    try context.save()
                }
            } catch {
                Issue.record("Failed to clean up shared container test counter: \(error)")
            }
        }

        let savedCounter = try #require(try fetchCounter(id: counterID, in: context))
        #expect(savedCounter.count == 42)
        #expect(savedCounter.name == "Shared Container Test")
        #expect(savedCounter.incrementBy == 3)
    }

    private func fetchCounter(id: UUID, in context: ModelContext) throws -> Counter? {
        let descriptor = FetchDescriptor<Counter>(predicate: #Predicate { $0.id == id })
        return try context.fetch(descriptor).first
    }
}
