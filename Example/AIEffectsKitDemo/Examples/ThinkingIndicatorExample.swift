//
//  ThinkingIndicatorExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct ThinkingIndicatorExample: View {
    @State private var state = AIState()

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("Phase: \(phaseLabel)")
                    .font(.footnote.monospaced())
                    .foregroundStyle(.secondary)
                HStack {
                    Text("Indicator:")
                    ThinkingIndicator()
                        .frame(height: 18)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.secondary.opacity(0.1))
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Drive phase")
                    .font(.headline)
                ForEach(phases, id: \.label) { entry in
                    Button(entry.label) {
                        state.phase = entry.phase
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .navigationTitle("ThinkingIndicator")
        .navigationBarTitleDisplayMode(.inline)
        .aiState(state)
    }

    private var phaseLabel: String {
        switch state.phase {
        case .idle: "idle"
        case .listening: "listening"
        case .thinking: "thinking"
        case .streaming: "streaming"
        case .done: "done"
        case .error(let message): "error(\(message))"
        }
    }

    private var phases: [(label: String, phase: AIPhase)] {
        [
            ("Idle", .idle),
            ("Listening", .listening),
            ("Thinking", .thinking),
            ("Streaming", .streaming),
            ("Done", .done)
        ]
    }
}

#Preview {
    NavigationStack { ThinkingIndicatorExample() }
}
