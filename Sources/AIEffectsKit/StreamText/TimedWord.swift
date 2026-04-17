//
//  TimedWord.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

struct TimedWord: Identifiable, Equatable {
    let id: Int
    var text: String
    let arrivedAt: Date
}

extension TimedWord {
    static func words(from accumulated: String, reconciling existing: [TimedWord], now: Date = Date()) -> [TimedWord] {
        let chunks = accumulated.wordChunks
        var out: [TimedWord] = []
        out.reserveCapacity(chunks.count)
        for (i, chunk) in chunks.enumerated() {
            if i < existing.count {
                var entry = existing[i]
                if entry.text != chunk { entry.text = chunk }
                out.append(entry)
            } else {
                out.append(TimedWord(id: i, text: chunk, arrivedAt: now))
            }
        }
        return out
    }
}

private extension String {
    var wordChunks: [String] {
        matches(of: #/\S+\s*/#).map { String($0.output) }
    }
}
