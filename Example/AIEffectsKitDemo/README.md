# AIEffectsKitDemo

iOS demo app showcasing AIEffectsKit components. Scaffolded to follow the same pattern as the Rerender `DemoApp`.

## Run

```bash
open AIEffectsKitDemo.xcodeproj
```

Then hit ⌘R. The project references AIEffectsKit via a local Swift package at `../..` — no manual dependency setup needed.

Minimum deployment: iOS 17. The iOS 18 `TextRenderer` shimmer path engages automatically on iOS 18+ simulators/devices; older targets fall back to a plain animated `Text`.

## What's here

| Screen | Demonstrates |
|---|---|
| Typing reveal | `StreamText.typing(_:)` — canned paragraph, one character at a time |
| Async token stream | `StreamText(source:)` — chunked `AsyncStream<String>` with jittered delays |

Tap **Replay** on either screen to restart the stream (the view's `id` is bumped to recreate the `.task`).

## Layout

```
AIEffectsKitDemo/
├── AIEffectsKitDemo.xcodeproj
└── AIEffectsKitDemo/
    ├── AIEffectsKitDemoApp.swift   @main
    ├── ContentView.swift           NavigationStack + example list
    ├── Components/
    │   └── ExampleLink.swift
    ├── Examples/
    │   ├── StreamTextTypingExample.swift
    │   └── StreamTextAsyncExample.swift
    └── Assets.xcassets
```
