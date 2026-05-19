# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

Increment is a SwiftUI-based iOS counter application that uses SwiftData for persistence. The app allows users to create multiple named counters with customizable increment values.

## Architecture

### Data Layer
- **SwiftData**: The app uses SwiftData for model persistence with a shared `ModelContainer` extension in `Shared/Extensions/ModelContainer.swift`
- **Counter Model** (`Shared/Models/Counter.swift`): SwiftData `@Model` class with properties including `count`, `name`, and `incrementBy`. Contains increment/decrement behavior through `CounterStore`
- **Counter Store** (`Shared/Models/Storage/CounterStore.swift`): Encapsulates counter persistence and live activity updates

### View Layer
- **App Entry** (`Increment/App/IncrementApp.swift`): Configures Firebase, attaches the shared SwiftData container, and routes between onboarding and the counter list
- **Counter List** (`Increment/Features/Counters/List/CounterListView.swift`): Root counter list. Uses `@Query` to fetch counters from SwiftData. Includes sheet-based counter creation and swipe-to-delete functionality
- **Counter List Item** (`Increment/Features/Counters/List/CounterViewListItem.swift`): List row component with inline increment/decrement buttons using `.buttonStyle(.borderless)` to allow interaction within the list
- **Counter Detail** (`Increment/Features/Counters/Detail/CounterView.swift`): Standalone counter detail view
- **Counter Creation** (`Increment/Features/Counters/Create/CreateCounterSheet.swift`): Sheet for creating and editing counters
- **Counter Components** (`Increment/Features/Counters/Components/`): Reusable counter controls and display components
- **Onboarding** (`Increment/Features/Onboarding/LandingPage.swift`): Time-gated landing page shown before the counter list

### Key Patterns
- The app target is organized by feature under `Increment/Features`, while reusable app setup lives under `Increment/App`
- Shared models, storage, extensions, live activity views, and protocols live under `Shared`
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
