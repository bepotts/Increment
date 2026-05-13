//
//  CounterViewListItem.swift
//  Clicky
//
//  Created by Brandon Potts on 3/7/26.
//

import OSLog
import SwiftData
import SwiftUI

struct CounterViewListItem: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var counter: Counter
    var onLongPress: () -> Void

    var body: some View {
        HStack {
            Button("-") { Task { await decrement() } }
            .buttonStyle(.borderless)
            .accessibilityLabel("Decrement")
            Spacer()
            VStack(alignment: .leading, spacing: 40) {
                Text(counter.localizedName)
                Text("\(counter.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("+") { Task { await increment() } }
            .buttonStyle(.borderless)
            .accessibilityLabel("Increment")
        }
        .onLongPressGesture(perform: onLongPress)
    }

    private func increment() async {
        do {
            try await CounterStore(context: modelContext).updateLiveActivity(for: counter.id, operation: .increment)
        } catch {
            Logger.storage.error("Failed to increment counter: \(error)")
        }
    }

    private func decrement() async {
        do {
            try await CounterStore(context: modelContext).updateLiveActivity(for: counter.id, operation: .decrement)
        } catch {
            Logger.storage.error("Failed to decrement counter: \(error)")
        }
    }
}

#Preview {
    CounterViewListItem(counter: Counter(count: 42, name: "Sample"), onLongPress: {})
}
