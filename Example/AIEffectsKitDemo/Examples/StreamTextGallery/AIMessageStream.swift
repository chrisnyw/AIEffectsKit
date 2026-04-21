//
//  AIMessageStream.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

/// Loops a thinking-dots pulse followed by a styled `StreamText.typing(_:)`
/// reveal, used inside the gallery's preview card. The parent drives cycles by
/// bumping `runToken`.
struct AIMessageStream: View {
    let answer: String
    let style: StreamTextStyle
    let runToken: Int

    @State private var phase: Phase = .thinking

    private enum Phase { case thinking, streaming }

    var body: some View {
        Group {
            switch phase {
            case .thinking:
                ThinkingDots()
                    .frame(height: 14)
            case .streaming:
                StreamText.typing(answer, interval: .milliseconds(22), style: style)
                    .id(runToken)
            }
        }
        .task(id: runToken) {
            await cycle()
        }
    }

    private func cycle() async {
        while !Task.isCancelled {
            phase = .thinking
            try? await Task.sleep(for: .milliseconds(680))
            if Task.isCancelled { return }
            phase = .streaming
            let estimatedReveal = Double(answer.count) * 0.028 + 1.2
            try? await Task.sleep(for: .seconds(estimatedReveal + 2.4))
            if Task.isCancelled { return }
        }
    }
}
