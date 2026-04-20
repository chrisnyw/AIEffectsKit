//
//  IndicatorStyle.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

enum IndicatorStyle: String, CaseIterable, Identifiable {
    case orb, aurora, waveform, prism, chip

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .orb: "Orb"
        case .aurora: "Aurora ring"
        case .waveform: "Waveform"
        case .prism: "Prism"
        case .chip: "Status chip"
        }
    }

    var tagline: String {
        switch self {
        case .orb: "sphere, morph, halo"
        case .aurora: "conic glow"
        case .waveform: "bars"
        case .prism: "shard, unfold"
        case .chip: "text pill"
        }
    }

    var numericLabel: String {
        guard let index = IndicatorStyle.allCases.firstIndex(of: self) else { return "" }
        return String(format: "%02d", index + 1)
    }
}
