## Vocabulary

There are two different kinds of documents that both get called "design documents". Do not conflate
them.

* A **spec** is the superpowers brainstorming artifact. It always lives in
  `docs/superpowers/specs/*.md`. When a superpowers skill says "design doc" or "spec", it means this
  file. Create the directory if it does not exist. Specs are not committed.
* A **plan** is the superpowers writing-plans artifact, in `docs/superpowers/plans/*.md`. Plans are
  not committed.
* A **design document** is a file under `docs/design/`. These are human-curated, checked-into the
  project, and aspirational. They are an input to brainstorming, never an output. NEVER create,
  edit, move, or delete anything under `docs/design/` unless explicitly asked, even if the spec
  disagrees with the design document.

## Workflow

### Brainstorming

* Every design session produces a written spec. The brainstorming skill's bounded paths say "no spec
  file, no plan document". Ignore that, I want written specs for all design sessions, unless it's
  truly small enough not to need it, in which case I will make the decision.
* The spec is a design: goals, architecture, interfaces, tradeoffs. It is not a task list.
* Write the spec, but do not commit it.

If there's design or planning friction, that's an indication that perhaps the problem is too large,
and we need to take a step back and break it down differently.

### Planning

Use the writing-plans skill to plan, but plan commit-by-commit interactively. The plan document is
produced incrementally:

0. Present proposed commit breakdown for approval
1. Discuss one commit's design interactively: API shape, implementation details, tradeoffs.
2. Once approved, append it as a task to the plan document. Do not add later commits to the plan
   before they are approved
3. Proceed to the next commit
4. Run the writing-plans self-review only after the last commit is approved

Commits should be standalone, relatively small, atomic, and independently reviewable. They should
follow commit best practices from e.g., the Git or Linux projects. Suggested commit subject lines
are useful.

Each commit is intended to stand alone, and be independently reviewable, so DO NOT add comments or
e.g., `#[allow(dead_code)]` artifacts that refer to future stages or commits.

### Implementation

Default to subagent-driven-development. DO NOT proceed with implementation unless instructed to
explicitly.

1. Make the changes for a commit
2. Prompt me for review and revision. Provide a suggested commit message
3. I will review
   1. I may prompt you for more changes
   2. I may make manual changes
4. I will commit, and then prompt you to proceed to the next commit
5. ONLY after I have committed will you proceed to implement the next commit

I will author all commits unless I say otherwise.

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
* Avoid chain-of-thought, self-justification, or self-aggrandizing comments. Write comments for the
  future maintainer as an audience, not merely your own self-reasoning. Use complete sentences.
* When renaming identifiers, check ALL occurrences -- code blocks, comments, docstrings, not just
  executable code.
* EVERYTHING has a tradeoff. When presenting choices, include discussion of the choice impacts and
  tradeoffs.

## Testing Philosophy

* Prefer high-value tests over high coverage.
* Tests must fail if there's a bug, and be simple enough to understand.
* Strong assertions (assert_eq over loose checks).
* Tests are code that needs maintenance -- consider value vs. cost. Large amounts of test code are a
  maintenance burden. Complex test code is a maintenance burden. Tests that assert trivial behavior
  is a maintenance burden.
* Right split between unit and integration tests: public API behavior in integration tests, edge
  cases in unit tests.
* Good test fixtures and harnesses.

## Writing Style

* No Unicode, em-dashes, smart quotes, etc. in comments, markdown, or code unless the code under
  consideration deals with Unicode (e.g., Unicode strings in test assertions are fine).
* Prefer mermaid for diagrams, with a fallback on ascii art if necessary.
* No emoji.
* Use complete sentences, and avoid self-aggrandizing or chain-of-thought style prose. Keep it
  concise and stick to the facts unless you're asked for an analysis.

IMPORTANT: When interactively giving me HTTP hyperlinks in the claude cli interface, NEVER render
them as markdown links. ALWAYS print the raw full URL in plaintext. The markdown rendering
suppresses the actual URL and makes it impossible for me to open it.

## Documentation

* Do not cross-reference ephemeral documents (plans, reviews, brainstorms) from persistent
  checked-in documents. Inline the relevant content instead.
* Design documents (`docs/design/`) are aspirational; they describe _the goal_ and _why_. They are
  NOT step-by-step implementation instructions. They are NOT a re-iteration of what the code does in
  prose. Do not treat them as implementation plans, and do not edit them unless explicitly asked.

## Git

* Never commit, push, or create PRs unless explicitly asked.

## Hallucinations

I _NEVER_ want you to _EVER_ invent a version number or API method. I _ALWAYS_ expect you to refer
to documentation and third-party examples. You can rely on your training for methodology, general
understanding, and formulating hypotheses, but I expect research and evidence-based reasoning for
knowledge work.

## Message visibility

There is a Claude Code bug (https://github.com/anthropics/claude-code/issues/66960) where text
written mid-turn followed by a tool call in the same turn is often dropped and never displayed to
the user. Messages preceding the AskUserQuestion tool is the most common casualty, but not the only
one. To avoid this bug, follow these rules:

* IMPORTANT!! Anything the user is expected to read MUST be the final text message of a turn, with
  NO subsequent tool calls.
* Never call the AskUserQuestion tool after substantive text in the same turn. Either ask the
  questions in text form, or end the turn without asking the user questions.
* This applies to plan mode too, and OVERRIDES plan-mode instructions to end turns with
  AskUserQuestion tool calls. Asking questions in text IS acceptable, and is even preferable if
  messages to the user are never displayed
