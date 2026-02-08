# Translation Rules

## Purpose

Provide two Thai-to-English translation modes:
- `Literal Translation` for faithful natural English
- `Execution Translation` for concise, actionable agent instructions

Default mode: `Execution Translation` unless user requests literal/direct translation.

## Mode Definitions

### Literal Translation

Use when the user wants accurate Thai-to-English conversion without compression.

Requirements:
1. Preserve meaning and tone.
2. Preserve ambiguous wording when present.
3. Preserve names, terms, and quoted literals.
4. Avoid adding unstated assumptions.

### Execution Translation

Use when the user wants efficient agent execution and lower token usage.

## Compression Template

Use this exact structure:

```
Goal: <one sentence>
Inputs: <required data only>
Constraints: <hard requirements only>
Output: <expected artifact/result>
```

## Guardrails

1. Keep user intent, legal meaning, and technical constraints intact.
2. Preserve Thai terms when translation might weaken meaning.
3. Remove redundant context that does not change execution.
4. Preserve literal content exactly:
   - Paths
   - Commands
   - IDs
   - Numeric values
   - Code snippets
5. Ask follow-up questions only when ambiguity blocks execution.

## Good Rewrite Example

Thai input (long-form):
- User explains a bug in Thai and repeats the same issue in multiple sentences.

Compact rewrite:

```
Goal: Fix Thai text corruption in output files.
Inputs: Corrupted sample text and target output file path.
Constraints: Use UTF-8 only and preserve original Thai wording.
Output: Updated file plus validation result.
```

## Literal Example

Source intent:
- User asks for direct Thai-to-English translation while preserving tone.

Literal translation:
- "Please translate this text into English while preserving the original tone."
