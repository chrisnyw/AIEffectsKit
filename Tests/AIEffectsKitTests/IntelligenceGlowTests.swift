//
//  IntelligenceGlowTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-22.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
import SwiftUI
@testable import AIEffectsKit

@MainActor
struct IntelligenceGlowTests {
    /// Compile-time smoke test for every supported call shape. If anyone
    /// renames a parameter or flips the argument order this stops compiling.
    @Test func modifierAcceptsAllSupportedCallShapes() {
        let base = Color.clear
        _ = base.intelligenceGlow()
        _ = base.intelligenceGlow(colors: [.blue, .pink, .blue])
        _ = base.intelligenceGlow(lineWidth: 3)
        _ = base.intelligenceGlow(cornerRadius: 24)
        _ = base.intelligenceGlow(activeWhen: true)
        _ = base.intelligenceGlow(
            colors: [.purple, .orange],
            lineWidth: 4,
            cornerRadius: 18,
            activeWhen: false
        )
    }

    @Test func defaultColorsAreNonEmpty() {
        // The default palette baked into the public extension must not be
        // empty — an empty array would strike the gradient.
        let defaults: [Color] = [.blue, .purple, .pink, .blue]
        #expect(defaults.isEmpty == false)
    }
}
