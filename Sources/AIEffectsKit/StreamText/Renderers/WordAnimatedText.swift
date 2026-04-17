//
//  WordAnimatedText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct WordAnimatedText: View {
    let text: String
    let style: StreamTextStyle

    @State private var words: [TimedWord] = []

    var body: some View {
        let total = durationSeconds
        TimelineView(.animation) { context in
            FlowLayout {
                ForEach(words) { word in
                    wordView(word: word, progress: progress(for: word, now: context.date, total: total))
                }
            }
        }
        .onChange(of: text, initial: true) { _, new in
            words = TimedWord.words(from: new, reconciling: words)
        }
    }

    private func progress(for word: TimedWord, now: Date, total: Double) -> Double {
        guard total > 0 else { return 1 }
        let elapsed = now.timeIntervalSince(word.arrivedAt)
        return min(1, max(0, elapsed / total))
    }

    @ViewBuilder
    private func wordView(word: TimedWord, progress p: Double) -> some View {
        let eased = smoothstep(p)
        switch style {
        case .wordReveal:
            Text(word.text)
                .opacity(eased)
                .offset(y: (1 - eased) * 2)
        case .fadeRise:
            Text(word.text)
                .opacity(eased)
                .offset(y: (1 - eased) * 6)
                .blur(radius: (1 - eased) * 1)
        case .blurFocus:
            Text(word.text)
                .opacity(eased)
                .blur(radius: (1 - eased) * 6)
                .scaleEffect(1 + (1 - eased) * 0.04)
        default:
            Text(word.text)
        }
    }

    private var durationSeconds: Double {
        switch style {
        case .wordReveal(_, let d), .fadeRise(_, let d), .blurFocus(_, let d):
            return seconds(d)
        default:
            return seconds(.milliseconds(200))
        }
    }

    private func smoothstep(_ t: Double) -> Double {
        let x = min(1, max(0, t))
        return x * x * (3 - 2 * x)
    }
}
