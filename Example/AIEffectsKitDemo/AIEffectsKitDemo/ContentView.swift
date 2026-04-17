//
//  ContentView.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ExampleLink(
                        title: "Typing reveal",
                        summary: "A canned paragraph revealed one character at a time using StreamText.typing()."
                    ) {
                        StreamTextTypingExample()
                    }
                    ExampleLink(
                        title: "Async token stream",
                        summary: "Simulates an LLM that yields variable-size chunks via a raw AsyncStream."
                    ) {
                        StreamTextAsyncExample()
                    }
                } header: {
                    Text("StreamText")
                } footer: {
                    Text("Trailing-edge shimmer driven by TimelineView + TextRenderer on iOS 18+. Falls back to a plain fade on iOS 17.")
                }
            }
            .navigationTitle("AIEffectsKit")
        }
    }
}

#Preview {
    ContentView()
}
