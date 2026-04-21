//
//  StreamTextGalleryViewModel.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

/// View model for `StreamTextGalleryExample`.
///
/// Owns the persisted picker index, the replay counter, and the static sample
/// Q/A plus the list of ten `StreamTextVariant`s.
@Observable
@MainActor
final class StreamTextGalleryViewModel {

    // MARK: - Persisted selection

    var selectedIndex: Int {
        didSet {
            let clamped = min(max(0, selectedIndex), variants.count - 1)
            if clamped != selectedIndex {
                selectedIndex = clamped
                return
            }
            defaults.set(selectedIndex, forKey: Keys.selectedIndex)
            replayToken += 1
        }
    }

    // MARK: - Replay

    private(set) var replayToken: Int = 0

    // MARK: - Static content

    let variants: [StreamTextVariant] = StreamTextVariant.all
    let sampleQuestion = "Explain recursion simply."
    let sampleAnswer = "A function that calls itself until it hits a base case — like nested boxes where each one opens a smaller version of itself."

    // MARK: - Derived

    var selectedVariant: StreamTextVariant { variants[selectedIndex] }

    // MARK: - Dependencies

    @ObservationIgnored private let defaults: UserDefaults

    private enum Keys {
        static let selectedIndex = "streaming-variant"
    }

    // MARK: - Lifecycle

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let stored = defaults.integer(forKey: Keys.selectedIndex)
        let variantCount = StreamTextVariant.all.count
        self.selectedIndex = min(max(0, stored), variantCount - 1)
    }

    // MARK: - Intents

    func select(_ index: Int) {
        selectedIndex = index
    }

    func replay() {
        replayToken += 1
    }
}
