//
//  CounterViewListItemTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for an individual counter row in the list.
@MainActor
struct CounterViewListItemTests {
    @Test func renders() throws {
        try render(
            CounterViewListItem(counter: Counter(count: 3, name: "Tea Time"), onLongPress: {}),
            container: makeTestContainer()
        )
    }
}
