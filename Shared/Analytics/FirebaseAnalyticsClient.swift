//
//  FirebaseAnalyticsClient.swift
//  Increment
//
//  Created by Brandon Potts on 5/19/26.
//

import FirebaseAnalytics
import Foundation

/// Analytics client backed by Firebase Analytics.
struct FirebaseAnalyticsClient: AnalyticsClient {
    func logEvent(_ event: AppAnalyticsEvent, parameters: [String: Any]?) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
}
