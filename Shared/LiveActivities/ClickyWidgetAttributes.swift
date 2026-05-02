//
//  ClickyWidgetAttributes.swift
//
//
//

#if os(iOS)
import ActivityKit
import Foundation
struct ClickyWidgetAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var count: Int
    }

    var title: String
    var id: UUID
}
#endif
