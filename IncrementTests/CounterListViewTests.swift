//
//  CounterListViewTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for the root counter list view.
@MainActor
struct CounterListViewTests {
    @Test func rendersEmptyState() throws {
        try render(CounterListView(), container: makeTestContainer())
    }

    @Test func rendersWithCounters() throws {
        try render(CounterListView(), container: makeTestContainer(counters: [
            Counter(count: 12, name: "Push-ups", incrementBy: 1),
            Counter(count: 4, name: "Water", incrementBy: 1)
        ]))
    }
}
