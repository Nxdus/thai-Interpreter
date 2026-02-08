param(
  [Parameter(Mandatory = $true)]
  [string]$Path,
  [string[]]$Include = @("*.md", "*.txt", "*.json", "*.yaml", "*.yml", "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.css")
)

$ErrorActionPreference = "Stop"

function Test-MojibakePattern {
  param([string]$Text)

  if ([string]::IsNullOrEmpty($Text)) { return $false }

  # Common corruption markers from bad UTF-8 decoding.
  $patterns = @(
    [char]0xFFFD,      # replacement character
    "à¸",              # Thai UTF-8 bytes interpreted as latin-1
    "à¹",
    "àº",
    "à»",
    "â€",
    "ã€"
  )

  foreach ($p in $patterns) {
    if ($Text.Contains($p)) { return $true }
  }
  return $false
}

if (-not (Test-Path -LiteralPath $Path)) {
  throw "Path not found: $Path"
}

$targetFiles = @()
if ((Get-Item -LiteralPath $Path).PSIsContainer) {
  foreach ($pattern in $Include) {
    $targetFiles += Get-ChildItem -LiteralPath $Path -Recurse -File -Filter $pattern
  }
} else {
  $targetFiles = @(Get-Item -LiteralPath $Path)
}

$targetFiles = $targetFiles | Sort-Object -Property FullName -Unique

$issues = @()
foreach ($file in $targetFiles) {
  try {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    if (Test-MojibakePattern -Text $text) {
      $issues += $file.FullName
    }
  } catch {
    $issues += "$($file.FullName) (read error: $($_.Exception.Message))"
  }
}

if ($issues.Count -gt 0) {
  Write-Host "Found potential Thai encoding issues in:"
  $issues | ForEach-Object { Write-Host " - $_" }
  exit 2
}

Write-Host "No obvious Thai encoding corruption detected."
exit 0
