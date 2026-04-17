//
//  EffectsEnvironment.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

public struct EffectsEnvironment: Equatable, Sendable {
    public var reduceMotion: Bool
    public var reduceTransparency: Bool
    public var lowPowerMode: Bool

    public init(
        reduceMotion: Bool = false,
        reduceTransparency: Bool = false,
        lowPowerMode: Bool = false
    ) {
        self.reduceMotion = reduceMotion
        self.reduceTransparency = reduceTransparency
        self.lowPowerMode = lowPowerMode
    }

    public var prefersStaticRendering: Bool {
        reduceMotion || lowPowerMode
    }

    public var prefersOpaqueRendering: Bool {
        reduceTransparency
    }
}

struct EffectsEnvironmentReader<Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let content: (EffectsEnvironment) -> Content

    var body: some View {
        content(
            EffectsEnvironment(
                reduceMotion: reduceMotion,
                reduceTransparency: reduceTransparency,
                lowPowerMode: ProcessInfo.processInfo.isLowPowerModeEnabled
            )
        )
    }
}
