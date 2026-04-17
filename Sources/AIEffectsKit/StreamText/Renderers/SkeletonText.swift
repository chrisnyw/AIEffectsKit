//
//  SkeletonText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct SkeletonText: View {
    let text: String
    let settleDuration: Duration

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
        let isSettled = elapsed >= seconds(settleDuration)
        let phase = skeletonPhase(now: now)

        Text(word.text)
            .opacity(isSettled ? 1 : 0)
            .padding(.horizontal, 1)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .fill(skeletonGradient(phase: phase))
                    .padding(.vertical, 2)
                    .opacity(isSettled ? 0 : 1)
            }
            .animation(.easeOut(duration: 0.2), value: isSettled)
    }

    private func skeletonPhase(now: Date) -> Double {
        let t = now.timeIntervalSinceReferenceDate / 1.2
        return t - floor(t)
    }

    private func skeletonGradient(phase: Double) -> LinearGradient {
        let shift = -1.0 + 2.0 * phase
        return LinearGradient(
            stops: [
                .init(color: .primary.opacity(0.15), location: max(0, shift)),
                .init(color: .primary.opacity(0.25), location: max(0, min(1, shift + 0.5))),
                .init(color: .primary.opacity(0.15), location: min(1, shift + 1))
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
