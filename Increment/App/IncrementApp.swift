//
//  IncrementApp.swift
//  Increment
//
//  Created by Brandon Potts on 3/4/26.
//

import FirebaseCore
import SwiftData
import SwiftUI

/// App entry point that configures Firebase, attaches the shared SwiftData
/// container, and routes between the landing page and the counter list.
@main
struct IncrementApp: App {
    @AppStorage("lastSeenLanding") private var lastSeenLanding: Double = 0
    @State private var hasPresentedForcedLanding = false
    // Time interval to show the landing page
    private let landingInterval: TimeInterval = 24 * 60 * 60 // 24 hours in seconds
    private let analyticsClient: any AnalyticsClient
    private let modelContainer: ModelContainer

    private var shouldShowLanding: Bool {
        LandingPresentationPolicy(landingInterval: landingInterval).shouldShowLanding(
            lastSeenLanding: lastSeenLanding,
            now: Date(),
            isUITesting: Self.shouldSkipLandingForUITests,
            isLandingForced: Self.shouldShowLandingForUITests && !hasPresentedForcedLanding
        )
    }

    init() {
        analyticsClient = Self.makeAnalyticsClient()
        modelContainer = Self.makeModelContainer()
        configureFirebase()
    }

    var body: some Scene {
        WindowGroup {
            if shouldShowLanding {
                LandingPage {
                    lastSeenLanding = Date().timeIntervalSince1970
                    hasPresentedForcedLanding = true
                }
            } else {
                CounterListView()
            }
        }
        .environment(\.analyticsClient, analyticsClient)
        .modelContainer(modelContainer)
    }

    private func configureFirebase() {
        guard !Self.isUITesting else { return }
        guard !Self.isUnitTesting else { return }
        guard FirebaseApp.app() == nil else { return }

        if let optionsPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: optionsPath)
        {
            FirebaseApp.configure(options: options)
        } else {
            #if DEBUG
            print("Firebase is not configured. Add GoogleService-Info.plist to the Increment target.")
            #endif
        }
    }

    private static var isUITesting: Bool {
        CommandLine.arguments.contains("-ui-testing")
    }

    private static var isUnitTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    private static var shouldSkipLandingForUITests: Bool {
        isUITesting && !CommandLine.arguments.contains("-ui-testing-show-landing")
    }

    private static var shouldShowLandingForUITests: Bool {
        isUITesting && CommandLine.arguments.contains("-ui-testing-show-landing")
    }

    private static func makeAnalyticsClient() -> any AnalyticsClient {
        guard !isUITesting, !isUnitTesting else { return NoOpAnalyticsClient() }

        return FirebaseAnalyticsClient()
    }

    private static func makeModelContainer() -> ModelContainer {
        guard isUITesting || isUnitTesting else { return .shared }

        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Counter.self, configurations: config)
            if isUITesting, !CommandLine.arguments.contains("-ui-testing-empty") {
                container.mainContext.insert(Counter(count: 6, name: "UI Test Counter", incrementBy: 2))
            }
            try container.mainContext.save()
            return container
        } catch {
            fatalError("Failed to create UI test ModelContainer: \(error)")
        }
    }
}

/// Determines whether the landing page should be presented for a given launch context.
struct LandingPresentationPolicy {
    let landingInterval: TimeInterval

    func shouldShowLanding(
        lastSeenLanding: Double,
        now: Date,
        isUITesting: Bool,
        isLandingForced: Bool = false
    ) -> Bool {
        guard !isLandingForced else { return true }
        guard !isUITesting else { return false }

        let elapsed = now.timeIntervalSince1970 - lastSeenLanding
        return elapsed >= landingInterval
    }
}
