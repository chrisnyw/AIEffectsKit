//
//  StatusChipIndicator.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct StatusChipIndicator: View {
    let phase: AIStatePhase

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            chip
            Text(phase.badgeSupport)
                .font(.system(size: 10.5, weight: .regular, design: .monospaced))
                .kerning(0.4)
                .foregroundStyle(.secondary)
                .frame(minHeight: 14)
        }
    }

    private var chip: some View {
        Group {
            if reduceMotion {
                chipBody(staticIcon: true, shimmerOffsetX: nil, shakeX: 0, scale: 1)
            } else {
                TimelineView(.animation) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    chipBody(
                        staticIcon: false,
                        shimmerOffsetX: phase == .thinking ? shimmerOffset(t: t) : nil,
                        shakeX: shakeOffset(t: t),
                        scale: bouncyScale(t: t),
                        t: t
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func chipBody(
        staticIcon: Bool,
        shimmerOffsetX: CGFloat?,
        shakeX: CGFloat,
        scale: CGFloat,
        t: TimeInterval = 0
    ) -> some View {
        HStack(spacing: 10) {
            iconDot(t: t, forceStatic: staticIcon)
                .frame(width: 18, height: 18)
            Text(phase.badgeText.uppercased())
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .kerning(0.5)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(
            Capsule().fill(chipBackground)
        )
        .overlay(
            Capsule().stroke(chipBorder, lineWidth: 1)
        )
        .overlay(alignment: .center) {
            if let offset = shimmerOffsetX {
                Capsule()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: Color(uiColor: .separator), location: 0.5),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 120)
                    .offset(x: offset)
                    .allowsHitTesting(false)
            }
        }
        .foregroundStyle(chipForeground)
        .offset(x: shakeX)
        .scaleEffect(scale)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private func iconDot(t: TimeInterval, forceStatic: Bool) -> some View {
        switch phase {
        case .idle:
            Circle().fill(Color.secondary).frame(width: 8, height: 8)
        case .listening:
            if forceStatic {
                Circle().fill(Color(uiColor: .systemBackground)).frame(width: 8, height: 8)
            } else {
                let period = 0.9
                let sine = sin(t / period * 2 * .pi)
                let scale = 1.0 + 0.3 * (sine + 1) / 2
                Circle().fill(Color(uiColor: .systemBackground))
                    .frame(width: 8, height: 8)
                    .scaleEffect(scale)
                    .opacity(1 - 0.3 * (sine + 1) / 2)
            }
        case .thinking:
            if forceStatic {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(Color.primary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 10, height: 10)
            } else {
                let period = 0.9
                let rotation = (t.truncatingRemainder(dividingBy: period)) / period * 360
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(Color.primary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 10, height: 10)
                    .rotationEffect(.degrees(rotation))
            }
        case .streaming:
            if forceStatic {
                Circle().fill(Color.primary).frame(width: 8, height: 8)
            } else {
                let period = 1.0
                let sine = sin(t / period * 2 * .pi)
                Circle().fill(Color.primary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(0.8 + 0.4 * (sine + 1) / 2)
            }
        case .done:
            Circle().fill(Color(.aiStateSuccess)).frame(width: 8, height: 8)
        case .error:
            Circle().fill(Color(.aiStateError)).frame(width: 8, height: 8)
        }
    }

    private func shimmerOffset(t: TimeInterval) -> CGFloat {
        let period = 1.4
        let progress = (t.truncatingRemainder(dividingBy: period)) / period
        return -120 + CGFloat(progress) * 240
    }

    private func shakeOffset(t: TimeInterval) -> CGFloat {
        guard phase == .error else { return 0 }
        let sine = sin(t * 8)
        let window = sin(t * 0.8) * 0.5 + 0.5
        return CGFloat(sine * 3) * CGFloat(window)
    }

    private func bouncyScale(t: TimeInterval) -> CGFloat {
        guard phase == .done else { return 1 }
        let age = t.truncatingRemainder(dividingBy: 3)
        guard age < 0.4 else { return 1 }
        let progress = age / 0.4
        let bounce = sin(progress * .pi) * 0.06
        return 1 + CGFloat(bounce)
    }

    private var chipBackground: Color {
        switch phase {
        case .listening:
            return .primary
        case .done:
            return Color(red: 0.92, green: 0.96, blue: 0.89)
        case .error:
            return Color(red: 0.98, green: 0.90, blue: 0.90)
        default:
            return Color(uiColor: .secondarySystemGroupedBackground)
        }
    }

    private var chipBorder: Color {
        switch phase {
        case .listening: return .primary
        case .streaming: return .secondary
        case .done: return Color(red: 0.72, green: 0.85, blue: 0.71)
        case .error: return Color(red: 0.88, green: 0.70, blue: 0.68)
        default: return Color(uiColor: .separator)
        }
    }

    private var chipForeground: Color {
        switch phase {
        case .listening: return Color(uiColor: .systemBackground)
        case .idle: return .secondary
        case .done: return Color(.aiStateSuccessDeep)
        case .error: return Color(.aiStateErrorDeep)
        default: return .primary
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ForEach(AIStatePhase.allCases) { phase in
            StatusChipIndicator(phase: phase)
        }
    }
    .padding()
}
