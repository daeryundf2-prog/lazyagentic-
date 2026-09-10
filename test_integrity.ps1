# Test script for lazyagentic (Windows PowerShell)
# Usage: .\test_integrity.ps1 [-BasePath <plugin-dir>] [-Junction <junction-dir>]
param(
    [string]$BasePath = (Join-Path $env:USERPROFILE ".gemini\config\plugins\lazyagentic"),
    [string]$Junction = (Join-Path $env:USERPROFILE "agentic")
)
$base = $BasePath
$junction = $Junction
$maxLines = 800
$maxBytes = 46080
$maxChars = 12000

Write-Host "=== TEST 1: Junction Path Integrity ==="
Write-Host "base=$base junction=$junction"
if ((Test-Path $junction) -and (Test-Path "$junction\rules")) {
    Write-Host "[PASS] Junction $junction exists and is readable" -ForegroundColor Green
} elseif ((Test-Path "$base\rules")) {
    Write-Host "[WARN] Junction missing — falling back to plugin path $base (see README Dual-Mount)" -ForegroundColor Yellow
} else {
    Write-Host "[FAIL] Neither junction nor plugin path readable" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== TEST 2: Rule File Integrity & Tool Capacity Audit (rules/) ==="
Write-Host "Single tool call limit ($maxLines lines, $maxBytes bytes, $maxChars chars):`n"
$ruleFiles = Get-ChildItem -Path "$base\rules" -Filter "*.md" | Sort-Object Name
$allPassed = $true

Write-Host ("{0,-30} | {1,8} | {2,10} | {3,22} | {4,15}" -f "Rule File", "Lines", "Bytes", "Tool Headroom", "Status")
Write-Host ("-" * 95)

foreach ($file in $ruleFiles) {
    $raw = Get-Content $file.FullName -Raw
    $lines = (Get-Content $file.FullName).Count
    $bytes = (Get-Item $file.FullName).Length
    $chars = $raw.Length

    $remainLines = $maxLines - $lines
    $remainKB = [math]::Round(($maxBytes - $bytes) / 1024, 1)

    if ($lines -le $maxLines -and $bytes -le $maxBytes -and $chars -le $maxChars) {
        $status = "[PASS] Complete"
        $lineRemainStr = "$remainLines lines, $remainKB KB"
        Write-Host ("{0,-30} | {1,6} L | {2,8} B | {3,18} free | {4,15}" -f $file.Name, $lines, $bytes, $lineRemainStr, $status) -ForegroundColor Green
    } else {
        $status = "[FAIL] Exceeded"
        $allPassed = $false
        Write-Host ("{0,-30} | {1,6} L | {2,8} B | {3,18} free | {4,15}" -f $file.Name, $lines, $bytes, "Over limit", $status) -ForegroundColor Red
    }
}

Write-Host "`n=== TEST 3: RULES.md Reference Link Target Validation ==="
$rulesContent = Get-Content "$base\RULES.md" -Raw
$matches = [regex]::Matches($rulesContent, '\[~/agentic/(rules/[^\]]+)\]')
foreach ($m in $matches) {
    $relPath = $m.Groups[1].Value
    $target1 = Join-Path $base $relPath
    $target2 = Join-Path $junction $relPath
    if ((Test-Path $target1) -or (Test-Path $target2)) {
        Write-Host "[PASS] Target exists: $relPath" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Missing target: $relPath" -ForegroundColor Red
        $allPassed = $false
    }
}

# 제목-파일명 정합성: 04 파일의 첫 제목이 # 04. 로 시작하는지 등
Write-Host "`n=== TEST 3b: Rule File Title Consistency ==="
foreach ($file in $ruleFiles) {
    if ($file.Name -match '^(\d+)-') {
        $num = $Matches[1]
        $first = (Get-Content $file.FullName -TotalCount 1)
        if ($first -match "^#\s*$num\.") {
            Write-Host "[PASS] Title matches: $($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Title mismatch: $($file.Name) -> '$first'" -ForegroundColor Red
            $allPassed = $false
        }
    }
}

Write-Host "`n=== TEST 4: Global GEMINI.md Entry Point Resolution ==="
$globalGemini = Join-Path (Split-Path (Split-Path $base -Parent) -Parent) "GEMINI.md"
# $base=~/.gemini/config/plugins/lazyagentic -> global dir = ~/.gemini/config
if (Test-Path $globalGemini) {
    Write-Host "[PASS] Global GEMINI.md exists ($globalGemini)" -ForegroundColor Green
} else {
    Write-Host "[WARN] Global GEMINI.md missing ($globalGemini) — plugin path still usable" -ForegroundColor Yellow
}

if ($allPassed) {
    Write-Host "`n>>> ALL LAZYAGENTIC TESTS PASSED <<<" -ForegroundColor Cyan
} else {
    Write-Host "`n>>> SOME TESTS FAILED <<<" -ForegroundColor Red
    exit 1
}
