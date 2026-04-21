//
//  GlowPalette.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

enum GlowPalette: String, CaseIterable, Identifiable {
    case aurora, sunset, forest, mono

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .aurora: "Aurora"
        case .sunset: "Sunset"
        case .forest: "Forest"
        case .mono: "Mono"
        }
    }

    var colors: [Color] {
        switch self {
        case .aurora: [.blue, .purple, .pink, .blue]
        case .sunset: [.orange, .pink, .red, .orange]
        case .forest: [.green, .mint, .teal, .green]
        case .mono: [.primary.opacity(0.2), .primary, .primary.opacity(0.2), .primary]
        }
    }
}
