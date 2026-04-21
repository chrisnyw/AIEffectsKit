//
//  StreamTextVariantRow.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct StreamTextVariantRow: View {
    let index: Int
    let variant: StreamTextVariant
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
