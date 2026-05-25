//
//  IncrementAppTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

import Foundation
@testable import Increment
import Testing

/// Unit tests for app-level launch presentation decisions.
@MainActor
struct IncrementAppTests {
    @Test func landingPolicyShowsLandingAfterInterval() {
        let policy = LandingPresentationPolicy(landingInterval: 86400)
        let now = Date(timeIntervalSince1970: 100_000)

        let shouldShowLanding = policy.shouldShowLanding(
            lastSeenLanding: now.timeIntervalSince1970 - 86400,
            now: now,
            isUITesting: false
        )

        #expect(shouldShowLanding)
    }

    @Test func landingPolicyHidesLandingBeforeInterval() {
        let policy = LandingPresentationPolicy(landingInterval: 86400)
        let now = Date(timeIntervalSince1970: 100_000)

        let shouldShowLanding = policy.shouldShowLanding(
            lastSeenLanding: now.timeIntervalSince1970 - 60,
            now: now,
            isUITesting: false
        )

        #expect(!shouldShowLanding)
    }

    @Test func landingPolicyHidesLandingDuringUITests() {
        let policy = LandingPresentationPolicy(landingInterval: 86400)

        let shouldShowLanding = policy.shouldShowLanding(
            lastSeenLanding: 0,
            now: Date(timeIntervalSince1970: 100_000),
            isUITesting: true
        )

        #expect(!shouldShowLanding)
    }
}
