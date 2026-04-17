//
//  StreamingTextRenderer.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *)
struct StreamingTextRenderer: TextRenderer {
    var phase: Double
    var shimmerWindow: Int
    var shimmerStrength: Double

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        var slices: [Text.Layout.RunSlice] = []
        for line in layout {
            for run in line {
                for slice in run {
                    slices.append(slice)
                }
            }
        }

        let total = slices.count
        guard total > 0 else { return }
        let window = max(1, shimmerWindow)

        for (index, slice) in slices.enumerated() {
            var copy = context
            let distanceFromEnd = total - 1 - index
            if distanceFromEnd < window {
                let t = Double(distanceFromEnd) / Double(window)
                let fadeIn = 0.35 + 0.65 * smoothstep(t)
                let wave = sin((phase - t) * .pi * 2)
                let pulse = 0.5 + 0.5 * wave
                let settled = fadeIn * (1 - shimmerStrength)
                let shimmer = shimmerStrength * (1 - t) * pulse
                copy.opacity = min(1, max(0, settled + shimmer))
            }
            copy.draw(slice)
        }
    }

    private func smoothstep(_ t: Double) -> Double {
        let x = min(1, max(0, t))
        return x * x * (3 - 2 * x)
    }
}
