//
//  AIState.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation
import Observation

@Observable
@MainActor
public final class AIState {
    public var phase: AIPhase

    public init(phase: AIPhase = .idle) {
        self.phase = phase
    }
}
