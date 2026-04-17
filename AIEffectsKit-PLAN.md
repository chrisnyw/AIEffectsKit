# AIEffectsKit — Project Plan & Research Notes

_Drafted 2026-04-17. Next portfolio project after Rerender._

---

## Project direction

**Pitch:** A state-driven SwiftUI library for the visual language of generative AI — glow, streaming text, thinking indicators, ripple, generation placeholders. One `AIState` publisher coherently drives every effect across the UI.

**Positioning:** *"The visual language of generative AI for SwiftUI — state-driven, Metal-accelerated, accessibility-correct."*

**Why this, why now:**
- iOS 18 `TextRenderer` API is underused; perfect for streaming-token effects.
- Apple Intelligence visual language is settling into a recognisable style (glow borders, ripple, shimmer) but no library packages it coherently.
- Pairs with existing FoundationModelsKit project — portfolio story arc, not a one-off.
- After Rerender, this turns "one nice repo" into "this person ships polished, focused tools."

**Naming candidates** (check Swift Package Index before locking):
- AIEffectsKit (descriptive fallback)
- Glimmer
- Aurora
- Spark
- Muse

---

## Market research — saturation map

Run before scoping. Check incumbents by stars, recency, scope, accessibility coverage.

### Already saturated — do not enter
| Space | Dominant incumbent | Notes |
|---|---|---|
| Liquid Glass component kits | 3× LiquidGlassKit (DnV1eX, muhittincamdali, mason-blumling) + Theseus + dambertmunoz | Name "LiquidGlassKit" taken 3×; 5+ comprehensive kits exist |
| Metal shader collections | [Inferno (twostraws)](https://github.com/twostraws/Inferno) | Paul Hudson's territory |
| Particle systems | [Vortex (twostraws)](https://github.com/twostraws/Vortex) | Hudson again |
| Ripple effects (generic) | 6+ libs incl. SwiftUIRippleEffect | All similar |
| Shimmer (generic) | [SwiftUI-Shimmer (markiv)](https://github.com/markiv/SwiftUI-Shimmer) | Default choice |
| Mesh gradient editor | [MeshBuddy (insidegui)](https://github.com/insidegui/MeshBuddy) | Guilherme Rambo |

### Contested — viable with sharp differentiation
- Holographic card — only tutorials + small demos; no polished single-purpose SPM
- Apple Intelligence glow — early, growing, weak incumbents (this is our lane)
- Mesh gradient templates — MeshingKit exists but room for opinionated kits

### AI visual effects — the gap we're entering
| Incumbent | Stars | Limitation |
|---|---|---|
| [jacobamobin/AppleIntelligenceGlowEffect](https://github.com/jacobamobin/AppleIntelligenceGlowEffect) | 275 | Only 2 effects, pure SwiftUI (quality ceiling), iPad/macOS incomplete, random-timer not state-driven |
| [metasidd/Orb](https://github.com/metasidd/Orb) | 406 | Single component, 14 commits total, last release Nov 2024, decoration-only |
| [SwiftUI-Shimmer](https://github.com/markiv/SwiftUI-Shimmer) | high | Generic, not AI-themed |
| [AnimateText](https://github.com/jasudev/AnimateText) | — | Generic text animation, not stream-aware |

**What nobody ships:** `TextRenderer`-based streaming-token effect; coherent `AIState` machine wiring effects together; FoundationModels integration; accessibility-first auto-degradation.

---

## MVP component surface

| Component | Purpose | Differentiation |
|---|---|---|
| `StreamText` | Token-by-token reveal with trailing shimmer | iOS 18 `TextRenderer`; nobody has this |
| `IntelligenceGlow` | Animated gradient border | Metal `layerEffect`, state-driven (vs. jacobamobin's timer) |
| `ThinkingIndicator` | Compact pulse for inline status | Smaller alternative to Orb; observes `AIState` |
| `AIRipple` | Tap-origin ripple | AI-themed, Apple Intelligence styling |
| `GenerationPlaceholder` | Shimmer skeleton → resolved content | Specific to generative flows |
| `AIState` env | Shared state enum (`.idle`/`.listening`/`.thinking`/`.streaming`/`.done`/`.error`) | The wiring no one else provides |

---

## Technical decisions

- **Min target:** iOS 17 broadly; iOS 18 only where `TextRenderer` is required (gate via `@available`).
- **Platforms:** iOS 17+, macOS 14+, watchOS 10+, visionOS 1+ from day 1.
- **Rendering:** Metal `layerEffect` for glow, with pure-SwiftUI fallback when `accessibilityReduceTransparency` is on.
- **Accessibility (non-negotiable):** auto-degrade on `accessibilityReduceMotion`, `accessibilityReduceTransparency`, `ProcessInfo.isLowPowerModeEnabled`. None of the incumbents do this.
- **Release cost:** zero-cost option on decorative modifiers (Rerender pattern).
- **License:** MIT.

---

## Roadmap

| Phase | Window | Deliverables | Release |
|---|---|---|---|
| **0 — Foundation** | 2–3 evenings | Repo, `Package.swift`, `AIState` skeleton, demo app target, GIF tooling, name locked | — |
| **1 — StreamText solo** | Week 1–2 | `StreamText` with `TextRenderer`, trailing shimmer, `AsyncSequence<String>` API, iOS 17 fallback, one hero GIF | **v0.1.0** |
| **2 — Core kit** | Week 3–4 | `IntelligenceGlow` (Metal), `ThinkingIndicator`, `AIState` wiring, accessibility infra, second demo GIF, DocC start | **v0.2.0** |
| **3 — Completion** | Week 5–6 | `AIRipple`, `GenerationPlaceholder`, hero demo app, FoundationModelsKit integration example, full README, DocC complete | **v1.0.0** |
| **4 — Growth** | Ongoing | Issue triage <1 wk, quarterly case study, watchOS/visionOS PRs, conference CFPs | v1.x |

### Release-by-release launch checklist

**v0.1.0 (StreamText solo):**
- [ ] Swift Package Index registration
- [ ] BlueSky/X post with hero GIF
- [ ] Submit to iOS Dev Weekly (dave@iosdevweekly.com)
- [ ] Submit to Swift Weekly Brief
- [ ] Cross-post to Swift Forums → Showcase

**v1.0.0:**
- [ ] Hacker News (Tuesday ~9am PT)
- [ ] iOS Dev Weekly resubmission
- [ ] Blog post: *"Building the visual language of AI in SwiftUI"*
- [ ] Submit to relevant awesome-swift lists

---

## Success bars & kill-switches

| Phase | Pass | Fail action |
|---|---|---|
| v0.1.0 (StreamText) | 50+ stars in 2 wks **or** 1+ unsolicited iOS-dev mention | Pause before Phase 2; don't sunk-cost |
| v1.0.0 | 200+ stars; newsletter inclusion; independent posts | Maintain for 3 months then re-evaluate |

**Other risks:**
- Scope creep into "AI Chat Kit" — keep strictly to *effects*.
- Metal shader debugging timebox: 3 days max in Phase 2; if not working, ship pure-SwiftUI and iterate Metal in v1.1.
- Naming conflict on Swift Package Index — check **before any code ships**.

---

## Research pattern (apply to every future project idea)

This is the loop that worked for AIEffectsKit. Apply it before scoping any new library:

1. **Brainstorm broad** — don't commit to a single idea yet. Generate 8–10 options across categories (devtools / components / shaders / motion / domain-specific).
2. **Map the GitHub market** — for each shortlisted idea, run parallel WebSearch for the category. Look at:
   - Top 5–10 results, their stars, last commit date.
   - Whether a known iOS dev (Hudson, Rambo, etc.) owns the lane — if yes, skip.
   - Whether the name you'd use is already taken (3× LiquidGlassKit was the canary).
3. **Rate saturation** — 🔴 saturated / 🟡 contested / 🟢 gap. Be honest. Building #6 in saturated space gets no signal.
4. **For 🟡 contested spaces** — fetch incumbents' READMEs and identify *specific* weaknesses (no Metal, no accessibility, no streaming, no state machine). Differentiation must be concrete, not vibes.
5. **Pick the differentiator that is also a moat** — e.g. `TextRenderer` streaming is a moat because it requires real engineering, not just a different colour palette.
6. **Define the kill-switch** — what failure signal at v0.1 means "stop, don't sunk-cost into v1.0"?
7. **Ship the differentiator solo first** — prove the hypothesis with the smallest possible release. Expand only after validation.

**Anti-patterns to avoid:**
- "Building a better X" without a structural advantage = me-too.
- Competing head-on with Hudson/Rambo on their core territory.
- Naming clashes — always check Swift Package Index first.
- Skipping accessibility ("v1.1 problem") — it's both ethically right and a recruiter signal.
- Big-bang v1.0 release with no public iteration in between.

---

## Immediate next steps

1. Check Swift Package Index for naming collisions on the 5 candidates.
2. Lock name.
3. Create empty repo, push Phase 0 skeleton.
4. Prototype `StreamText` with `TextRenderer` — one afternoon to validate API shape.
