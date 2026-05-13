//
//  DecrementButton.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import OSLog
import SwiftData
import SwiftUI

struct DecrementButton: View {
    let counter: Counter
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Button(action: handleDecrement) {
            Text("-")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                .frame(minWidth: 80, minHeight: 80)
                .background(.blue, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Decrement")
    }

    private func handleDecrement() {
        Task {
            do {
                try await CounterStore(context: modelContext).updateLiveActivity(for: counter.id, operation: .decrement)
            } catch {
                Logger.storage.error("Failed to decrement counter: \(error)")
            }
        }
    }
}
