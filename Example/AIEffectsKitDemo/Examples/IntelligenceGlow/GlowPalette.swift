//
//  GlowPalette.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

enum GlowPalette: Hashable {
    case aurora, sunset, forest, mono
    case custom(Color)

    var displayName: String { kind.displayName }

    var colors: [Color] {
        switch self {
        case .aurora: [.blue, .purple, .pink, .blue]
        case .sunset: [.orange, .pink, .red, .orange]
        case .forest: [.green, .mint, .teal, .green]
        case .mono:
            [.primary.opacity(0.2), .primary, .primary.opacity(0.2), .primary]
        case .custom(let color):
            [color.opacity(0.2), color, color.opacity(0.2), color]
        }
    }

    var kind: Kind {
        switch self {
        case .aurora: .aurora
        case .sunset: .sunset
        case .forest: .forest
        case .mono: .mono
        case .custom: .custom
        }
    }
}

extension GlowPalette {
    /// Case-only identity used as a picker tag so the picker doesn't care
    /// which specific `Color` the `.custom` case currently wraps.
    enum Kind: String, CaseIterable, Identifiable {
        case aurora, sunset, forest, mono, custom

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .aurora: "Aurora"
            case .sunset: "Sunset"
            case .forest: "Forest"
            case .mono: "Mono"
            case .custom: "Custom"
            }
        }
    }
}
