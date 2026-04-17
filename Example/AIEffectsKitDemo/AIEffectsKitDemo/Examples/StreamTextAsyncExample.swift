//
//  StreamTextAsyncExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct StreamTextAsyncExample: View {
    @State private var runToken = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StreamText(mockLLMStream())
                    .font(.title3)
                    .id(runToken)
                    .padding(.horizontal)

                Button("Replay") { runToken += 1 }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Async token stream")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func mockLLMStream() -> AsyncStream<String> {
        let chunks: [String] = [
            "Designing ", "for ", "generative ", "UIs ",
            "means ", "treating ", "latency ", "as ", "a ", "surface ",
            "— ", "the ", "wait ", "is ", "part ", "of ", "the ", "product. ",
            "A ", "shimmer ", "on ", "the ", "trailing ", "edge ",
            "says: ", "we're ", "still ", "thinking."
        ]
        return AsyncStream<String> { continuation in
            let producer = Task {
                for chunk in chunks {
                    if Task.isCancelled { break }
                    let jitter = Int.random(in: 40...180)
                    try? await Task.sleep(for: .milliseconds(jitter))
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
    NavigationStack { StreamTextAsyncExample() }
}
