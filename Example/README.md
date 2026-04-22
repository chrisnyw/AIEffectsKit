# AIEffectsKitDemo

iOS demo app showcasing every AIEffectsKit component.

## Run

```bash
open AIEffectsKitDemo.xcodeproj
```

Then ⌘R. The project references AIEffectsKit via a local Swift package at `..` (`XCLocalSwiftPackageReference`) — no dependency resolution step.

Minimum deployment: iOS 17. The iOS 18 `TextRenderer` shimmer engages automatically on iOS 18+ simulators/devices; earlier targets get a plain animated `Text` fallback.

## What's here

The screen list is split into two sections:

### Components

Each effect in isolation — catalogs and tuning surfaces.

| Screen | Demonstrates |
|---|---|
| **IntelligenceGlow** | `.intelligenceGlow(colors:lineWidth:cornerRadius:activeWhen:)` with live sliders for palette, line width, corner radius, and an active toggle. |
| **Streaming styles** | All ten `StreamText` reveal styles in a looping preview, picker-driven. |
| **AI states** | Five indicator visuals (Orb · Aurora ring · Waveform · Prism · Status chip) cycling through all six phases (`.idle` → `.error`). |

### Integration

Everything together, driven by one shared `AIState`.

| Screen | Demonstrates |
|---|---|
| **AI response** | `StreamText` inside an `IntelligenceGlow`-wrapped card, with a user-picked indicator animating idle → listening → thinking → streaming → done. Two pickers persist via `@AppStorage`; **Run again** restarts the whole flow. |

## Architecture

Each example is a **feature folder** containing the view, its `@Observable @MainActor` view model, and any tightly-coupled helpers (rows, enums, token stream helpers). View models own persistence (UserDefaults via `didSet` on observed properties) and orchestration (`.task(id:)` driven flows); views are pure rendering.

## Layout

```
Example/
├── AIEffectsKitDemo.xcodeproj
└── AIEffectsKitDemo/
    ├── AIEffectsKitDemoApp.swift   @main
    ├── ContentView.swift           NavigationStack + sectioned list
    ├── Assets.xcassets/            AIStateSuccess / AIStateError / … color sets
    ├── Components/
    │   └── ExampleLink.swift
    └── Examples/
        ├── AIResponse/
        │   ├── AIResponseExample.swift
        │   ├── AIResponseViewModel.swift
        │   └── StreamTextStyleChoice.swift
        ├── AIStates/
        │   ├── AIStatesExample.swift
        │   ├── AIStatesViewModel.swift
        │   ├── AIStatePhase.swift
        │   ├── IndicatorStyle.swift
        │   ├── IndicatorThumbnail.swift
        │   └── PhaseRow.swift
        ├── IntelligenceGlow/
        │   ├── IntelligenceGlowExample.swift
        │   ├── IntelligenceGlowViewModel.swift
        │   └── GlowPalette.swift
        ├── StreamTextGallery/
        │   ├── StreamTextGalleryExample.swift
        │   ├── StreamTextGalleryViewModel.swift
        │   ├── StreamTextVariant.swift
        │   ├── StreamTextVariantRow.swift
        │   ├── AIMessageStream.swift
        │   └── ThinkingDots.swift
        └── Indicators/
            ├── OrbIndicator.swift
            ├── AuroraRingIndicator.swift
            ├── WaveformIndicator.swift
            ├── PrismIndicator.swift
            └── StatusChipIndicator.swift
```
