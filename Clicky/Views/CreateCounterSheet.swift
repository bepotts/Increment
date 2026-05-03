//
//  CreateCounterSheet.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import OSLog
import SwiftData
import SwiftUI

#if os(iOS)
import ActivityKit
#endif

struct CreateCounterSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var counter: Counter
    let onCreated: () -> Void

    #if os(iOS)
    @State private var liveView = false
    @State private var areActivitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
    #endif

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Name of new Counter")
                .frame(maxWidth: .infinity)
            TextField("Name", text: $counter.name)
                .textFieldStyle(.roundedBorder)
            Text("Increment By")
                .frame(maxWidth: .infinity)
            TextField("Increment By", value: $counter.incrementBy, format: .number)
                .textFieldStyle(.roundedBorder)
            #if os(iOS)
                .keyboardType(.numberPad)
            #endif
            Text("Starting Count")
                .frame(maxWidth: .infinity)
            TextField("Starting Count", value: $counter.count, format: .number)
                .textFieldStyle(.roundedBorder)
            #if os(iOS)
                .keyboardType(.numberPad)
            #endif
            #if os(iOS)
            if areActivitiesEnabled {
                Toggle("Live View", isOn: $liveView)
            }
            #endif
            Button("Done") {
                modelContext.insert(counter)
                do {
                    try modelContext.save()
                } catch {
                    Logger.storage.error("Failed to save counter: \(error)")
                }
                #if os(iOS)
                if liveView && areActivitiesEnabled {
                    Logger.liveActivity.info(
                        "Starting live activity for counter '\(counter.name)' with id \(counter.id.uuidString)"
                    )
                    let attributes = ClickyWidgetAttributes(title: counter.localizedName, id: counter.id)
                    let content = ActivityContent(
                        state: ClickyWidgetAttributes.ContentState(count: counter.count),
                        staleDate: nil
                    )
                    do {
                        let info = ActivityAuthorizationInfo()
                        Logger.liveActivity.info("areActivitiesEnabled = \(info.areActivitiesEnabled)")

                        let activity = try Activity<ClickyWidgetAttributes>.request(
                            attributes: attributes,
                            content: content
                        )

                        Logger.liveActivity.info("Started live activity: \(activity.id)")
                    } catch {
                        Logger.liveActivity.error("Failed to start live activity: \(error.localizedDescription)")
                    }
                }
                #endif
                onCreated()
                dismiss()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
