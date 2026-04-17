//
//  LetterDropText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct LetterDropText: View {
    let text: String
    let duration: Duration

    @State private var chars: [TimedChar] = []

    var body: some View {
        TimelineView(.animation) { context in
            FlowLayout {
                ForEach(chars) { ch in
                    charView(ch: ch, now: context.date)
                }
            }
        }
        .onChange(of: text, initial: true) { _, new in
            chars = TimedChar.chars(from: new, reconciling: chars)
        }
    }

    @ViewBuilder
    private func charView(ch: TimedChar, now: Date) -> some View {
        let elapsed = now.timeIntervalSince(ch.arrivedAt)
        let p = max(0, min(1, elapsed / seconds(duration)))
        let eased = 1 - pow(1 - p, 3)
        Text(ch.text)
            .opacity(eased)
            .offset(y: (1 - eased) * -10)
    }
}

struct TimedChar: Identifiable, Equatable {
    let id: Int
    let text: String
    let arrivedAt: Date
}

extension TimedChar {
    static func chars(from accumulated: String, reconciling existing: [TimedChar], now: Date = Date()) -> [TimedChar] {
        var out: [TimedChar] = []
        let all = Array(accumulated)
        out.reserveCapacity(all.count)
        for (i, character) in all.enumerated() {
            let piece = String(character)
            if i < existing.count {
                out.append(existing[i])
            } else {
                out.append(TimedChar(id: i, text: piece, arrivedAt: now))
            }
        }
        return out
    }
}
