# DevMode Neon

A neon-themed SwiftUI companion and checklist for the TrollStore Developer Mode activation workflow.

## Important capability note

This project is a **companion guide**, not a privileged Developer Mode controller. It does not read or modify Apple's protected Developer Mode state and does not invoke private AMFI/XPC services. Use TrollStore's own supported Developer Mode option (when available) and follow Apple's on-device confirmation flow.

## Build with GitHub Actions

1. Create a new GitHub repository.
2. Upload the contents of this project, preserving the folder structure.
3. Open the **Actions** tab.
4. Run **Build DevMode Neon IPA** (or push to `main`).
5. Open the completed workflow run and download the `DevModeNeon-IPA` artifact.
6. Extract the downloaded artifact ZIP to obtain `DevModeNeon.ipa`.

The workflow builds an unsigned iOS app. It is intended for installation through a compatible TrollStore setup. It is not an App Store-signed IPA.

## Build locally on macOS

Install Xcode and XcodeGen, then run:

```bash
brew install xcodegen
xcodegen generate
xcodebuild   -project DevModeNeon.xcodeproj   -scheme DevModeNeon   -configuration Release   -sdk iphoneos   -destination 'generic/platform=iOS'   -derivedDataPath build   CODE_SIGNING_ALLOWED=NO   build
```

The built app is at:

```text
build/Build/Products/Release-iphoneos/DevModeNeon.app
```

## Project layout

```text
.
├── .github/workflows/build.yml
├── DevModeNeon/
│   ├── ContentView.swift
│   └── DevModeNeonApp.swift
├── project.yml
└── README.md
```

## Target

- Minimum iOS: 16.0
- Bundle identifier: `com.devmodeneon.app`
- UI: SwiftUI, dark neon theme
