//
//  CounterListView.swift
//  Increment
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
    @State private var isShowingDeleteAllConfirmation = false

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
                            // TODO: Navigate to CounterView
                        } label: {
                            CounterViewListItem(counter: counter, onLongPress: { editCounter(counter) })
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteCounter(counter)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Delete All Counters", systemImage: "trash", role: .destructive) {
                        isShowingDeleteAllConfirmation = true
                    }
                    .disabled(counters.isEmpty)

                    Button("Add Counter", systemImage: "plus") {
                        selectedCounter = Counter()
                    }
                }
            }
            .sheet(item: $selectedCounter) { counter in
                CreateCounterSheet(counter: counter)
                    .presentationDetents([.medium])
            }
            .alert("Delete All Counters?", isPresented: $isShowingDeleteAllConfirmation) {
                Button("Delete All", role: .destructive) {
                    deleteAllCounters()
                }

                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete every counter.")
            }
        }
    }

    private func editCounter(_ counter: Counter) {
        Logger.views.info("Editing counter: \(counter.id)")
        selectedCounter = counter
    }
    
    private func deleteCounter(_ counter: Counter) {
        do {
            try CounterStore(context: modelContext).delete(counter)
        } catch {
            Logger.storage.error("Failed to delete counter: \(error)")
        }
    }

    private func deleteAllCounters() {
        do {
            try CounterStore(context: modelContext).deleteAll(counters)
        } catch {
            Logger.storage.error("Failed to delete all counters: \(error)")
        }
    }
}

// MARK: - Previews

#Preview("Empty") {
    CounterListView()
        .modelContainer(CounterListPreviewData.emptyContainer)
}

#Preview("Three Counters") {
    CounterListView()
        .modelContainer(CounterListPreviewData.populatedContainer)
}

@MainActor
private enum CounterListPreviewData {
    static var emptyContainer: ModelContainer {
        makeContainer()
    }

    static var populatedContainer: ModelContainer {
        makeContainer(counters: [
            Counter(count: 12, name: "Push-ups", incrementBy: 1),
            Counter(count: 4, name: "Water", incrementBy: 1),
            Counter(count: 28, name: "Pages", incrementBy: 5)
        ])
    }

    private static func makeContainer(counters: [Counter] = []) -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Counter.self, configurations: config)
            counters.forEach { container.mainContext.insert($0) }
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}
