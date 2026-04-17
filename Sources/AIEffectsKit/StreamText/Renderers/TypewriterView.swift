//
//  TypewriterView.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct TypewriterView: View {
    let text: String
    let showCaret: Bool

    var body: some View {
        if showCaret {
            TimelineView(.periodic(from: .now, by: 0.5)) { context in
                let caretVisible = Int(context.date.timeIntervalSinceReferenceDate / 0.5).isMultiple(of: 2)
                Text(text)
                    + Text(verbatim: "▌")
                        .foregroundStyle(.primary.opacity(caretVisible ? 1 : 0))
            }
        } else {
            Text(text)
        }
    }
}
