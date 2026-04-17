//
//  LineCascadeText.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct LineCascadeText: View {
    let text: String
    let duration: Duration
    let wordsPerLine: Int = 7

    @State private var lines: [TimedLine] = []

    var body: some View {
        TimelineView(.animation) { context in
            VStack(alignment: .leading, spacing: 2) {
                ForEach(lines) { line in
                    lineView(line: line, now: context.date)
                }
            }
        }
        .onChange(of: text, initial: true) { _, _ in
            lines = TimedLine.lines(from: text, reconciling: lines, wordsPerLine: wordsPerLine)
        }
    }

    @ViewBuilder
    private func lineView(line: TimedLine, now: Date) -> some View {
        let elapsed = now.timeIntervalSince(line.arrivedAt)
        let p = max(0, min(1, elapsed / seconds(duration)))
        let eased = 1 - pow(1 - p, 3)
        Text(line.text)
            .opacity(eased)
            .offset(y: (1 - eased) * 12)
    }
}

struct TimedLine: Identifiable, Equatable {
    let id: Int
    var text: String
    let arrivedAt: Date
}

extension TimedLine {
    static func lines(from accumulated: String, reconciling existing: [TimedLine], wordsPerLine: Int, now: Date = Date()) -> [TimedLine] {
        let words = accumulated.split(separator: " ", omittingEmptySubsequences: false)
        var groups: [String] = []
        var i = 0
        while i < words.count {
            let slice = words[i..<min(i + wordsPerLine, words.count)]
            groups.append(slice.joined(separator: " "))
            i += wordsPerLine
        }

        var out: [TimedLine] = []
        for (idx, group) in groups.enumerated() {
            if idx < existing.count {
                var entry = existing[idx]
                if entry.text != group { entry.text = group }
                out.append(entry)
            } else {
                out.append(TimedLine(id: idx, text: group, arrivedAt: now))
            }
        }
        return out
    }
}
