//
//  CounterSchema.swift
//  Increment
//
//  Created by Brandon Potts on 3/13/26.
//

import Foundation
import SwiftData

enum CounterSchemaV1: VersionedSchema {
	static var versionIdentifier = Schema.Version(1, 0, 0)
	static var models: [any PersistentModel.Type] { [CounterSchemaV1.Counter.self] }

	@Model final class Counter {
		@Attribute(.unique) var id: UUID
		var count: Int
		var name: String
		var incrementBy: Int

		init(id: UUID = UUID(), count: Int = 0, name: String = "", incrementBy: Int = 1) {
			self.id = id
			self.count = count
			self.name = name
			self.incrementBy = incrementBy
		}
	}
}

// V2 drops @Attribute(.unique) on id — required for CloudKit compatibility.
enum CounterSchemaV2: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 0, 0)
	static var models: [any PersistentModel.Type] { [CounterSchemaV2.Counter.self] }

	@Model final class Counter {
		var id: UUID
		var count: Int
		var name: String
		var incrementBy: Int

		init(id: UUID = UUID(), count: Int = 0, name: String = "", incrementBy: Int = 1) {
			self.id = id
			self.count = count
			self.name = name
			self.incrementBy = incrementBy
		}
	}
}

enum CounterMigrationPlan: SchemaMigrationPlan {
	static var schemas: [any VersionedSchema.Type] { [CounterSchemaV1.self, CounterSchemaV2.self] }
	static var stages: [MigrationStage] { [v1ToV2] }

	static let v1ToV2 = MigrationStage.lightweight(
		fromVersion: CounterSchemaV1.self,
		toVersion: CounterSchemaV2.self
	)
}
