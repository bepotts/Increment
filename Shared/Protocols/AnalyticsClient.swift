//
//  AnalyticsClient.swift
//  Increment
//
//  Created by Brandon Potts on 5/16/26.
//

import Foundation

protocol AnalyticsClient {
    static func logEvent(_ event: AppAnalyticsEvent, parameters: [String: Any]?)
}
