//
//  CounterNameFieldTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for the editable counter name field.
@MainActor
struct CounterNameFieldTests {
    @Test func renders() throws {
        try render(CounterNameField(counter: Counter(name: "Focus")), container: makeTestContainer())
    }
}
