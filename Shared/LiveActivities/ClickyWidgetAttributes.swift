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

    var title: LocalizedStringResource
    var id: UUID
}
#endif
