//
//  AIResponseViewModel.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

/// View model for `AIResponseExample`.
///
/// Owns the shared `AIState`, the persisted picker selections, and the
/// pre-stream orchestration (idle → listening → thinking → stream mount).
/// The view is responsible for wiring `runFlow()` into its `.task(id:)` and
/// for rendering. All persistence and state-machine logic lives here.
@Observable
@MainActor
final class AIResponseViewModel {

    // MARK: - Shared runtime state

    /// Injected into the environment by the view via `.aiState(_:)` so that
    /// `StreamText` and `IntelligenceGlow` observe the same phase.
    let aiState: AIState

    // MARK: - Persisted selection

    var indicator: IndicatorStyle {
        didSet {
            defaults.set(indicator.rawValue, forKey: Keys.indicator)
        }
    }

    var streamStyle: StreamTextStyleChoice {
        didSet {
            defaults.set(streamStyle.rawValue, forKey: Keys.streamStyle)
            // Restart the flow so the new style is demonstrated end-to-end.
            replay()
        }
    }

    // MARK: - Flow-driven state (owned by runFlow)

    /// Bumped by `replay()` to signal the view to restart its `.task(id:)`.
    private(set) var runToken: Int = 0

    /// `true` once the pre-stream phases have elapsed and the view should mount
    /// `StreamText`. Library-side streaming then drives `.streaming → .done`.
    private(set) var streamMounted: Bool = false

    // MARK: - Derived

    /// The library's `AIPhase` (with its associated error payload) mapped to the
    /// demo-local `AIStatePhase` consumed by every indicator.
    var phase: AIStatePhase { aiState.phase.demoPhase }

    // MARK: - Dependencies

    @ObservationIgnored private let defaults: UserDefaults

    private enum Keys {
        static let indicator = "ai-response-indicator"
        static let streamStyle = "ai-response-stream-style"
    }

    // MARK: - Lifecycle

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.aiState = AIState()
        self.indicator = defaults.string(forKey: Keys.indicator)
            .flatMap(IndicatorStyle.init) ?? .orb
        self.streamStyle = defaults.string(forKey: Keys.streamStyle)
            .flatMap(StreamTextStyleChoice.init) ?? .trailingShimmer
    }

    // MARK: - Intents

    /// Kick off a fresh playthrough. The view observes `runToken` and drives
    /// `runFlow()` via `.task(id:)`.
    func replay() {
        runToken += 1
    }

    /// Walks the pre-stream phases. Returns once `streamMounted` is `true`;
    /// `StreamText` then takes over and reports `.streaming` / `.done`.
    func runFlow() async {
        streamMounted = false
        withAnimation(.smooth(duration: 0.35)) { aiState.phase = .idle }
        try? await Task.sleep(for: .milliseconds(250))
        guard !Task.isCancelled else { return }
        withAnimation(.smooth(duration: 0.35)) { aiState.phase = .listening }
        try? await Task.sleep(for: .milliseconds(900))
        guard !Task.isCancelled else { return }
        withAnimation(.smooth(duration: 0.35)) { aiState.phase = .thinking }
        try? await Task.sleep(for: .milliseconds(1100))
        guard !Task.isCancelled else { return }
        withAnimation(.easeInOut(duration: 0.3)) { streamMounted = true }
    }

    // MARK: - Token source

    /// Returns a self-cancelling `AsyncStream` that yields a sample response
    /// with jittered spacing, standing in for a real LLM token stream.
    func tokenStream() -> AsyncStream<String> {
        AsyncStream<String> { continuation in
            let producer = Task {
                for chunk in Self.sampleChunks {
                    if Task.isCancelled { break }
                    try? await Task.sleep(for: .milliseconds(Int.random(in: 80...220)))
                    if Task.isCancelled { break }
                    continuation.yield(chunk)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in producer.cancel() }
        }
    }

    private static let sampleChunks: [String] = [
        "Here's ", "what ", "I ", "put ", "together — ", "the ", "shimmer ",
        "rides ", "the ", "trailing ", "edge ", "as ", "tokens ", "arrive, ",
        "the ", "border ", "breathes, ", "and ", "the ", "indicator ",
        "moves ", "through ", "each ", "phase."
    ]
}

// MARK: - Library → demo phase bridge

private extension AIPhase {
    var demoPhase: AIStatePhase {
        switch self {
        case .idle: .idle
        case .listening: .listening
        case .thinking: .thinking
        case .streaming: .streaming
        case .done: .done
        case .error: .error
        }
    }
}
