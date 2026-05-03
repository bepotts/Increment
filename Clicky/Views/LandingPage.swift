//
//  LandingPage.swift
//  Clicky
//
//  Created by Brandon Potts on 5/3/26.
//

import OSLog
import SwiftUI

/// A view that shows a landing page for the app.
/// - Parameter onDismiss: A closure that is called when the view is dismissed.
struct LandingPage: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("Welcome to Clicky")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            Task {
                do {
                    try await Task.sleep(for: .seconds(3))
                    onDismiss()
                } catch {
                    Logger.views.error("Failed to sleep: \(error)")
                }
            }
        }
    }
}

#Preview {
    LandingPage {}
}
