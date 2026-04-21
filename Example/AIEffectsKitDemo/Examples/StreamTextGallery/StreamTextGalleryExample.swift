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
    @State private var model = StreamTextGalleryViewModel()

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

    // MARK: - Sections

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
            Text("\(model.selectedIndex + 1)/\(model.variants.count)")
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
                    Text("\(String(format: "%02d", model.selectedIndex + 1)) · \(model.selectedVariant.name)")
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
            Text(model.sampleQuestion)
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
                answer: model.sampleAnswer,
                style: model.selectedVariant.style,
                runToken: model.replayToken
            )
            .font(.system(size: 14.5))
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 70, alignment: .top)
    }

    private var replayButton: some View {
        Button {
            model.replay()
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
            Text("\(model.variants.count)")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var rowList: some View {
        VStack(spacing: 0) {
            ForEach(Array(model.variants.enumerated()), id: \.element.id) { index, variant in
                StreamTextVariantRow(
                    index: index,
                    variant: variant,
                    isActive: index == model.selectedIndex,
                    onTap: { model.select(index) }
                )
                if index < model.variants.count - 1 {
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

#Preview {
    NavigationStack { StreamTextGalleryExample() }
}
