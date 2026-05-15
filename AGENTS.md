# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

Increment is a SwiftUI-based iOS counter application that uses SwiftData for persistence. The app allows users to create multiple named counters with customizable increment values.

## Architecture

### Data Layer
- **SwiftData**: The app uses SwiftData for model persistence with a `ModelContainer` configured in `IncrementApp.swift:13-24`
- **Counter Model** (`Models/Counter.swift`): SwiftData `@Model` class with properties: `count`, `name`, and `incrementBy`. Contains `increment()` and `decrement()` methods (decrement prevents negative values)

### View Layer
- **CounterListView** (`Views/CounterListView.swift`): Root view showing list of all counters. Uses `@Query` to fetch counters from SwiftData. Includes sheet-based counter creation and swipe-to-delete functionality
- **CounterViewListItem** (`Views/CounterViewListItem.swift`): List row component with inline increment/decrement buttons using `.buttonStyle(.borderless)` to allow interaction within the list
- **CounterView** (`Views/CounterView.swift`): Currently appears to be a standalone counter view (navigation integration pending - see TODO at line 53 in CounterListView.swift)

### Key Patterns
- The app entry point (`IncrementApp.swift`) sets up a shared `ModelContainer` and presents `CounterListView` as the root
- Views use `@Environment(\.modelContext)` to access the SwiftData context for CRUD operations
- `@Bindable` is used with Counter objects to enable two-way binding in views

## Development Commands

### Building
```bash
xcodebuild -scheme Increment -configuration Debug build
```

### Testing
```bash
# Run all tests
xcodebuild test -scheme Increment -destination 'platform=iOS Simulator,name=iPhone 16'

# Run unit tests only
xcodebuild test -scheme Increment -only-testing:IncrementTests -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests only
xcodebuild test -scheme Increment -only-testing:IncrementUITests -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Linting and Formatting
The project uses SwiftLint and SwiftFormat via Swift Package Manager plugins:
- SwiftLintPlugins: 0.63.2
- SwiftFormat: 0.60.0

These are integrated as build plugins in Xcode and run automatically during builds.
