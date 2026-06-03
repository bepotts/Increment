//
//  IncrementTestSupport.swift
//  IncrementTests
//
//  Created by Brandon Potts on 5/24/26.
//

@testable import Increment
import SwiftData
import SwiftUI
import Testing
import UIKit

@MainActor
func render(
    _ view: some View,
    container: ModelContainer? = nil,
    sourceLocation: SourceLocation = #_sourceLocation
) throws {
    let container = try container ?? makeTestContainer()
    let host = UIHostingController(
        rootView: view
            .environment(\.analyticsClient, NoOpAnalyticsClient())
            .modelContainer(container)
    )
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))

    window.rootViewController = host
    window.makeKeyAndVisible()
    defer {
        window.isHidden = true
        window.rootViewController = nil
    }

    host.view.setNeedsLayout()
    host.view.layoutIfNeeded()

    #expect(host.view.window === window, sourceLocation: sourceLocation)
    #expect(host.view.bounds.size == CGSize(width: 390, height: 844), sourceLocation: sourceLocation)
}

@MainActor
func makeTestContainer(counters: [Counter] = []) throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Counter.self, configurations: config)
    counters.forEach { container.mainContext.insert($0) }
    try container.mainContext.save()
    return container
}

/// Analytics client used by view tests to satisfy the environment without recording events.
private struct NoOpAnalyticsClient: AnalyticsClient {
    func logEvent(_ event: AppAnalyticsEvent, parameters: [String: Any]?) {}
}
