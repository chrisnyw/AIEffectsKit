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
                        title: "Streaming styles",
                        summary: "Picker for 10 reveal styles — typewriter, word reveal, token chunks, fade + rise, blur to focus, shimmer wipe, skeleton → text, scramble, letter drop, line cascade."
                    ) {
                        StreamTextGalleryExample()
                    }
                } header: {
                    Text("StreamText")
                } footer: {
                    Text("Tap a style to preview it looping. Selection persists via @AppStorage.")
                }

                Section {
                    ExampleLink(
                        title: "IntelligenceGlow",
                        summary: "Animated gradient border. Activate/deactivate manually or wire to an AIState."
                    ) {
                        IntelligenceGlowExample()
                    }
                } header: {
                    Text("Phase 2 components")
                } footer: {
                    Text("Pure-SwiftUI implementations. Metal layerEffect upgrade is planned for IntelligenceGlow.")
                }

                Section {
                    ExampleLink(
                        title: "Orchestrated",
                        summary: "All three components driven by one shared AIState. Thinks, glows, streams, settles."
                    ) {
                        OrchestratedExample()
                    }
                    ExampleLink(
                        title: "AI states",
                        summary: "Picker for five indicator styles — orb, aurora ring, waveform, prism, status chip — cycling through all six phases."
                    ) {
                        AIStatesExample()
                    }
                } header: {
                    Text("AIState orchestration")
                } footer: {
                    Text("The pitch: one state publisher, coherent visual language.")
                }
            }
            .navigationTitle("AIEffectsKit")
        }
    }
}

#Preview {
    ContentView()
}
