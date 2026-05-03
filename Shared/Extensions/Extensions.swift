//
//  Extensions.swift
//  Clicky
//
//  Created by Brandon Potts on 3/11/26.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var shared: ModelContainer = {
        let groupID = "group.com.pottsProjects.Clicky"
        guard
            let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: groupID)?
                .appending(path: "Clicky.sqlite")
        else {
            fatalError("Could not resolve App Group container URL")
        }

        let schema = Schema([Counter.self], version: CounterSchemaV1.versionIdentifier)
        let config = ModelConfiguration(schema: schema, url: url)

        do {
            return try ModelContainer(for: schema, migrationPlan: CounterMigrationPlan.self, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
