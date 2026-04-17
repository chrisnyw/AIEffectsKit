//
//  FlowLayout.swift
//  AIEffectsKit
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import SwiftUI

struct FlowLayout: Layout {
    var lineSpacing: CGFloat = 2

    struct Cache {
        var positions: [CGPoint]
        var totalHeight: CGFloat
        var width: CGFloat
        var subviewCount: Int
    }

    func makeCache(subviews: Subviews) -> Cache {
        Cache(positions: [], totalHeight: 0, width: -1, subviewCount: -1)
    }

    func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.subviewCount = -1
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        ensureCached(cache: &cache, subviews: subviews, width: width)
        return CGSize(width: width, height: cache.totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        ensureCached(cache: &cache, subviews: subviews, width: bounds.width)
        for (idx, origin) in cache.positions.enumerated() where idx < subviews.count {
            subviews[idx].place(
                at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y),
                proposal: .unspecified
            )
        }
    }

    private func ensureCached(cache: inout Cache, subviews: Subviews, width: CGFloat) {
        if cache.width == width, cache.subviewCount == subviews.count {
            return
        }
        let result = compute(subviews: subviews, width: width)
        cache.positions = result.positions
        cache.totalHeight = result.height
        cache.width = width
        cache.subviewCount = subviews.count
    }

    private func compute(subviews: Subviews, width: CGFloat) -> (positions: [CGPoint], height: CGFloat) {
        var positions: [CGPoint] = []
        positions.reserveCapacity(subviews.count)
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > width {
                x = 0
                y += lineHeight + lineSpacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            x += size.width
            lineHeight = max(lineHeight, size.height)
        }

        return (positions, y + lineHeight)
    }
}
