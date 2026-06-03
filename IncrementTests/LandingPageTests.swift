//
//  LandingPageTests.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import Testing

/// Unit tests for the onboarding landing page view.
@MainActor
struct LandingPageTests {
    @Test func renders() throws {
        try render(LandingPage {})
    }
}
