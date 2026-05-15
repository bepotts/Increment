//
//  CounterCountText.swift
//  Increment
//
//  Created by Brandon Potts on 3/4/26.
//

import SwiftUI

struct CounterCountText: View {
    let count: Int

    var body: some View {
        Text(count, format: .number)
            .font(.largeTitle.bold())
            .monospacedDigit()
    }
}
