//
//  AnalyticsClient.swift
//  Increment
//
//  Created by Brandon Potts on 5/16/26.
//

import SwiftUI

/// Logs app analytics events through an analytics provider.
protocol AnalyticsClient {
    func logEvent(_ event: AppAnalyticsEvent, parameters: [String: Any]?)
}

private struct AnalyticsClientKey: EnvironmentKey {
    static let defaultValue: any AnalyticsClient = FirebaseAnalyticsClient()
}

extension EnvironmentValues {
    var analyticsClient: any AnalyticsClient {
        get { self[AnalyticsClientKey.self] }
        set { self[AnalyticsClientKey.self] = newValue }
    }
}
