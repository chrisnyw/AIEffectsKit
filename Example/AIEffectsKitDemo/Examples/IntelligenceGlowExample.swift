//
//  IntelligenceGlowExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct IntelligenceGlowExample: View {
    @State private var isActive = true

    var body: some View {
        VStack(spacing: 32) {
            card
                .intelligenceGlow(
                    colors: [.blue, .purple, .pink, .blue],
                    lineWidth: 2,
                    cornerRadius: 20,
                    activeWhen: isActive
                )

            Toggle("Active", isOn: $isActive)
                .font(.headline)
        }
        .padding()
        .navigationTitle("IntelligenceGlow")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ask anything")
                .font(.title2.weight(.semibold))
            Text("Decorate any surface with a gently rotating gradient border. Wire to an `AIState` to activate only while the model is listening / thinking / streaming.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack { IntelligenceGlowExample() }
}
