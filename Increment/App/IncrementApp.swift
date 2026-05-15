//
//  IncrementApp.swift
//  Increment
//
//  Created by Brandon Potts on 3/4/26.
//

import FirebaseCore
import SwiftData
import SwiftUI

@main
struct IncrementApp: App {

    @AppStorage("lastSeenLanding") private var lastSeenLanding: Double = 0
    // Time interval to show the landing page
    private let landingInterval: TimeInterval = 24 * 60 * 60 // 24 hours in seconds

    private var shouldShowLanding: Bool {
        let elapsed = Date().timeIntervalSince1970 - lastSeenLanding
        return elapsed >= landingInterval
    }

    init() {
        configureFirebase()
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

    private func configureFirebase() {
        guard FirebaseApp.app() == nil else { return }

        if let optionsPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: optionsPath) {
            FirebaseApp.configure(options: options)
        } else {
            #if DEBUG
            print("Firebase is not configured. Add GoogleService-Info.plist to the Increment target.")
            #endif
        }
    }
}
