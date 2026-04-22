//
//  IntelligenceGlowViewModel.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

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

    /// Remembered custom color. Kept on the VM (rather than only inside the
    /// `.custom` case's associated value) so switching away from Custom and
    /// back doesn't lose the user's pick.
    var customColor: Color {
        didSet {
            if case .custom = palette {
                palette = .custom(customColor)
            }
        }
    }

    var lineWidth: Double
    var cornerRadius: Double

    /// Picker-friendly discriminator. Writing to this swaps `palette` to the
    /// matching case, passing the remembered `customColor` for `.custom`.
    var paletteKind: GlowPalette.Kind {
        get { palette.kind }
        set {
            switch newValue {
            case .aurora: palette = .aurora
            case .sunset: palette = .sunset
            case .forest: palette = .forest
            case .mono: palette = .mono
            case .custom: palette = .custom(customColor)
            }
        }
    }

    init(
        isActive: Bool = true,
        palette: GlowPalette = .aurora,
        customColor: Color = .cyan,
        lineWidth: Double = 2,
        cornerRadius: Double = 20
    ) {
        self.isActive = isActive
        self.palette = palette
        self.customColor = customColor
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
}
