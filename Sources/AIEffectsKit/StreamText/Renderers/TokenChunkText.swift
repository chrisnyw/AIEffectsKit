//
//  TokenChunkText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct TokenChunkText: View {
    let text: String
    let duration: Duration

    @State private var chunks: [TimedChunk] = []

    var body: some View {
        TimelineView(.animation) { context in
            FlowLayout {
                ForEach(chunks) { chunk in
                    chunkView(chunk: chunk, now: context.date)
                }
            }
        }
        .onChange(of: text, initial: true) { _, new in
            chunks = TimedChunk.chunks(from: new, reconciling: chunks)
        }
    }

    @ViewBuilder
    private func chunkView(chunk: TimedChunk, now: Date) -> some View {
        let elapsed = now.timeIntervalSince(chunk.arrivedAt)
        let total = seconds(duration)
        let p = max(0, min(1, elapsed / total))
        let bgOpacity = (1 - p) * 0.35

        Text(chunk.text)
            .padding(.horizontal, 1)
            .background(Color.primary.opacity(bgOpacity))
            .opacity(p > 0 ? 1 : 0)
    }
}

struct TimedChunk: Identifiable, Equatable {
    let id: Int
    var text: String
    let arrivedAt: Date
}

extension TimedChunk {
    static func chunks(from accumulated: String, reconciling existing: [TimedChunk], now: Date = Date()) -> [TimedChunk] {
        let tokens = tokenize(accumulated)
        var out: [TimedChunk] = []
        out.reserveCapacity(tokens.count)
        for (i, token) in tokens.enumerated() {
            if i < existing.count {
                var entry = existing[i]
                if entry.text != token { entry.text = token }
                out.append(entry)
            } else {
                out.append(TimedChunk(id: i, text: token, arrivedAt: now))
            }
        }
        return out
    }

    private static func tokenize(_ text: String) -> [String] {
        var out: [String] = []
        let chars = Array(text)
        var i = 0
        while i < chars.count {
            if chars[i].isWhitespace {
                out.append(String(chars[i]))
                i += 1
                continue
            }
            let len = 2 + ((i &* 31) & 3)
            let end = min(chars.count, i + len)
            out.append(String(chars[i..<end]))
            i = end
        }
        return out
    }
}
