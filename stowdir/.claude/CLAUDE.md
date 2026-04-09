These are preferences, not absolutes. If there's a good reason to break a rule, that's okay, but
surface it and discuss before doing so.

## Workflow

I work in three phases. Each phase involves iteration and back-and-forth conversation before moving
to the next. IMPORTANT: Never proceed to the next phase or stage without explicit approval!

1. **Design** -- Iterate on design documents through conversation. Explore the problem space, goals,
   architecture, UX, tradeoffs. This may span multiple sessions and produce multiple design
   documents. This is NOT planning or implementation.
2. **Implementation Design** -- Iterate on the specific software design: types, functions, patterns,
   module structure, testing strategy. Depending on the scope of the design, the artifact may be an
   additional design document, or it might culminate with an implementation plan.

   If the code being design is a CLI tool, I often prefer to start the plan with the CLI arguments,
   and start the implementation by implementing the argument parsing, then iterating from there.
3. **Implementation** -- Strong preference to start from a plan document unless the changes are
   small and well-scoped. Strong preference to split implementation into stages, where each stage
   can be an atomic coherent commit. Each stage is reviewed, guided, and committed by me before
   moving to the next.

Design sessions and implementation sessions are different modes -- don't mix them.

## Collaboration

* Show reasoning and tradeoffs when they apply. Engineering is the art of making tradeoffs to solve
  constrained problems -- help me understand them and make decisions.
* Push back when you think my direction is suboptimal, with evidence. But if I make a decision after
  the pushback, follow it without re-raising the same concern, unless new information or patterns
  emerge that change the calculus.
* Ask rather than guess when uncertain. I prefer interactive conversations over guess-and-check.
* When debugging, enumerate multiple hypotheses before committing to one. When corrected on a
  technical assumption, re-examine the problem from scratch rather than patching the original
  analysis.

## Code Philosophy

* Prefer simple data structures and algorithms. Code is read more often than it's written, so
  consider maintenance costs.
* Minimize abstractions -- no unnecessary macros, helpers, indirection, or complex types when
  simpler alternatives exist. Pay attention to boilerplate. We don't need to eliminate boilerplate
  at all costs, but when there's opportunities to reduce it that don't increase the cognitive
  burden, consider them.
* To a degree, every line of code is a liability; earn its place. Verbosity is a smell, as is tons
  and tons of comments.
* Comments should strive to explain _why_, not _what_ -- and only when the why isn't obvious.
* When renaming identifiers, check ALL occurrences -- code blocks, comments, docstrings, not just
  executable code.

## Testing Philosophy

* Prefer high-value tests over high coverage.
* Tests must fail if there's a bug, and be simple enough to understand.
* Strong assertions (assert_eq over loose checks).
* Tests are code that needs maintenance -- consider value vs. cost.
* Right split between unit and integration tests: public API behavior in integration tests, edge
  cases in unit tests.
* Good test fixtures and harnesses.

## Writing Style

* No Unicode, em-dashes, smart quotes, etc. in comments, markdown, or code unless the code under
  consideration deals with Unicode (e.g., Unicode strings in test assertions are fine).
* Prefer mermaid for diagrams, with a fallback on ascii art if necessary.
* No emoji.

## Documentation

* Do not cross-reference ephemeral documents (plans, reviews, brainstorms) from persistent
  documents. Inline the relevant content instead.
* Design documents describe _what_ and _why_, not step-by-step implementation instructions. Do not
  treat them as implementation plans.

## Git

* Never commit, push, or create PRs unless explicitly asked. Committing is an act of approval that
  only I can perform.
