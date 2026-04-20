//
//  OrbIndicator.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct OrbIndicator: View {
    let phase: AIStatePhase
    var diameter: CGFloat = 100

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            staticOrb
        } else {
            animatedOrb
        }
    }

    private var staticOrb: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: orbColors,
                        center: UnitPoint(x: 0.35, y: 0.32),
                        startRadius: 0,
                        endRadius: diameter * 0.8
                    )
                )
            if phase == .done {
                Image(systemName: "checkmark")
                    .font(.system(size: diameter * 0.35, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private var animatedOrb: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            ZStack {
                pulseWaves(t: t)
                baseOrb(t: t)
                ring(t: t)
                if phase == .done {
                    Image(systemName: "checkmark")
                        .font(.system(size: diameter * 0.35, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: diameter, height: diameter)
        }
    }

    @ViewBuilder
    private func baseOrb(t: TimeInterval) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: orbColors,
                    center: UnitPoint(x: 0.35, y: 0.32),
                    startRadius: 0,
                    endRadius: diameter * 0.8
                )
            )
            .overlay(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.5), .clear],
                            center: UnitPoint(x: 0.3, y: 0.25),
                            startRadius: 0,
                            endRadius: diameter * 0.35
                        )
                    )
                    .blendMode(.plusLighter)
            )
            .scaleEffect(orbScale(t: t))
            .rotationEffect(orbRotation(t: t))
            .offset(x: shakeOffset(t: t))
            .animation(.easeInOut(duration: 0.6), value: phase)
    }

    @ViewBuilder
    private func ring(t: TimeInterval) -> some View {
        let visible = phase == .thinking || phase == .streaming
        let period: Double = phase == .thinking ? 1.6 : 3.2
        let angle = (t.truncatingRemainder(dividingBy: period)) / period * 360
        Circle()
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .primary, location: 0.16),
                        .init(color: .clear, location: 0.33),
                        .init(color: .clear, location: 0.66),
                        .init(color: .primary.opacity(0.6), location: 0.83),
                        .init(color: .clear, location: 1)
                    ]),
                    center: .center
                ),
                lineWidth: 2
            )
            .rotationEffect(.degrees(angle))
            .padding(-8)
            .opacity(visible ? (phase == .streaming ? 0.6 : 1) : 0)
            .animation(.easeInOut(duration: 0.3), value: phase)
    }

    @ViewBuilder
    private func pulseWaves(t: TimeInterval) -> some View {
        if phase == .streaming {
            ForEach(0..<3) { i in
                let cyclePeriod: Double = 1.4
                let delay = Double(i) * cyclePeriod / 3
                let elapsed = (t + cyclePeriod - delay).truncatingRemainder(dividingBy: cyclePeriod)
                let p = elapsed / cyclePeriod
                Circle()
                    .stroke(Color.primary.opacity(0.6 * (1 - p)), lineWidth: 1.5)
                    .scaleEffect(1 + p * 0.95)
            }
            .frame(width: diameter, height: diameter)
        }
    }

    // MARK: - Per-phase parameters

    private var orbColors: [Color] {
        switch phase {
        case .done:
            return [
                Color(red: 0.82, green: 0.93, blue: 0.85),
                Color(.aiStateSuccess),
                Color(.aiStateSuccessDeep)
            ]
        case .error:
            return [
                Color(white: 0.94),
                Color(.aiStateError),
                Color(.aiStateErrorDeep)
            ]
        default:
            return [
                Color(white: 0.96),
                Color(white: 0.72),
                Color(white: 0.22)
            ]
        }
    }

    private func orbScale(t: TimeInterval) -> CGFloat {
        switch phase {
        case .listening:
            let period = 2.2
            let sine = sin(t / period * 2 * .pi)
            return 1.0 + 0.04 * (sine + 1) / 2 + 0.04
        case .thinking:
            let period = 1.6
            let sine = sin(t / period * 2 * .pi)
            return 0.97 + 0.05 * sine
        case .streaming:
            let period = 1.2
            let sine = sin(t / period * 2 * .pi)
            return 1.0 + 0.03 * (sine + 1)
        default:
            return 1.0
        }
    }

    private func orbRotation(t: TimeInterval) -> Angle {
        if phase == .thinking {
            let period = 1.6
            let progress = (t.truncatingRemainder(dividingBy: period)) / period
            return .degrees(progress * 360)
        }
        return .degrees(0)
    }

    private func shakeOffset(t: TimeInterval) -> CGFloat {
        guard phase == .error else { return 0 }
        let period = 0.8
        let progress = (t.truncatingRemainder(dividingBy: period)) / period
        let sine = sin(progress * 6 * .pi)
        return CGFloat(sine * 5)
    }
}

#Preview {
    VStack(spacing: 40) {
        ForEach(AIStatePhase.allCases) { phase in
            HStack(spacing: 20) {
                OrbIndicator(phase: phase, diameter: 80)
                Text(phase.title)
                    .font(.caption.monospaced())
            }
        }
    }
    .padding()
}
