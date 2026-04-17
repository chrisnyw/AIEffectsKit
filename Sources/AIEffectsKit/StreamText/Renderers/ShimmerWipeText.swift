//
//  ShimmerWipeText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct ShimmerWipeText: View {
    let text: String
    let duration: Duration

    @State private var words: [TimedWord] = []

    var body: some View {
        TimelineView(.animation) { context in
            FlowLayout {
                ForEach(words) { word in
                    wordView(word: word, now: context.date)
                }
            }
        }
        .onChange(of: text, initial: true) { _, new in
            words = TimedWord.words(from: new, reconciling: words)
        }
    }

    @ViewBuilder
    private func wordView(word: TimedWord, now: Date) -> some View {
        let elapsed = now.timeIntervalSince(word.arrivedAt)
        let total = seconds(duration)
        let p = max(0, min(1, elapsed / total))
        let offset = 1.2 - 1.4 * p

        Text(word.text)
            .foregroundStyle(
                LinearGradient(
                    stops: [
                        .init(color: .primary, location: max(0, offset - 0.4)),
                        .init(color: .primary, location: max(0, offset - 0.05)),
                        .init(color: .secondary, location: max(0, min(1, offset + 0.05))),
                        .init(color: .primary, location: min(1, offset + 0.15)),
                        .init(color: .primary, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .opacity(p > 0 ? 1 : 0)
    }
}
