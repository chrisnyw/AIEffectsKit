//
//  StreamText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

public struct StreamText<Source: AsyncSequence & Sendable>: View where Source.Element == String {
    private let source: Source
    private let style: StreamTextStyle

    @State private var accumulated: String = ""
    @Environment(\.aiState) private var aiState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(
        _ source: Source,
        style: StreamTextStyle = .trailingShimmer()
    ) {
        self.source = source
        self.style = style
    }

    public var body: some View {
        content
            .task {
                await consume(reporting: aiState)
            }
    }

    @ViewBuilder private var content: some View {
        if prefersStatic {
            Text(accumulated)
        } else {
            switch style {
            case .trailingShimmer(let window, let strength, let period):
                shimmerContent(window: window, strength: strength, period: period)
            case .typewriter(let caret):
                TypewriterView(text: accumulated, showCaret: caret)
            case .wordReveal, .fadeRise, .blurFocus:
                WordAnimatedText(text: accumulated, style: style)
            case .tokenChunks(_, let duration):
                TokenChunkText(text: accumulated, duration: duration)
            case .shimmerWipe(_, let duration):
                ShimmerWipeText(text: accumulated, duration: duration)
            case .skeleton(_, let settleDuration):
                SkeletonText(text: accumulated, settleDuration: settleDuration)
            case .scramble(let interval, let probability):
                ScrambleText(text: accumulated, advanceInterval: interval, advanceProbability: probability)
            case .letterDrop(_, let duration):
                LetterDropText(text: accumulated, duration: duration)
            case .lineCascade(_, let duration):
                LineCascadeText(text: accumulated, duration: duration)
            }
        }
    }

    @ViewBuilder
    private func shimmerContent(window: Int, strength: Double, period: Duration) -> some View {
        if #available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *) {
            TimelineView(.animation) { context in
                let phase = phaseValue(at: context.date, period: period)
                Text(accumulated)
                    .textRenderer(
                        StreamingTextRenderer(
                            phase: phase,
                            shimmerWindow: window,
                            shimmerStrength: strength
                        )
                    )
            }
        } else {
            Text(accumulated)
                .animation(.easeOut(duration: 0.2), value: accumulated)
        }
    }

    private var prefersStatic: Bool {
        reduceMotion
            || reduceTransparency
            || ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    private func phaseValue(at date: Date, period: Duration) -> Double {
        let s = seconds(period)
        guard s > 0 else { return 0 }
        let t = date.timeIntervalSinceReferenceDate / s
        return t - floor(t)
    }

    private func consume(reporting state: AIState?) async {
        state?.phase = .streaming
        do {
            for try await token in source {
                accumulated.append(token)
            }
            state?.phase = .done
        } catch {
            state?.phase = .error(String(describing: error))
        }
    }
}
