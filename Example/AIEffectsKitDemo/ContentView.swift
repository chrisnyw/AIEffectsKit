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
                componentsSection
                integrationSection
            }
            .navigationTitle("AIEffectsKit")
        }
    }

    private var componentsSection: some View {
        Section {
            ExampleLink(
                title: "IntelligenceGlow",
                summary: "Animated gradient border modifier. Tweak palette, line width, corner radius, and activation."
            ) {
                IntelligenceGlowExample()
            }
            ExampleLink(
                title: "Streaming styles",
                summary: "Ten StreamText reveal styles in one looping picker — typewriter, word reveal, shimmer wipe, and more."
            ) {
                StreamTextGalleryExample()
            }
            ExampleLink(
                title: "AI states",
                summary: "Five indicator styles — orb, aurora ring, waveform, prism, status chip — cycling through all six phases."
            ) {
                AIStatesExample()
            }
        } header: {
            Text("Components")
        } footer: {
            Text("Each effect on its own — catalogs and tuning surfaces.")
        }
    }

    private var integrationSection: some View {
        Section {
            ExampleLink(
                title: "AI response",
                summary: "StreamText inside an IntelligenceGlow card, with a picked indicator animating idle → listening → thinking → streaming → done."
            ) {
                AIResponseExample()
            }
        } header: {
            Text("Integration")
        } footer: {
            Text("One AIState driving the indicator, the glow border, and the streaming text together.")
        }
    }
}

#Preview {
    ContentView()
}
