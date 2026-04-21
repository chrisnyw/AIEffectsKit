//
//  StreamTextVariant.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation
import AIEffectsKit

struct StreamTextVariant: Identifiable, Equatable {
    let id: String
    let name: String
    let style: StreamTextStyle
}

extension StreamTextVariant {
    /// The ten reveal styles shipped by the library, in the order they appear
    /// in the gallery screen.
    static let all: [StreamTextVariant] = [
        .init(id: "type",    name: "Typewriter",      style: .typewriter()),
        .init(id: "words",   name: "Word reveal",     style: .wordReveal()),
        .init(id: "tokens",  name: "Token chunks",    style: .tokenChunks()),
        .init(id: "fade",    name: "Fade + rise",     style: .fadeRise()),
        .init(id: "blur",    name: "Blur to focus",   style: .blurFocus()),
        .init(id: "shimmer", name: "Shimmer wipe",    style: .shimmerWipe()),
        .init(id: "skel",    name: "Skeleton → text", style: .skeleton()),
        .init(id: "scram",   name: "Scramble",        style: .scramble()),
        .init(id: "drop",    name: "Letter drop",     style: .letterDrop()),
        .init(id: "line",    name: "Line cascade",    style: .lineCascade())
    ]
}
