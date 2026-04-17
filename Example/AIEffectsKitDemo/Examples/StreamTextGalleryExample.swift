//
//  StreamTextGalleryExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct StreamTextGalleryExample: View {
    @AppStorage("streaming-variant") private var selectedIndex: Int = 0
    @State private var runToken: Int = 0

    private let sampleQuestion = "Explain recursion simply."
    private let sampleAnswer = "A function that calls itself until it hits a base case — like nested boxes where each one opens a smaller version of itself."

    private let variants: [Variant] = [
        Variant(id: "type",    name: "Typewriter",      style: .typewriter()),
        Variant(id: "words",   name: "Word reveal",     style: .wordReveal()),
        Variant(id: "tokens",  name: "Token chunks",    style: .tokenChunks()),
        Variant(id: "fade",    name: "Fade + rise",     style: .fadeRise()),
        Variant(id: "blur",    name: "Blur to focus",   style: .blurFocus()),
        Variant(id: "shimmer", name: "Shimmer wipe",    style: .shimmerWipe()),
        Variant(id: "skel",    name: "Skeleton → text", style: .skeleton()),
        Variant(id: "scram",   name: "Scramble",        style: .scramble()),
        Variant(id: "drop",    name: "Letter drop",     style: .letterDrop()),
        Variant(id: "line",    name: "Line cascade",    style: .lineCascade())
    ]

    private var clampedIndex: Int {
        min(max(0, selectedIndex), variants.count - 1)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                preview
                sectionHeader
                rowList
                Spacer().frame(height: 32)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Streaming styles")
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SETTINGS")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .kerning(1)
                    .foregroundStyle(.secondary)
                Text("Streaming")
                    .font(.system(size: 28, weight: .semibold))
                    .kerning(-0.3)
            }
            Spacer()
            Text("\(clampedIndex + 1)/\(variants.count)")
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private var preview: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Circle().fill(.primary).frame(width: 6, height: 6)
                    Text("SAMPLE")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .kerning(0.6)
                        .foregroundStyle(.secondary)
                }

                userBubble

                aiMessage

                HStack {
                    Text("\(String(format: "%02d", clampedIndex + 1)) · \(variants[clampedIndex].name)")
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

    private var userBubble: some View {
        HStack {
            Spacer(minLength: 40)
            Text(sampleQuestion)
                .font(.system(size: 14))
                .foregroundStyle(Color(uiColor: .systemBackground))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(topLeading: 14, bottomLeading: 14, bottomTrailing: 3, topTrailing: 14),
                        style: .continuous
                    )
                    .fill(Color.primary)
                )
        }
    }

    private var aiMessage: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(.primary)
                .frame(width: 6, height: 6)
                .padding(.top, 8)
            AIMessageStream(
                answer: sampleAnswer,
                style: variants[clampedIndex].style,
                runToken: runToken
            )
            .font(.system(size: 14.5))
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 70, alignment: .top)
    }

    private var replayButton: some View {
        Button {
            runToken += 1
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
            .background(
                Capsule()
                    .fill(Color(uiColor: .tertiarySystemGroupedBackground))
            )
            .overlay(
                Capsule()
                    .stroke(Color(uiColor: .separator), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Replay streaming sample")
    }

    private var sectionHeader: some View {
        HStack {
            Text("ANIMATION STYLES")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .kerning(1)
            Spacer()
            Text("\(variants.count)")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var rowList: some View {
        VStack(spacing: 0) {
            ForEach(Array(variants.enumerated()), id: \.element.id) { index, variant in
                VariantRow(
                    index: index,
                    variant: variant,
                    isActive: index == clampedIndex,
                    onTap: {
                        selectedIndex = index
                        runToken += 1
                    }
                )
                if index < variants.count - 1 {
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
}

private struct Variant: Identifiable {
    let id: String
    let name: String
    let style: StreamTextStyle
}

private struct VariantRow: View {
    let index: Int
    let variant: Variant
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(String(format: "%02d", index + 1))
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(isActive ? Color(uiColor: .systemBackground) : .secondary)
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
                    Text(variant.name)
                        .font(.system(size: 15.5, weight: .medium))
                        .kerning(-0.15)
                        .foregroundStyle(.primary)
                    Text(variant.id.uppercased())
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .kerning(0.4)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                tickCircle
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(minHeight: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(variant.name)
        .accessibilityValue(isActive ? "Selected" : "")
        .accessibilityHint("Activates this streaming style")
    }

    private var tickCircle: some View {
        ZStack {
            Circle()
                .stroke(isActive ? Color.primary : Color(uiColor: .separator), lineWidth: 1.5)
                .background(
                    Circle().fill(isActive ? Color.primary : Color.clear)
                )
                .frame(width: 22, height: 22)
            if isActive {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(uiColor: .systemBackground))
            }
        }
    }
}

private struct AIMessageStream: View {
    let answer: String
    let style: StreamTextStyle
    let runToken: Int

    @State private var phase: Phase = .thinking

    private enum Phase { case thinking, streaming }

    var body: some View {
        Group {
            switch phase {
            case .thinking:
                ThinkingDots()
                    .frame(height: 14)
            case .streaming:
                StreamText.typing(answer, interval: .milliseconds(22), style: style)
                    .id(runToken)
            }
        }
        .task(id: runToken) {
            await cycle()
        }
    }

    private func cycle() async {
        while !Task.isCancelled {
            phase = .thinking
            try? await Task.sleep(for: .milliseconds(680))
            if Task.isCancelled { return }
            phase = .streaming
            let estimatedReveal = Double(answer.count) * 0.028 + 1.2
            try? await Task.sleep(for: .seconds(estimatedReveal + 2.4))
            if Task.isCancelled { return }
        }
    }
}

private struct ThinkingDots: View {
    var body: some View {
        TimelineView(.animation) { context in
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    let t = context.date.timeIntervalSinceReferenceDate / 1.1
                    let offset = Double(i) * 0.15
                    let wave = sin(((t - offset).truncatingRemainder(dividingBy: 1.1) / 1.1) * .pi * 2)
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 5, height: 5)
                        .opacity(0.4 + 0.6 * max(0, wave))
                        .offset(y: -4 * max(0, wave))
                }
            }
        }
    }
}

#Preview {
    NavigationStack { StreamTextGalleryExample() }
}
