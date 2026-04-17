//
//  ScrambleText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Combine
import SwiftUI

struct ScrambleText: View {
    let text: String
    let advanceInterval: Duration
    let advanceProbability: Double

    @State private var lockedCount: Int = 0
    @State private var tailSeed: UInt64 = 0

    private let glyphs: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%&*+=-/<>")

    var body: some View {
        Text(display)
            .font(.system(.body, design: .monospaced))
            .onReceive(tickTimer) { _ in tick() }
    }

    private var display: String {
        let chars = Array(text)
        let locked = String(chars.prefix(lockedCount))
        let remaining = max(0, chars.count - lockedCount)
        let tailLen = min(4, remaining)
        var rng = SplitMix64(seed: tailSeed)
        let tail = (0..<tailLen).map { offset -> Character in
            let target = chars[lockedCount + offset]
            if target.isWhitespace { return target }
            return glyphs[Int(rng.next() % UInt64(glyphs.count))]
        }
        return locked + String(tail)
    }

    private var tickTimer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(
            every: seconds(advanceInterval),
            on: .main,
            in: .common
        ).autoconnect()
    }

    private func tick() {
        tailSeed &+= 1
        if lockedCount < text.count, Double.random(in: 0..<1) < advanceProbability {
            lockedCount += 1
        }
    }
}

private struct SplitMix64 {
    var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
