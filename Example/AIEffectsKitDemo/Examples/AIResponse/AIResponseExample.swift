//
//  AIResponseExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-20.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct AIResponseExample: View {
    @State private var model = AIResponseViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                indicatorHeader
                streamSection
                controls
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("AI response")
        .navigationBarTitleDisplayMode(.inline)
        .aiState(model.aiState)
        .task(id: model.runToken) {
            await model.runFlow()
        }
    }

    // MARK: - Sections

    private var indicatorHeader: some View {
        VStack(spacing: 12) {
            indicatorView
                .frame(minHeight: 140)
                .animation(.smooth(duration: 0.35), value: model.phase)
            VStack(spacing: 4) {
                Text(model.phase.primaryCopy)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                    .contentTransition(.opacity)
                Text(model.phase.secondaryCopy.uppercased())
                    .font(.system(size: 10.5, weight: .regular, design: .monospaced))
                    .kerning(0.6)
                    .foregroundStyle(copySecondaryColor)
                    .contentTransition(.opacity)
            }
            .animation(.easeInOut(duration: 0.3), value: model.phase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    @ViewBuilder
    private var indicatorView: some View {
        switch model.indicator {
        case .orb:
            OrbIndicator(phase: model.phase, diameter: 96)
        case .aurora:
            AuroraRingIndicator(phase: model.phase, message: model.phase.auroraMessage)
        case .waveform:
            WaveformIndicator(phase: model.phase)
        case .prism:
            PrismIndicator(phase: model.phase)
        case .chip:
            StatusChipIndicator(phase: model.phase)
        }
    }

    @ViewBuilder
    private var streamSection: some View {
        Group {
            if model.streamMounted {
                StreamText(model.tokenStream(), style: model.streamStyle.style)
                    .id(model.runToken)
                    .font(.system(size: 15))
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
                    .padding(18)
            } else {
                Text(placeholderCopy)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 140, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(18)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .intelligenceGlow(lineWidth: 2, cornerRadius: 22)
    }

    private var controls: some View {
        VStack(spacing: 12) {
            indicatorRow
            Divider()
            styleRow
            Divider()
            Button {
                model.replay()
            } label: {
                Text("Run again")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)
            .foregroundStyle(Color(uiColor: .systemBackground))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    private var indicatorRow: some View {
        HStack {
            Text("INDICATOR")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .kerning(0.8)
                .foregroundStyle(.secondary)
            Spacer()
            Picker("Indicator", selection: $model.indicator) {
                ForEach(IndicatorStyle.allCases) { style in
                    Text(style.displayName).tag(style)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
        }
    }

    private var styleRow: some View {
        HStack {
            Text("STREAM STYLE")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .kerning(0.8)
                .foregroundStyle(.secondary)
            Spacer()
            Picker("Stream style", selection: $model.streamStyle) {
                ForEach(StreamTextStyleChoice.allCases) { choice in
                    Text(choice.displayName).tag(choice)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
        }
    }

    private var placeholderCopy: String {
        switch model.phase {
        case .idle: "Tap Run again to start."
        case .listening: "Listening for the prompt…"
        case .thinking: "Let me think on that…"
        default: ""
        }
    }

    private var copySecondaryColor: Color {
        switch model.phase {
        case .done: Color(.aiStateSuccessDeep)
        case .error: Color(.aiStateErrorDeep)
        default: .secondary
        }
    }
}

#Preview {
    NavigationStack { AIResponseExample() }
}
