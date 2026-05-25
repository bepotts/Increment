//
//  CounterTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 3/4/26.
//

import Foundation
@testable import Increment
import Testing

// Tests for the Counter model
struct CounterTests {
    @Test func initializesWithDefaultValues() {
        let counter = Counter()

        #expect(counter.count == .zero)
        #expect(counter.name.isEmpty)
        #expect(counter.incrementBy == 1)
    }

    @Test func initializesWithCustomValues() {
        let id = UUID()
        let counter = Counter(id: id, count: 12, name: "Pushups", incrementBy: 5)

        #expect(counter.id == id)
        #expect(counter.count == 12)
        #expect(counter.name == "Pushups")
        #expect(counter.incrementBy == 5)
    }

    @Test func incrementAddsIncrementByToCount() {
        let counter = Counter(count: 10, incrementBy: 3)

        counter.increment()

        #expect(counter.count == 13)
    }

    @Test func decrementSubtractsIncrementByFromCount() {
        let counter = Counter(count: 10, incrementBy: 3)

        counter.decrement()

        #expect(counter.count == 7)
    }

    @Test func decrementDoesNotReduceCountBelowZero() {
        let counter = Counter(count: 2, incrementBy: 5)

        counter.decrement()

        #expect(counter.count == .zero)
    }

    @Test func decrementKeepsZeroAtZero() {
        let counter = Counter(count: 0, incrementBy: 1)

        counter.decrement()

        #expect(counter.count == .zero)
    }
}
