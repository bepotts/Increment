//
//  Counter.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import Foundation
import SwiftData

@Model
final class Counter {
	var id: UUID = UUID()
	var count: Int = 0
	var name: String = ""
	var incrementBy: Int = 1

	@Transient var localizedName: LocalizedStringResource { LocalizedStringResource(stringLiteral: name) }

	init(id: UUID = UUID(), count: Int = 0, name: String = "", incrementBy: Int = 1) {
		self.id = id
		self.count = count
		self.name = name
		self.incrementBy = incrementBy
	}

	func increment() {
		count += incrementBy
	}

	func decrement() {
		count = max(0, count - incrementBy)
	}
}
