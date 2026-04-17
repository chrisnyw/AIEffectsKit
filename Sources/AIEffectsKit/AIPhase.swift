//
//  AIPhase.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

public enum AIPhase: Sendable, Hashable {
    case idle
    case listening
    case thinking
    case streaming
    case done
    case error(String)
}

public extension AIPhase {
    var isActive: Bool {
        switch self {
        case .listening, .thinking, .streaming: return true
        case .idle, .done, .error: return false
        }
    }
}
