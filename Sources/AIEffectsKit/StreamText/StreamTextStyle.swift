//
//  StreamTextStyle.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

public enum StreamTextStyle: Sendable, Equatable {
    case trailingShimmer(
        window: Int = 10,
        strength: Double = 0.5,
        period: Duration = .milliseconds(1200)
    )
    case typewriter(caret: Bool = true)
    case wordReveal(stagger: Duration = .milliseconds(55), duration: Duration = .milliseconds(220))
    case tokenChunks(stagger: Duration = .milliseconds(60), duration: Duration = .milliseconds(780))
    case fadeRise(stagger: Duration = .milliseconds(70), duration: Duration = .milliseconds(320))
    case blurFocus(stagger: Duration = .milliseconds(95), duration: Duration = .milliseconds(420))
    case shimmerWipe(stagger: Duration = .milliseconds(95), duration: Duration = .milliseconds(950))
    case skeleton(stagger: Duration = .milliseconds(70), settleDuration: Duration = .milliseconds(200))
    case scramble(advanceInterval: Duration = .milliseconds(40), advanceProbability: Double = 0.55)
    case letterDrop(stagger: Duration = .milliseconds(22), duration: Duration = .milliseconds(240))
    case lineCascade(stagger: Duration = .milliseconds(420), duration: Duration = .milliseconds(400))
}
