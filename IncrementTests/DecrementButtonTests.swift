//
//  DecrementButtonTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for the reusable decrement button.
@MainActor
struct DecrementButtonTests {
    @Test func renders() throws {
        try render(DecrementButton(counter: Counter(count: 5, name: "Wins")), container: makeTestContainer())
    }
}
