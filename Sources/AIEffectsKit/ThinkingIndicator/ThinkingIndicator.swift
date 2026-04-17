//
//  ThinkingIndicator.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

public struct ThinkingIndicator: View {
    @Environment(\.aiState) private var aiState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let dotCount: Int
    private let dotSize: CGFloat
    private let spacing: CGFloat
    private let period: Duration

    public init(
        dotCount: Int = 3,
        dotSize: CGFloat = 6,
        spacing: CGFloat = 4,
        period: Duration = .milliseconds(1100)
    ) {
        self.dotCount = dotCount
        self.dotSize = dotSize
        self.spacing = spacing
        self.period = period
    }

    public var body: some View {
        if aiState?.phase == .thinking {
            indicator
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Thinking")
                .accessibilityAddTraits(.updatesFrequently)
        }
    }

    @ViewBuilder private var indicator: some View {
        if reduceMotion || ProcessInfo.processInfo.isLowPowerModeEnabled {
            HStack(spacing: spacing) {
                ForEach(0..<dotCount, id: \.self) { _ in
                    Circle()
                        .frame(width: dotSize, height: dotSize)
                        .opacity(0.5)
                }
            }
        } else {
            TimelineView(.animation) { context in
                let phase = phaseValue(at: context.date)
                HStack(spacing: spacing) {
                    ForEach(0..<dotCount, id: \.self) { index in
                        let offset = Double(index) / Double(dotCount)
                        let wave = sin((phase - offset) * .pi * 2)
                        let pulse = 0.5 + 0.5 * wave
                        Circle()
                            .frame(width: dotSize, height: dotSize)
                            .opacity(0.25 + 0.65 * pulse)
                            .scaleEffect(0.75 + 0.25 * pulse)
                    }
                }
            }
        }
    }

    private func phaseValue(at date: Date) -> Double {
        let periodSeconds = seconds(period)
        guard periodSeconds > 0 else { return 0 }
        let t = date.timeIntervalSinceReferenceDate / periodSeconds
        return t - floor(t)
    }
}
