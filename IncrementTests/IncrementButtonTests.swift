//
//  IncrementButtonTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for the reusable increment button.
@MainActor
struct IncrementButtonTests {
    @Test func renders() throws {
        try render(IncrementButton(counter: Counter(name: "Wins")), container: makeTestContainer())
    }
}
