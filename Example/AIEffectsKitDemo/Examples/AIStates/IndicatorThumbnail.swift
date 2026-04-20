//
//  IndicatorThumbnail.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct IndicatorThumbnail: View {
    let style: IndicatorStyle
    let isSelected: Bool

    var body: some View {
        let foreground: Color = isSelected ? Color(uiColor: .systemBackground) : .primary
        let softForeground: Color = isSelected ? Color(uiColor: .systemBackground).opacity(0.55) : .secondary
        switch style {
        case .orb:
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            isSelected ? Color(uiColor: .systemBackground) : Color(white: 0.95),
                            foreground
                        ],
                        center: UnitPoint(x: 0.35, y: 0.3),
                        startRadius: 0,
                        endRadius: 14
                    )
                )
                .frame(width: 22, height: 22)
        case .aurora:
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(
                    AngularGradient(
                        colors: [softForeground, foreground, softForeground, foreground, softForeground],
                        center: .center
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 28, height: 20)
        case .waveform:
            HStack(spacing: 2) {
                ForEach([6.0, 14.0, 10.0, 18.0, 8.0], id: \.self) { height in
                    Capsule().fill(foreground).frame(width: 3, height: height)
                }
            }
            .frame(height: 22)
        case .prism:
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [softForeground, foreground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 18, height: 18)
                .rotationEffect(.degrees(45))
                .frame(width: 26, height: 26)
        case .chip:
            HStack(spacing: 4) {
                Circle().fill(foreground).frame(width: 5, height: 5)
                Capsule().fill(foreground).frame(width: 14, height: 3)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 3)
            .overlay(
                Capsule().stroke(foreground, lineWidth: 1)
            )
        }
    }
}
