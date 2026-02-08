param(
  [Parameter(Mandatory = $true)]
  [string]$OutputPath,
  [string]$InputPath,
  [string]$Text
)

$ErrorActionPreference = "Stop"

if (-not $InputPath -and -not $Text) {
  throw "Provide either -InputPath or -Text."
}

if ($InputPath -and $Text) {
  throw "Use only one input source: -InputPath or -Text."
}

if ($InputPath) {
  if (-not (Test-Path -LiteralPath $InputPath)) {
    throw "InputPath not found: $InputPath"
  }
  $resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
  $bytes = [System.IO.File]::ReadAllBytes($resolvedInput)
  $content = [System.Text.Encoding]::UTF8.GetString($bytes)
} else {
  $content = $Text
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($OutputPath, $content, $utf8NoBom)

$verify = Get-Content -LiteralPath $OutputPath -Raw -Encoding utf8
if ($verify.Contains([char]0xFFFD)) {
  throw "Write completed but corruption marker found in output."
}

Write-Host "Wrote UTF-8 text safely to: $OutputPath"
