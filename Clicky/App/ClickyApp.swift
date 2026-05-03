//
//  ClickyApp.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import SwiftData
import SwiftUI

@main
struct ClickyApp: App {

    @AppStorage("lastSeenLanding") private var lastSeenLanding: Double = 0
    // Time interval to show the landing page
    private let landingInterval: TimeInterval = 24 * 60 * 60 // 24 hours in seconds

    private var shouldShowLanding: Bool {
        let elapsed = Date().timeIntervalSince1970 - lastSeenLanding
        return elapsed >= landingInterval
    }


    var body: some Scene {
        WindowGroup {
            if shouldShowLanding {
                LandingPage {
                    lastSeenLanding = Date().timeIntervalSince1970
                }
            } else {
                CounterListView()
            }
        }
        .modelContainer(ModelContainer.shared)
    }
}
