# AIEffectsKit

The visual language of generative AI for SwiftUI — state-driven, Metal-accelerated, accessibility-correct.

> Status: Phase 0 (foundation). v0.1.0 will ship `StreamText` solo.

## What it is

A state-driven SwiftUI library for the visual language of generative AI — glow, streaming text, thinking indicators, ripple, generation placeholders. One `AIState` drives every effect coherently.

## Planned component surface

| Component | Purpose |
|---|---|
| `StreamText` | Token-by-token reveal with trailing shimmer (iOS 18 `TextRenderer`) |
| `IntelligenceGlow` | Animated gradient border (Metal `layerEffect`) |
| `ThinkingIndicator` | Compact pulse for inline status |
| `AIRipple` | Tap-origin ripple |
| `GenerationPlaceholder` | Shimmer skeleton → resolved content |
| `AIState` | Shared state (`.idle` / `.listening` / `.thinking` / `.streaming` / `.done` / `.error`) |

## Requirements

- iOS 17+, macOS 14+, watchOS 10+, visionOS 1+
- Xcode 16+ / Swift 5.10+
- iOS 18 required for `StreamText` (gated via `@available`, fallback provided)

## Installation

Swift Package Manager:

```swift
.package(url: "https://github.com/<owner>/AIEffectsKit.git", from: "0.1.0")
```

## Accessibility

Effects auto-degrade when any of these is true:

- `accessibilityReduceMotion`
- `accessibilityReduceTransparency`
- `ProcessInfo.isLowPowerModeEnabled`

## Demo

See `Example/AIEffectsKitDemo/` — a local Xcode project that shows each component. (Added in a later phase.)

## License

MIT — see [LICENSE](LICENSE).
