# ``AIEffectsKit``

The visual language of generative AI for SwiftUI.

## Overview

AIEffectsKit packages streaming text reveals, phase-driven indicators, and animated gradient borders as composable SwiftUI primitives. Every effect observes a shared ``AIState`` and auto-degrades under Reduce Motion, Reduce Transparency, and Low Power Mode.

### Getting started

```swift
import SwiftUI
import AIEffectsKit

struct ReplyCard: View {
    @State private var state = AIState()

    var body: some View {
        StreamText(tokenStream, style: .trailingShimmer())
            .padding(16)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
            .intelligenceGlow(cornerRadius: 16)
            .aiState(state)
    }
}
```

As tokens arrive, `StreamText` reports phase transitions (`.streaming` → `.done`) to the injected ``AIState``. The ``/AIEffectsKit/SwiftUI/View/intelligenceGlow(colors:lineWidth:cornerRadius:activeWhen:)`` modifier observes the same state and breathes only while a response is in flight.

### Pick a reveal style

`StreamText` ships with eleven reveal styles — pick whichever suits the surface:

```swift
StreamText(source, style: .typewriter())      // char-by-char with blinking caret
StreamText(source, style: .wordReveal())      // words pop in
StreamText(source, style: .fadeRise())        // words fade + rise + unblur
StreamText(source, style: .blurFocus())       // words deblur from scale 1.04
StreamText(source, style: .shimmerWipe())     // gradient wipes across each word
StreamText(source, style: .tokenChunks())     // chunk highlights that settle
StreamText(source, style: .skeleton())        // gray bars → text crossfade
StreamText(source, style: .scramble())        // random glyphs lock into place
StreamText(source, style: .letterDrop())      // letters drop in from above
StreamText(source, style: .lineCascade())     // whole lines slide up
// Default: .trailingShimmer() — iOS 18 TextRenderer
```

### Accessibility

Every effect respects the three standard a11y flags:

- `accessibilityReduceMotion`
- `accessibilityReduceTransparency`
- `ProcessInfo.isLowPowerModeEnabled`

When any is on, `StreamText` collapses to a static `Text`, ``ThinkingIndicator`` hides its pulse, and the `intelligenceGlow` modifier renders a static border instead of the rotating gradient.

### Platform support

- iOS 17 +, macOS 14 +, watchOS 10 +, visionOS 1 +
- Xcode 16 + / Swift 5.10 + (Swift 6 strict concurrency compatible)
- The ``StreamTextStyle/trailingShimmer(window:strength:period:)`` path uses `TextRenderer` on iOS 18 / macOS 15 / watchOS 11 / visionOS 2 and later; earlier platforms fall back to an animated `Text`.

## Topics

### Streaming text
- ``StreamText``
- ``StreamTextStyle``

### Shared state
- ``AIState``
- ``AIPhase``

### Indicators
- ``ThinkingIndicator``
