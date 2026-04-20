//
//  PhaseRow.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct PhaseRow: View {
    let index: Int
    let candidate: AIStatePhase
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                PhaseRowMiniIndicator(phase: candidate, isActive: isActive)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(isActive ? Color.primary : Color(uiColor: .tertiarySystemGroupedBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .stroke(isActive ? Color.primary : Color(uiColor: .separator), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(candidate.title)
                        .font(.system(size: 15.5, weight: .medium))
                        .kerning(-0.15)
                        .foregroundStyle(.primary)
                    Text(candidate.subtitle.uppercased())
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .kerning(0.4)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                tickCircle
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(candidate.title)
        .accessibilityValue(isActive ? "Selected" : "")
        .accessibilityHint("Previews this phase")
    }

    private var tickCircle: some View {
        ZStack {
            Circle()
                .stroke(isActive ? Color.primary : Color(uiColor: .separator), lineWidth: 1.5)
                .background(Circle().fill(isActive ? Color.primary : Color.clear))
                .frame(width: 22, height: 22)
            if isActive {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .systemBackground))
            }
        }
    }
}

private struct PhaseRowMiniIndicator: View {
    let phase: AIStatePhase
    let isActive: Bool

    var body: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            indicator(t: t)
        }
    }

    @ViewBuilder
    private func indicator(t: TimeInterval) -> some View {
        let color = activeTint
        switch phase {
        case .idle:
            Circle().fill(color).frame(width: 10, height: 10)
        case .listening:
            let period = 1.0
            let sine = sin(t / period * 2 * .pi)
            let scale = 1.0 + 0.6 * (sine + 1) / 2
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .scaleEffect(scale)
                .opacity(1 - 0.45 * (sine + 1) / 2)
        case .thinking:
            let period = 0.9
            let rotation = (t.truncatingRemainder(dividingBy: period)) / period * 360
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
                .frame(width: 12, height: 12)
                .rotationEffect(.degrees(rotation))
        case .streaming:
            let period = 1.0
            let sine = sin(t / period * 2 * .pi)
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .scaleEffect(0.7 + 0.5 * (sine + 1) / 2)
        case .done:
            Circle().fill(Color(.aiStateSuccess)).frame(width: 10, height: 10)
        case .error:
            Circle().fill(Color(.aiStateError)).frame(width: 10, height: 10)
        }
    }

    private var activeTint: Color {
        if isActive {
            return Color(uiColor: .systemBackground)
        }
        switch phase {
        case .listening, .thinking, .streaming: return .primary
        default: return .secondary
        }
    }
}
