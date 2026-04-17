# AIEffectsKit

**The visual language of generative AI for SwiftUI** — state-driven, Metal-accelerated, accessibility-correct.

<p align="center">
  <img src="Assets/stream-text-hero.gif" alt="StreamText hero" width="560">
</p>

> v0.1.0 ships `StreamText` — a token-by-token reveal with a trailing shimmer, built on the iOS 18 `TextRenderer` API. Later releases will add `IntelligenceGlow`, `ThinkingIndicator`, `AIRipple`, `GenerationPlaceholder`, and shared `AIState` wiring.

## Why

Apple Intelligence has settled into a recognisable visual language — the breathing glow, the streaming reveal, the trailing shimmer. No library packages it coherently. AIEffectsKit fills that gap.

`StreamText` in particular uses iOS 18's `TextRenderer` to render the trailing edge of streamed text with a live shimmer — something nobody else ships.

## Install

Swift Package Manager:

```swift
.package(url: "https://github.com/<owner>/AIEffectsKit.git", from: "0.1.0")
```

Then:

```swift
import AIEffectsKit
```

## Quick start — `StreamText`

Wrap any `AsyncSequence<String>`:

```swift
StreamText(llmTokenStream)
    .font(.title3)
```

Or use the built-in `.typing(_:)` helper for demos and deterministic previews:

```swift
StreamText.typing("The quick brown fox jumps over the lazy dog.")
    .font(.body)
```

Tuning:

```swift
StreamText(
    source,
    shimmerWindow: 10,              // number of trailing chars that shimmer
    shimmerStrength: 0.5,           // 0 = no pulse, 1 = fully fade in and out
    shimmerPeriod: .milliseconds(1200)
)
```

## Platforms

- iOS 17+, macOS 14+, watchOS 10+, visionOS 1+
- Xcode 16+ / Swift 5.10+
- The `TextRenderer` shimmer engages on iOS 18 / macOS 15 / watchOS 11 / visionOS 2 and later; earlier targets get a plain animated `Text` fallback.

## Accessibility

`StreamText` collapses to a static, opaque `Text` when any of:

- `accessibilityReduceMotion`
- `accessibilityReduceTransparency`
- `ProcessInfo.isLowPowerModeEnabled`

is on. No configuration required.

## Demo

Open `Example/AIEffectsKitDemo.xcodeproj` and run. The project references this package locally, so there's no setup step.

## Roadmap

| Release | Scope |
|---|---|
| **v0.1.0** | `StreamText` (iOS 18 `TextRenderer`) |
| v0.2.0 | `IntelligenceGlow` (Metal), `ThinkingIndicator`, `AIState` wiring |
| v1.0.0 | `AIRipple`, `GenerationPlaceholder`, hero demo, FoundationModelsKit integration |

See `AIEffectsKit-PLAN.md` for positioning, market research, and kill-switches.

## License

MIT — see [LICENSE](LICENSE).
