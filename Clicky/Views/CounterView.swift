//
//  CounterView.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import SwiftData
import SwiftUI

struct CounterView: View {
    @Bindable var counter: Counter

    var body: some View {
        VStack(spacing: 24) {
            CounterNameField(counter: counter)
            CounterCountText(count: counter.count)
            HStack(spacing: 24) {
                DecrementButton(counter: counter)
                IncrementButton(counter: counter)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CounterView(counter: Counter(count: 42, name: "Sample"))
        .modelContainer(for: Counter.self, inMemory: true)
}
