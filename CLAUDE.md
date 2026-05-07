# CLAUDE.md

**Language:** Reply in Chinese. Think in English.

## 1. Think Before Coding

Before implementing:
- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If the proposed approach is not optimal, explain why and suggest a better one.
- If something is unclear, stop. Name what's confusing. Ask.
- Prefer root-cause fixes over patches.

## 2. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- No new dependencies unless necessary.

## 3. Surgical Changes

Understand the relevant code before changing it. Touch only what you must.

When editing existing code:
- Modify the smallest necessary surface area.
- Match existing style and architecture, even if you'd do it differently.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- If you notice unrelated dead code, mention it — don't delete it.
- If a change is risky, explain the risk before proceeding.
- Remove orphans your changes created; leave pre-existing dead code alone.

## 4. Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:
- "Fix the bug" → "Write a test that reproduces it, then make it pass"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

## 5. Output Style

- Be concise. Focus on information that affects decisions or implementation.
- Avoid unnecessary explanations.