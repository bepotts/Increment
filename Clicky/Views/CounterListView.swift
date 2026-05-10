//
//  CounterListView.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import OSLog
import SwiftData
import SwiftUI

struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var counters: [Counter]
    @State private var selectedCounter: Counter?

    var body: some View {
        NavigationStack {
            Group {
                if counters.isEmpty {
                    ContentUnavailableView {
                        Label("No Counters", systemImage: "number.square")
                    } description: {
                        Text("Tap the + button to create your first counter.")
                    }
                } else {
                    List(counters) { counter in
                        Button {
                            selectedCounter = counter
                        } label: {
                            CounterViewListItem(counter: counter)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                modelContext.delete(counter)
                                do {
                                    try modelContext.save()
                                } catch {
                                    Logger.storage.error("Failed to delete counter: \(error)")
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Counter", systemImage: "plus") {
                        selectedCounter = Counter()
                    }
                }
            }
            .sheet(item: $selectedCounter) { counter in
                CreateCounterSheet(counter: counter, onCreated: handleCounterCreated)
                    .presentationDetents([.medium])
            }
        }
    }

    private func handleCounterCreated() {
        // navigateToCounterView = true TODO: Change this once I decide how to handle the navigation
    }
}

#Preview {
    CounterListView()
}
