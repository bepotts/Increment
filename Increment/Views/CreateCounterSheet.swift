//
//  CreateCounterSheet.swift
//  Increment
//
//  Created by Brandon Potts on 3/4/26.
//

import FirebaseAnalytics
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

    #if os(iOS)
    @State private var liveView = false
    @State private var areActivitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
    #endif
    @State private var errorMessage: String?

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
            Button("Done", action: handleDone)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .alert("Something went wrong", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            if let errorMessage {
                Text(errorMessage)
            }
        }
    }

    private func handleDone() {
        do {
            try CounterStore(context: modelContext).insert(counter)
            Analytics.logEvent(AppAnalyticsEvent.counterCreated.rawValue, parameters: [
                "count": counter.count,
                "name": counter.name,
                "incrementBy": counter.incrementBy
            ])
        } catch {
            Logger.storage.error("Failed to save counter: \(error)")
            errorMessage = error.localizedDescription
            return
        }
        #if os(iOS)
        if liveView && areActivitiesEnabled {
            Logger.liveActivity.info(
                "Starting live activity for counter '\(counter.name)' with id \(counter.id.uuidString)"
            )
            let attributes = IncrementWidgetAttributes(title: counter.name, id: counter.id)
            let content = ActivityContent(
                state: IncrementWidgetAttributes.ContentState(count: counter.count),
                staleDate: nil
            )
            do {
                let activity = try Activity<IncrementWidgetAttributes>.request(
                    attributes: attributes,
                    content: content
                )
                Logger.liveActivity.info("Started live activity: \(activity.id)")
                Analytics.logEvent(AppAnalyticsEvent.liveActivityStarted.rawValue, parameters: nil)
            } catch {
                Logger.liveActivity.error("Failed to start live activity: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                return
            }
        }
        #endif
        dismiss()
    }
}
