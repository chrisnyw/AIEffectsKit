//
//  AuroraRingIndicator.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct AuroraRingIndicator: View {
    let phase: AIStatePhase
    var message: String = "Ready when you are."

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            ZStack {
                staticRing
                bubble.padding(3)
            }
            .frame(width: 260, height: 92)
        } else {
            TimelineView(.animation) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                ZStack {
                    ring(t: t)
                    bubble.padding(3)
                }
                .frame(width: 260, height: 92)
            }
        }
    }

    private var staticRing: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(staticStrokeColor, lineWidth: 2)
            .opacity(ringOpacity)
    }

    private var staticStrokeColor: Color {
        phase == .error ? Color(.aiStateError) : Color(white: 0.45)
    }

    private var bubble: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(miniDotBackground)
                    .frame(width: 22, height: 22)
                Circle()
                    .fill(.primary.opacity(phase == .idle ? 0.45 : 0))
                    .frame(width: 10, height: 10)
            }
            Text(message)
                .font(.system(size: 13.5))
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(minHeight: 72)
        .background(
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    private func ring(t: TimeInterval) -> some View {
        let period = ringPeriodSeconds
        let progress: Double = period.map { p in
            (t.truncatingRemainder(dividingBy: p)) / p
        } ?? 0
        let bandCenter = -0.3 + progress * 1.6
        return RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(shimmerGradient(at: bandCenter), lineWidth: 2)
            .opacity(ringOpacity)
            .animation(.easeInOut(duration: 0.25), value: phase)
    }

    private func shimmerGradient(at center: Double) -> LinearGradient {
        let base: Color
        let bright: Color
        if phase == .error {
            base = Color(.aiStateError).opacity(0.35)
            bright = Color(.aiStateError)
        } else {
            base = Color(white: 0.30)
            bright = Color(white: 0.85)
        }
        return LinearGradient(
            stops: [
                .init(color: base, location: 0),
                .init(color: base, location: max(0, center - 0.18)),
                .init(color: bright, location: max(0, min(1, center))),
                .init(color: base, location: min(1, center + 0.18)),
                .init(color: base, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var ringPeriodSeconds: Double? {
        switch phase {
        case .idle, .done: return nil
        case .listening: return 3.5
        case .thinking: return 1.4
        case .streaming: return 2.4
        case .error: return 0.25
        }
    }

    private var ringOpacity: Double {
        switch phase {
        case .idle, .done: return 0.4
        default: return 1.0
        }
    }

    private var miniDotBackground: Color {
        switch phase {
        case .listening: return .primary
        case .done: return Color(.aiStateSuccess)
        case .error: return Color(.aiStateError)
        default: return Color(uiColor: .tertiarySystemGroupedBackground)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ForEach(AIStatePhase.allCases) { phase in
            AuroraRingIndicator(phase: phase, message: phase.auroraMessage)
        }
    }
    .padding()
}
