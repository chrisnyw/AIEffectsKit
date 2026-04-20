//
//  PrismIndicator.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct PrismIndicator: View {
    let phase: AIStatePhase
    var size: CGFloat = 68

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            staticPrism
                .frame(width: 140, height: 140)
        } else {
            TimelineView(.animation) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                ZStack {
                    trails(t: t)
                    prism(t: t)
                }
                .frame(width: 140, height: 140)
            }
        }
    }

    private var staticPrism: some View {
        settledShape
            .fill(fill)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(phase == .done ? 0 : 45))
    }

    private var settledShape: AnyShape {
        switch phase {
        case .done: return AnyShape(Circle())
        default: return AnyShape(Rectangle())
        }
    }

    @ViewBuilder
    private func prism(t: TimeInterval) -> some View {
        shape(t: t)
            .fill(fill)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation(t: t)))
            .scaleEffect(scale(t: t))
            .offset(x: shakeOffset(t: t))
            .animation(.easeInOut(duration: 0.5), value: phase)
    }

    private func shape(t: TimeInterval) -> AnyShape {
        if phase == .done {
            return AnyShape(Circle())
        } else if phase == .streaming {
            let period = 1.6
            let sine = sin(t / period * 2 * .pi)
            let cornerFrac = (sine + 1) / 2 * 0.24
            return AnyShape(RoundedRectangle(cornerRadius: size * cornerFrac, style: .continuous))
        }
        return AnyShape(Rectangle())
    }

    @ViewBuilder
    private func trails(t: TimeInterval) -> some View {
        if phase == .thinking {
            let period: Double = 1.0
            ForEach(0..<3) { i in
                let delay = Double(i) * 0.3
                let progress = ((t - delay).truncatingRemainder(dividingBy: period) + period)
                    .truncatingRemainder(dividingBy: period) / period
                Rectangle()
                    .stroke(Color.primary.opacity(0.6 * (1 - progress)), lineWidth: 1)
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(45 + progress * 360))
                    .scaleEffect(1 + progress * 0.5)
            }
        }
    }

    private var fill: LinearGradient {
        switch phase {
        case .done:
            return LinearGradient(
                colors: [
                    Color(red: 0.82, green: 0.93, blue: 0.85),
                    Color(.aiStateSuccess),
                    Color(.aiStateSuccessDeep)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .error:
            return LinearGradient(
                colors: [Color(.aiStateError), Color(.aiStateErrorDeep)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color(white: 0.30),
                    Color(white: 0.65),
                    Color(white: 0.92),
                    Color(white: 0.50)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func rotation(t: TimeInterval) -> Double {
        switch phase {
        case .listening:
            let period = 4.0
            return 45 + (t.truncatingRemainder(dividingBy: period)) / period * 360
        case .thinking:
            let period = 1.0
            return 45 + (t.truncatingRemainder(dividingBy: period)) / period * 360
        case .done:
            return 0
        default:
            return 45
        }
    }

    private func scale(t: TimeInterval) -> CGFloat {
        switch phase {
        case .streaming:
            let period = 1.6
            let sine = sin(t / period * 2 * .pi)
            return 1.0 - 0.08 * (sine + 1) / 2
        default:
            return 1.0
        }
    }

    private func shakeOffset(t: TimeInterval) -> CGFloat {
        guard phase == .error else { return 0 }
        let sine = sin(t * 6)
        return CGFloat(sine * 5)
    }
}

#Preview {
    HStack(spacing: 24) {
        ForEach(AIStatePhase.allCases) { phase in
            PrismIndicator(phase: phase)
        }
    }
    .padding()
}
