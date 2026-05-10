//
//  CounterNameField.swift
//  Clicky
//
//  Created by Brandon Potts on 3/4/26.
//

import SwiftUI

struct CounterNameField: View {
    @Bindable var counter: Counter

    var body: some View {
        TextField("Enter name of count", text: $counter.name)
            .textFieldStyle(.plain)
    }
}
