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
    private let shimmerWindow: Int
    private let shimmerStrength: Double
    private let shimmerPeriod: Duration

    @State private var accumulated: String = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(
        _ source: Source,
        shimmerWindow: Int = 10,
        shimmerStrength: Double = 0.5,
        shimmerPeriod: Duration = .milliseconds(1200)
    ) {
        self.source = source
        self.shimmerWindow = shimmerWindow
        self.shimmerStrength = shimmerStrength
        self.shimmerPeriod = shimmerPeriod
    }

    public var body: some View {
        content
            .task {
                await consume()
            }
    }

    @ViewBuilder private var content: some View {
        if prefersStatic {
            Text(accumulated)
        } else if #available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *) {
            modernContent
        } else {
            fallbackContent
        }
    }

    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *)
    private var modernContent: some View {
        TimelineView(.animation) { context in
            let phase = phaseValue(at: context.date)
            Text(accumulated)
                .textRenderer(
                    StreamingTextRenderer(
                        phase: phase,
                        shimmerWindow: shimmerWindow,
                        shimmerStrength: shimmerStrength
                    )
                )
        }
    }

    private var fallbackContent: some View {
        Text(accumulated)
            .animation(.easeOut(duration: 0.2), value: accumulated)
    }

    private var prefersStatic: Bool {
        reduceMotion
            || reduceTransparency
            || ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    private func phaseValue(at date: Date) -> Double {
        let periodSeconds = Double(shimmerPeriod.components.seconds)
            + Double(shimmerPeriod.components.attoseconds) / 1e18
        guard periodSeconds > 0 else { return 0 }
        let t = date.timeIntervalSinceReferenceDate / periodSeconds
        return t - floor(t)
    }

    private func consume() async {
        do {
            for try await token in source {
                accumulated.append(token)
            }
        } catch {
            // Prototype: surface errors through AIState in a later phase.
        }
    }
}
