//
//  StreamTextStyleChoice.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation
import AIEffectsKit

/// User-facing picker options for the ten built-in `StreamTextStyle` cases.
/// The raw value is persisted in UserDefaults; use `style` to materialise a
/// fresh `StreamTextStyle` instance with its default parameters.
enum StreamTextStyleChoice: String, CaseIterable, Identifiable {
    case trailingShimmer, typewriter, wordReveal, tokenChunks, fadeRise,
         blurFocus, shimmerWipe, skeleton, scramble, letterDrop, lineCascade

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .trailingShimmer: "Trailing shimmer"
        case .typewriter: "Typewriter"
        case .wordReveal: "Word reveal"
        case .tokenChunks: "Token chunks"
        case .fadeRise: "Fade + rise"
        case .blurFocus: "Blur to focus"
        case .shimmerWipe: "Shimmer wipe"
        case .skeleton: "Skeleton"
        case .scramble: "Scramble"
        case .letterDrop: "Letter drop"
        case .lineCascade: "Line cascade"
        }
    }

    var style: StreamTextStyle {
        switch self {
        case .trailingShimmer: .trailingShimmer()
        case .typewriter: .typewriter()
        case .wordReveal: .wordReveal()
        case .tokenChunks: .tokenChunks()
        case .fadeRise: .fadeRise()
        case .blurFocus: .blurFocus()
        case .shimmerWipe: .shimmerWipe()
        case .skeleton: .skeleton()
        case .scramble: .scramble()
        case .letterDrop: .letterDrop()
        case .lineCascade: .lineCascade()
        }
    }
}
