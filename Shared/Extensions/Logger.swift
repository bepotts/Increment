//
//  Logger.swift
//  Clicky
//
//  Created by Brandon Potts on 3/7/26.
//

import OSLog

extension Logger {
    static let users: Logger = .init(subsystem: AppStrings.bundle, category: "users")
    static let liveActivity: Logger = .init(subsystem: AppStrings.bundle, category: "liveActivity")
    static let storage: Logger = .init(subsystem: AppStrings.bundle, category: "storage")
}
