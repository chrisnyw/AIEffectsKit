//
//  ThinkingDots.swift
//  AIEffectsKitDemo
//
//  Created by Chris Ng on 2026-04-21.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct ThinkingDots: View {
    var body: some View {
        TimelineView(.animation) { context in
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    let t = context.date.timeIntervalSinceReferenceDate / 1.1
                    let offset = Double(i) * 0.15
                    let wave = sin(((t - offset).truncatingRemainder(dividingBy: 1.1) / 1.1) * .pi * 2)
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 5, height: 5)
                        .opacity(0.4 + 0.6 * max(0, wave))
                        .offset(y: -4 * max(0, wave))
                }
            }
        }
    }
}
