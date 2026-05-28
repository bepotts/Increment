//
//  ModelContainer.swift
//  Increment
//
//  Created by Brandon Potts on 3/11/26.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var shared: ModelContainer = {
        if isRunningUnitTests {
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                return try ModelContainer(for: Counter.self, configurations: config)
            } catch {
                fatalError("Failed to create test ModelContainer: \(error)")
            }
        }

        let groupID = "group.com.pottsProjects.Increment"
        guard
            let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: groupID)?
                .appending(path: "Increment.store")
        else {
            fatalError("Could not resolve App Group container URL")
        }

        let schema = Schema([Counter.self], version: CounterSchemaV2.versionIdentifier)
        let config = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .automatic)

        do {
            return try ModelContainer(for: schema, migrationPlan: CounterMigrationPlan.self, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    private static var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
