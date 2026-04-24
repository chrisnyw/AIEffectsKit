//
//  StreamTextStyleTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-22.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
@testable import AIEffectsKit

struct StreamTextStyleTests {
    /// Smoke test — renaming or removing any public case breaks this.
    @Test func allPublicCasesAreConstructibleWithDefaults() {
        let styles: [StreamTextStyle] = [
            .trailingShimmer(),
            .typewriter(),
            .wordReveal(),
            .tokenChunks(),
            .fadeRise(),
            .blurFocus(),
            .shimmerWipe(),
            .skeleton(),
            .scramble(),
            .letterDrop(),
            .lineCascade()
        ]
        for style in styles { #expect(style == style) }
    }

    @Test func trailingShimmerCustomParametersRoundTrip() {
        let style: StreamTextStyle = .trailingShimmer(
            window: 20,
            strength: 0.8,
            period: .milliseconds(600)
        )
        guard case .trailingShimmer(let window, let strength, let period) = style else {
            Issue.record("expected .trailingShimmer, got \(style)")
            return
        }
        #expect(window == 20)
        #expect(strength == 0.8)
        #expect(period == .milliseconds(600))
    }

    @Test func typewriterCaretDefaultIsOn() {
        guard case .typewriter(let caret) = StreamTextStyle.typewriter() else {
            Issue.record("expected .typewriter")
            return
        }
        #expect(caret == true)
    }

    @Test func scrambleAdvanceProbabilityIsInUnitInterval() {
        guard case .scramble(_, let probability) = StreamTextStyle.scramble() else {
            Issue.record("expected .scramble")
            return
        }
        #expect(probability > 0)
        #expect(probability <= 1)
    }
}
