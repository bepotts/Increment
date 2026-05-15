//
//  LandingPage.swift
//  Increment
//
//  Created by Brandon Potts on 5/3/26.
//

import SwiftUI

/// A view that shows a landing page for the app.
/// - Parameter onDismiss: A closure that is called when the view is dismissed.
struct LandingPage: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("Welcome to Increment")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            try? await Task.sleep(for: .seconds(3))
            onDismiss()
        }
    }
}

#Preview {
    LandingPage {}
}
