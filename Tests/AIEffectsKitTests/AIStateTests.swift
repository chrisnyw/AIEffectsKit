//
//  AIStateTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
@testable import AIEffectsKit

@MainActor
struct AIStateTests {
    @Test func defaultsToIdle() {
        let state = AIState()
        #expect(state.phase == .idle)
        #expect(state.phase.isActive == false)
    }

    @Test func activePhasesReportActive() {
        #expect(AIPhase.listening.isActive)
        #expect(AIPhase.thinking.isActive)
        #expect(AIPhase.streaming.isActive)
    }

    @Test func terminalPhasesReportInactive() {
        #expect(AIPhase.idle.isActive == false)
        #expect(AIPhase.done.isActive == false)
        #expect(AIPhase.error("oops").isActive == false)
    }

    @Test func phaseMutationUpdatesState() {
        let state = AIState()
        state.phase = .streaming
        #expect(state.phase == .streaming)
        state.phase = .error("boom")
        #expect(state.phase == .error("boom"))
    }
}
