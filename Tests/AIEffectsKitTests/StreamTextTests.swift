//
//  StreamTextTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-17.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
@testable import AIEffectsKit

struct StreamTextTests {
    @Test func typingStreamYieldsCharactersInOrder() async {
        var collected = ""
        for await character in typingStream(text: "Hello", interval: .zero) {
            collected += character
        }
        #expect(collected == "Hello")
    }

    @Test func typingStreamIsEmptyForEmptyInput() async {
        var count = 0
        for await _ in typingStream(text: "", interval: .zero) {
            count += 1
        }
        #expect(count == 0)
    }

    @Test func typingStreamPreservesExtendedGraphemeClusters() async {
        let source = "Héllo 👋🏽"
        var collected = ""
        for await character in typingStream(text: source, interval: .zero) {
            collected += character
        }
        #expect(collected == source)
    }

}
