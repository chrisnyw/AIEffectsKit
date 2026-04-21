//
//  IntelligenceGlowViewModel.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

/// Holds the tweakable parameters for the IntelligenceGlow modifier demo.
/// Intentionally ephemeral: no persistence, since the screen is a tuning
/// surface rather than a saved configuration. Exists to keep the view free of
/// stored state and to give the pattern room to grow if we later want to
/// persist presets or expose named shareable tunings.
@Observable
@MainActor
final class IntelligenceGlowViewModel {
    var isActive: Bool
    var palette: GlowPalette
    var lineWidth: Double
    var cornerRadius: Double

    init(
        isActive: Bool = true,
        palette: GlowPalette = .aurora,
        lineWidth: Double = 2,
        cornerRadius: Double = 20
    ) {
        self.isActive = isActive
        self.palette = palette
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
}
