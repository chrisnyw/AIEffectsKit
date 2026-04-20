//
//  AIStatePhase.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

enum AIStatePhase: String, Identifiable, CaseIterable, Equatable {
    case idle, listening, thinking, streaming, done, error

    var id: String { rawValue }
    var title: String { rawValue.capitalized }

    var subtitle: String {
        switch self {
        case .idle: "at rest"
        case .listening: "capturing audio"
        case .thinking: "reasoning"
        case .streaming: "generating"
        case .done: "complete"
        case .error: "retry available"
        }
    }

    var primaryCopy: String {
        switch self {
        case .idle: "Ready when you are"
        case .listening: "Listening — speak now"
        case .thinking: "Working through it…"
        case .streaming: "Responding in real time"
        case .done: "Finished"
        case .error: "Something went wrong"
        }
    }

    var secondaryCopy: String {
        switch self {
        case .idle: "waiting for input"
        case .listening: "mic active"
        case .thinking: "reasoning · ~2s"
        case .streaming: "tokens streaming"
        case .done: "complete · 38 tokens"
        case .error: "network timeout"
        }
    }

    var badgeText: String { title }

    var badgeSupport: String {
        switch self {
        case .idle: "waiting for input"
        case .listening: "capturing audio"
        case .thinking: "reasoning…"
        case .streaming: "generating tokens"
        case .done: "response complete"
        case .error: "request failed"
        }
    }

    var auroraMessage: String {
        switch self {
        case .idle: "Ready when you are."
        case .listening: "I'm listening — go ahead."
        case .thinking: "Let me think on that…"
        case .streaming: "Here's what I found…"
        case .done: "Let me know if you want more."
        case .error: "Sorry — that didn't go through."
        }
    }
}
