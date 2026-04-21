//
//  AIStatesViewModel.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

/// View model for `AIStatesExample`.
///
/// Owns the two picker selections (phase + indicator style), persists them
/// through an injected `UserDefaults`, and exposes a replay token so the view
/// can restart indicator animations on selection changes.
@Observable
@MainActor
final class AIStatesViewModel {

    // MARK: - Persisted selection

    var phase: AIStatePhase {
        didSet {
            defaults.set(phase.rawValue, forKey: Keys.phase)
        }
    }

    var indicator: IndicatorStyle {
        didSet {
            defaults.set(indicator.rawValue, forKey: Keys.indicator)
        }
    }

    // MARK: - Replay

    private(set) var replayToken: Int = 0

    // MARK: - Derived

    var phaseIndex: Int {
        AIStatePhase.allCases.firstIndex(of: phase) ?? 0
    }

    // MARK: - Dependencies

    @ObservationIgnored private let defaults: UserDefaults

    private enum Keys {
        static let phase = "ai-states-phase"
        static let indicator = "ai-states-indicator"
    }

    // MARK: - Lifecycle

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.phase = defaults.string(forKey: Keys.phase)
            .flatMap(AIStatePhase.init) ?? .idle
        self.indicator = defaults.string(forKey: Keys.indicator)
            .flatMap(IndicatorStyle.init) ?? .orb
    }

    // MARK: - Intents

    /// Switch to a new phase and bump the replay token so indicators restart.
    func select(phase: AIStatePhase) {
        self.phase = phase
        replayToken += 1
    }

    /// Switch to a new indicator and bump the replay token so the new indicator
    /// animates from a fresh start.
    func select(indicator: IndicatorStyle) {
        self.indicator = indicator
        replayToken += 1
    }

    func replay() {
        replayToken += 1
    }
}
