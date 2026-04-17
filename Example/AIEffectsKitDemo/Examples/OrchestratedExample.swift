//
//  OrchestratedExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct OrchestratedExample: View {
    @State private var state = AIState()
    @State private var runToken = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                ThinkingIndicator()
                    .frame(height: 18)
                Text(label)
                    .font(.footnote.monospaced())
                    .foregroundStyle(.secondary)
                Spacer()
            }

            StreamText(tokenStream())
                .font(.body)
                .id(runToken)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
                .intelligenceGlow(cornerRadius: 20)

            Button("Run again") {
                state.phase = .thinking
                runToken += 1
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .navigationTitle("Orchestrated")
        .navigationBarTitleDisplayMode(.inline)
        .aiState(state)
        .onAppear { state.phase = .thinking }
    }

    private var label: String {
        switch state.phase {
        case .idle: "idle"
        case .listening: "listening"
        case .thinking: "thinking"
        case .streaming: "streaming…"
        case .done: "done"
        case .error(let message): "error(\(message))"
        }
    }

    private func tokenStream() -> AsyncStream<String> {
        let chunks: [String] = [
            "One ", "AIState ", "drives ", "every ", "effect ", "in ",
            "the ", "view. ", "Indicator, ", "glow, ", "streaming ",
            "text ", "— ", "all ", "synchronized."
        ]
        return AsyncStream<String> { continuation in
            let producer = Task {
                try? await Task.sleep(for: .milliseconds(900))
                for chunk in chunks {
                    if Task.isCancelled { break }
                    try? await Task.sleep(for: .milliseconds(Int.random(in: 70...220)))
                    if Task.isCancelled { break }
                    continuation.yield(chunk)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in producer.cancel() }
        }
    }
}

#Preview {
    NavigationStack { OrchestratedExample() }
}
