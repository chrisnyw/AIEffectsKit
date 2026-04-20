//
//  WaveformIndicator.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct WaveformIndicator: View {
    let phase: AIStatePhase
    var barCount: Int = 12
    var maxHeight: CGFloat = 60
    var barWidth: CGFloat = 6
    var spacing: CGFloat = 5

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            HStack(spacing: spacing) {
                ForEach(0..<barCount, id: \.self) { index in
                    Capsule()
                        .fill(barColor)
                        .frame(width: barWidth, height: staticHeight(index: index))
                }
            }
            .frame(height: maxHeight + 12, alignment: .center)
        } else {
            TimelineView(.animation) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                HStack(spacing: spacing) {
                    ForEach(0..<barCount, id: \.self) { index in
                        Capsule()
                            .fill(barColor)
                            .frame(width: barWidth, height: height(index: index, t: t))
                    }
                }
                .frame(height: maxHeight + 12, alignment: .center)
            }
        }
    }

    private func height(index: Int, t: TimeInterval) -> CGFloat {
        let base: CGFloat = 8
        switch phase {
        case .idle:
            return base
        case .listening:
            let period = 0.9
            let offset = Double(index) * 0.15
            let sine = sin((t - offset) / period * 2 * .pi)
            return 12 + (CGFloat(sine + 1) / 2) * (maxHeight - 12)
        case .thinking:
            let period: Double = (index % 2 == 0) ? 0.8 : (index % 3 == 0 ? 1.4 : 1.0)
            let offset = Double(index) * 0.11
            let sine = sin((t - offset) / period * 2 * .pi)
            return 10 + (CGFloat(sine + 1) / 2) * (maxHeight - 12)
        case .streaming:
            let period = 1.4
            let offset = Double(index) * 0.08
            let progress = ((t - offset).truncatingRemainder(dividingBy: period) + period)
                .truncatingRemainder(dividingBy: period) / period
            let eased = sin(progress * .pi)
            return 10 + CGFloat(eased) * (maxHeight - 12) * 0.9
        case .done:
            return 3
        case .error:
            let period = 0.5
            let sine = sin(t / period * 2 * .pi)
            return 10 + (CGFloat(sine + 1) / 2) * 26
        }
    }

    private func staticHeight(index: Int) -> CGFloat {
        switch phase {
        case .idle: return 8
        case .done: return 3
        case .listening, .thinking, .streaming, .error:
            let pattern: [CGFloat] = [14, 28, 18, 42, 24, 36, 30, 46, 22, 34, 16, 24]
            return pattern[index % pattern.count]
        }
    }

    private var barColor: Color {
        switch phase {
        case .done: return Color(.aiStateSuccess)
        case .error: return Color(.aiStateError)
        default: return .primary
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ForEach(AIStatePhase.allCases) { phase in
            WaveformIndicator(phase: phase)
        }
    }
    .padding()
}
