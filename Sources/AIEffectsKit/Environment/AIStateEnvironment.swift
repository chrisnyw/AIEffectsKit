//
//  AIStateEnvironment.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
    @Entry public var aiState: AIState? = nil
}

public extension View {
    func aiState(_ state: AIState) -> some View {
        environment(\.aiState, state)
    }
}
