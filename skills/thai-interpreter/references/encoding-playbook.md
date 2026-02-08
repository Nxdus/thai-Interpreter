# Encoding Playbook

## Goal

Prevent Thai text corruption such as replacement characters (U+FFFD) or unreadable mojibake.

## Safe Write Strategy

1. Treat source content as UTF-8 from start to finish.
2. Write files with explicit UTF-8 encoding.
3. Re-open file and verify expected Thai fragments.
4. Fail fast if replacement characters are detected.

## PowerShell Commands

Write UTF-8 safely:

```powershell
$content | Set-Content -Path <file> -Encoding utf8
```

Read UTF-8 safely:

```powershell
$text = Get-Content -Path <file> -Raw -Encoding utf8
```

Detect replacement characters:

```powershell
if ($text.Contains([char]0xFFFD)) { throw "Corruption detected" }
```

## Recovery Procedure

1. Stop editing the corrupted file.
2. Recover text from the last known clean source.
3. Rewrite file using explicit UTF-8.
4. Re-run corruption checks.
5. Confirm Thai strings render correctly in editor and terminal.
