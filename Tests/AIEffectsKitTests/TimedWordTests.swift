//
//  TimedWordTests.swift
//  AIEffectsKitTests
//
//  Created by Chris Ng on 2026-04-22.
//  Copyright © 2026 Chris Ng. All rights reserved.
//

import Testing
import Foundation
@testable import AIEffectsKit

struct TimedWordTests {
    @Test func emptyAccumulatedProducesNoWords() {
        let words = TimedWord.words(from: "", reconciling: [])
        #expect(words.isEmpty)
    }

    @Test func splitsAccumulatedIntoWordsKeepingTrailingSpace() {
        let words = TimedWord.words(from: "Hello world", reconciling: [])
        #expect(words.count == 2)
        #expect(words[0].text == "Hello ")
        #expect(words[1].text == "world")
    }

    @Test func reconcilingPreservesExistingArrivalTimes() {
        let earlier = Date(timeIntervalSinceReferenceDate: 0)
        let initial = [
            TimedWord(id: 0, text: "Hello ", arrivedAt: earlier),
            TimedWord(id: 1, text: "world", arrivedAt: earlier)
        ]
        let later = Date(timeIntervalSinceReferenceDate: 100)
        let reconciled = TimedWord.words(
            from: "Hello world today",
            reconciling: initial,
            now: later
        )
        #expect(reconciled.count == 3)
        // "Hello " keeps its old arrival time — world does too since it was
        // in the accumulated text before (its text now includes a trailing
        // space, but position/identity is the same index).
        #expect(reconciled[0].arrivedAt == earlier)
        #expect(reconciled[1].arrivedAt == earlier)
        #expect(reconciled[2].arrivedAt == later)
        #expect(reconciled[2].text == "today")
    }

    @Test func growingWordPreservesOriginalArrival() {
        // Streaming tokens can partial-fill a word ("Hel" then "Hello").
        // The reconciler should update the text without restamping.
        let earlier = Date(timeIntervalSinceReferenceDate: 0)
        let initial = [TimedWord(id: 0, text: "Hel", arrivedAt: earlier)]
        let reconciled = TimedWord.words(
            from: "Hello",
            reconciling: initial,
            now: Date(timeIntervalSinceReferenceDate: 50)
        )
        #expect(reconciled.count == 1)
        #expect(reconciled[0].text == "Hello")
        #expect(reconciled[0].arrivedAt == earlier)
    }

    @Test func extendedGraphemeClustersAreHandled() {
        let words = TimedWord.words(from: "Héllo 👋🏽 world", reconciling: [])
        #expect(words.count == 3)
        #expect(words[0].text == "Héllo ")
        #expect(words[1].text == "👋🏽 ")
        #expect(words[2].text == "world")
    }
}
