//
//  Logger.swift
//  Increment
//
//  Created by Brandon Potts on 3/7/26.
//

import OSLog

extension Logger {
    nonisolated static let users: Logger = .init(subsystem: AppStrings.bundle, category: "users")
    nonisolated static let liveActivity: Logger = .init(subsystem: AppStrings.bundle, category: "liveActivity")
    nonisolated static let storage: Logger = .init(subsystem: AppStrings.bundle, category: "storage")
    nonisolated static let views: Logger = .init(subsystem: AppStrings.bundle, category: "views")
}
