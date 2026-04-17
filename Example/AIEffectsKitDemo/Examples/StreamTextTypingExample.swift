//
//  StreamTextTypingExample.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI
import AIEffectsKit

struct StreamTextTypingExample: View {
    @State private var runToken = 0

    private let sampleText = """
    Generative AI is reshaping how we design software — and the surface of an app is where the feeling lives. \
    A token settles in. A glow breathes. A ripple answers the tap. AIEffectsKit packages that language.
    """

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StreamText.typing(sampleText)
                    .font(.title3)
                    .id(runToken)
                    .padding(.horizontal)

                Button("Replay") { runToken += 1 }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Typing reveal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { StreamTextTypingExample() }
}
