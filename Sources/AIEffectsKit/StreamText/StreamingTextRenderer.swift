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
                let normalized = Double(distanceFromEnd) / Double(window)
                let wave = sin((phase - normalized) * .pi * 2)
                let pulse = 0.5 + 0.5 * wave
                let floor = 1 - shimmerStrength
                copy.opacity = floor + shimmerStrength * pulse
            }
            copy.draw(slice)
        }
    }
}
