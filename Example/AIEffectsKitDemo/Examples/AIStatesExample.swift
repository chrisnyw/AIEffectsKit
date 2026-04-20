//
//  AIStatesExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct AIStatesExample: View {
    @AppStorage("ai-states-phase") private var phaseRaw: String = AIStatePhase.idle.rawValue
    @AppStorage("ai-states-indicator") private var indicatorRaw: String = IndicatorStyle.orb.rawValue
    @State private var replayToken: Int = 0

    private var phase: AIStatePhase {
        AIStatePhase(rawValue: phaseRaw) ?? .idle
    }
    private var indicator: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorRaw) ?? .orb
    }

    private var phaseIndex: Int {
        AIStatePhase.allCases.firstIndex(of: phase) ?? 0
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                indicatorPicker
                preview
                sectionHeader
                rowList
                Spacer().frame(height: 32)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("AI states")
    }

    // MARK: - Sections

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SETTINGS")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .kerning(1)
                    .foregroundStyle(.secondary)
                Text("AI States")
                    .font(.system(size: 28, weight: .semibold))
                    .kerning(-0.3)
            }
            Spacer()
            Text("\(phaseIndex + 1)/\(AIStatePhase.allCases.count)")
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private var indicatorPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("INDICATOR")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .kerning(0.8)
                .foregroundStyle(.secondary)

            segmentedControl

            HStack(spacing: 6) {
                Text(indicator.numericLabel)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text(indicator.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.primary)
                Text("·")
                    .foregroundStyle(.secondary)
                Text(indicator.tagline)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }

    private var segmentedControl: some View {
        HStack(spacing: 4) {
            ForEach(IndicatorStyle.allCases) { style in
                let isSelected = style == indicator
                Button {
                    indicatorRaw = style.rawValue
                    replayToken += 1
                } label: {
                    IndicatorThumbnail(style: style, isSelected: isSelected)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(isSelected ? Color.primary : Color(uiColor: .tertiarySystemGroupedBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(isSelected ? Color.primary : Color(uiColor: .separator), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(style.displayName)
                .accessibilityValue(isSelected ? "Selected" : "")
            }
        }
    }

    private var preview: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 6) {
                    Circle().fill(tagDotColor).frame(width: 6, height: 6)
                    Text("SAMPLE")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .kerning(0.6)
                        .foregroundStyle(.secondary)
                }

                demoArea

                stateCopy

                HStack {
                    Text("\(String(format: "%02d", phaseIndex + 1)) · \(phase.title)")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .kerning(0.6)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Spacer()
                    replayButton
                }
                .padding(.top, 8)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(height: 0.5)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Text("PREVIEW")
                .font(.system(size: 9.5, weight: .regular, design: .monospaced))
                .kerning(1)
                .foregroundStyle(.secondary)
                .padding(.top, 22)
                .padding(.trailing, 30)
        }
    }

    private var demoArea: some View {
        Group {
            switch indicator {
            case .orb:
                OrbIndicator(phase: phase)
            case .aurora:
                AuroraRingIndicator(phase: phase, message: phase.auroraMessage)
            case .waveform:
                WaveformIndicator(phase: phase)
            case .prism:
                PrismIndicator(phase: phase)
            case .chip:
                StatusChipIndicator(phase: phase)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 160)
        .id(replayToken)
    }

    private var stateCopy: some View {
        VStack(spacing: 4) {
            Text(phase.primaryCopy)
                .font(.system(size: 15, weight: .medium))
                .kerning(-0.15)
                .foregroundStyle(.primary)
            Text(phase.secondaryCopy.uppercased())
                .font(.system(size: 10.5, weight: .regular, design: .monospaced))
                .kerning(0.6)
                .foregroundStyle(secondaryCopyColor)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 38)
    }

    private var replayButton: some View {
        Button {
            replayToken += 1
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 10, weight: .medium))
                Text("REPLAY")
                    .font(.system(size: 10.5, weight: .regular, design: .monospaced))
                    .kerning(0.5)
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color(uiColor: .tertiarySystemGroupedBackground)))
            .overlay(Capsule().stroke(Color(uiColor: .separator), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Replay animation")
    }

    private var sectionHeader: some View {
        HStack {
            Text("PHASES")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .kerning(1)
            Spacer()
            Text("\(AIStatePhase.allCases.count)")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var rowList: some View {
        VStack(spacing: 0) {
            ForEach(Array(AIStatePhase.allCases.enumerated()), id: \.element.id) { index, candidate in
                PhaseRow(
                    index: index,
                    candidate: candidate,
                    isActive: candidate == phase,
                    onTap: {
                        phaseRaw = candidate.rawValue
                        replayToken += 1
                    }
                )
                if index < AIStatePhase.allCases.count - 1 {
                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(height: 0.5)
                        .padding(.leading, 56)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .padding(.horizontal, 16)
    }

    private var tagDotColor: Color {
        switch phase {
        case .done: return Color(.aiStateSuccess)
        case .error: return Color(.aiStateError)
        default: return .primary
        }
    }

    private var secondaryCopyColor: Color {
        switch phase {
        case .done: return Color(.aiStateSuccessDeep)
        case .error: return Color(.aiStateErrorDeep)
        default: return .secondary
        }
    }
}

#Preview {
    NavigationStack { AIStatesExample() }
}
