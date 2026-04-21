//
//  IntelligenceGlowExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-20.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct IntelligenceGlowExample: View {
    @State private var model = IntelligenceGlowViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                card
                    .padding(.horizontal, 4)

                controls
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("IntelligenceGlow")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(model.palette.colors.first ?? .primary)
                    .frame(width: 10, height: 10)
                Text("Ask anything")
                    .font(.system(size: 22, weight: .semibold))
            }
            Text("Decorate any surface with a gently rotating gradient border. Wire to an AIState to activate only while the model is listening, thinking, or streaming.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CGFloat(model.cornerRadius), style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .intelligenceGlow(
            colors: model.palette.colors,
            lineWidth: CGFloat(model.lineWidth),
            cornerRadius: CGFloat(model.cornerRadius),
            activeWhen: model.isActive
        )
    }

    private var controls: some View {
        VStack(spacing: 14) {
            Toggle("Active", isOn: $model.isActive)

            Divider()

            HStack {
                Text("PALETTE")
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("Palette", selection: $model.palette) {
                    ForEach(GlowPalette.allCases) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .tint(.primary)
            }

            Divider()

            HStack {
                Text("LINE WIDTH")
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: "%.0fpt", model.lineWidth))
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.primary)
                    .frame(width: 40, alignment: .trailing)
            }
            Slider(value: $model.lineWidth, in: 1...6, step: 1)
                .tint(.primary)

            Divider()

            HStack {
                Text("CORNER RADIUS")
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .kerning(0.8)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: "%.0fpt", model.cornerRadius))
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.primary)
                    .frame(width: 40, alignment: .trailing)
            }
            Slider(value: $model.cornerRadius, in: 0...36, step: 2)
                .tint(.primary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}

#Preview {
    NavigationStack { IntelligenceGlowExample() }
}
