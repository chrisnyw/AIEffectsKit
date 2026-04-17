//
//  StreamText+Typing.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Foundation

public extension StreamText where Source == AsyncStream<String> {
    static func typing(
        _ text: String,
        interval: Duration = .milliseconds(40),
        shimmerWindow: Int = 12,
        shimmerStrength: Double = 0.6,
        shimmerPeriod: Duration = .milliseconds(900)
    ) -> StreamText {
        StreamText(
            typingStream(text: text, interval: interval),
            shimmerWindow: shimmerWindow,
            shimmerStrength: shimmerStrength,
            shimmerPeriod: shimmerPeriod
        )
    }
}

@usableFromInline
func typingStream(text: String, interval: Duration) -> AsyncStream<String> {
    AsyncStream<String> { continuation in
        let producer = Task {
            for character in text {
                if Task.isCancelled { break }
                try? await Task.sleep(for: interval)
                if Task.isCancelled { break }
                continuation.yield(String(character))
            }
            continuation.finish()
        }
        continuation.onTermination = { _ in
            producer.cancel()
        }
    }
}
