Increment Project
=====

Currently a work in progress.

## Firebase configuration

Firebase credentials are **not** checked into this repository (`GoogleService-Info.plist` is gitignored). Each developer must use **their own** Firebase project (or credentials issued by the team) so secrets stay private and environments stay isolated.

1. In the [Firebase Console](https://console.firebase.google.com/), create a project or pick one you control.
2. Add an **iOS app** whose bundle identifier matches the Xcode target you build (see the **Increment** target’s bundle ID in Xcode).
3. Download **`GoogleService-Info.plist`** from Firebase and place it at the **repository root** (same directory as this README), replacing any local copy. Xcode already expects that path for the Increment target.

If you only need a checklist of keys, see `GoogleService-Info.template.plist` for the shape of the file; replace every placeholder with values from your downloaded plist—do not commit the filled file.

Until `GoogleService-Info.plist` is present, Firebase-dependent features will not initialize (the app logs a short notice at launch).
