//
//  IntelligenceGlow.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//
//  Pure-SwiftUI implementation. The plan calls for a Metal `layerEffect`
//  version; that upgrade can land without API changes since the modifier
//  shape (colors, lineWidth, cornerRadius) stays stable.
//

import SwiftUI

public extension View {
    func intelligenceGlow(
        colors: [Color] = [.blue, .purple, .pink, .blue],
        lineWidth: CGFloat = 2,
        cornerRadius: CGFloat = 16,
        activeWhen isActive: Bool? = nil
    ) -> some View {
        modifier(
            IntelligenceGlowModifier(
                colors: colors,
                lineWidth: lineWidth,
                cornerRadius: cornerRadius,
                explicitActive: isActive
            )
        )
    }
}

struct IntelligenceGlowModifier: ViewModifier {
    let colors: [Color]
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    let explicitActive: Bool?

    @Environment(\.aiState) private var aiState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        content.overlay {
            border
                .allowsHitTesting(false)
        }
    }

    @ViewBuilder private var border: some View {
        if !isActive {
            EmptyView()
        } else if prefersStatic {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(colors.first ?? Color.primary, lineWidth: lineWidth)
                .opacity(0.6)
        } else {
            TimelineView(.animation) { context in
                let angle = rotationAngle(at: context.date)
                ZStack {
                    shape
                        .strokeBorder(gradient(angle: angle), lineWidth: lineWidth)
                        .blur(radius: lineWidth * 1.6)
                        .opacity(0.7)
                    shape
                        .strokeBorder(gradient(angle: angle), lineWidth: lineWidth)
                }
            }
        }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    private func gradient(angle: Angle) -> AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: colors),
            center: .center,
            angle: angle
        )
    }

    private func rotationAngle(at date: Date) -> Angle {
        let period: Double = 4 // seconds per revolution
        let t = date.timeIntervalSinceReferenceDate / period
        return .degrees((t - floor(t)) * 360)
    }

    private var isActive: Bool {
        if let explicit = explicitActive { return explicit }
        return aiState?.phase.isActive ?? false
    }

    private var prefersStatic: Bool {
        reduceMotion
            || reduceTransparency
            || ProcessInfo.processInfo.isLowPowerModeEnabled
    }
}

#Preview("IntelligenceGlowDemo") {
    VStack {
        PreviewTextDemo(text: "Inactive")
            .intelligenceGlow(
                colors: [.blue, .purple, .pink, .blue],
                lineWidth: 2,
                cornerRadius: 10,
                activeWhen: false
            )
            .cornerRadius(10)
        
        PreviewTextDemo(text: "Active")
            .intelligenceGlow(
                colors: [.blue, .purple, .pink, .blue],
                lineWidth: 2,
                cornerRadius: 10,
                activeWhen: true
            )
        
        PreviewTextDemo(text: "Active with default lineWidth and radius")
            .intelligenceGlow(
                colors: [.orange, .pink, .red, .orange],
                activeWhen: true
            )
        
        PreviewTextDemo(text: "Active with mono color")
            .intelligenceGlow(
                colors: [.primary.opacity(0.2), .primary, .primary.opacity(0.2), .primary],
                activeWhen: true
            )
    }
    .padding()
}

private struct PreviewTextDemo: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(Color(uiColor: .secondarySystemBackground))
    }
}
