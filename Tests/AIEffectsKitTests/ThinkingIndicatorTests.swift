//
//  ThinkingIndicatorTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
@testable import AIEffectsKit

@MainActor
struct ThinkingIndicatorTests {
    @Test func initAllowsCustomConfiguration() {
        _ = ThinkingIndicator()
        _ = ThinkingIndicator(dotCount: 5)
        _ = ThinkingIndicator(dotCount: 3, dotSize: 10, spacing: 8, period: .milliseconds(800))
    }

    @Test func phaseIsActiveForThinkingOnly() {
        #expect(AIPhase.thinking.isActive)
        #expect(AIPhase.idle.isActive == false)
        #expect(AIPhase.done.isActive == false)
    }
}
