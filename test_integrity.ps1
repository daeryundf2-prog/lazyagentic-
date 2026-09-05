# Test script for lazyagentic
$base = "C:\Users\HP\.gemini\config\plugins\lazyagentic"
$junction = "C:\Users\HP\agentic"
$maxLines = 800
$maxBytes = 46080
$maxChars = 10000

Write-Host "=== TEST 1: Junction Path Integrity ==="
if ((Test-Path $junction) -and (Test-Path "$junction\rules")) {
    Write-Host "[PASS] Junction $junction exists and is readable" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Junction not accessible" -ForegroundColor Red
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
    if ((Test-Path $target1) -and (Test-Path $target2)) {
        Write-Host "[PASS] Target exists: $relPath" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Missing target: $relPath" -ForegroundColor Red
        $allPassed = $false
    }
}

Write-Host "`n=== TEST 4: Global GEMINI.md Entry Point Resolution ==="
$globalGemini = "C:\Users\HP\.gemini\config\GEMINI.md"
if (Test-Path $globalGemini) {
    Write-Host "[PASS] Global GEMINI.md exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Global GEMINI.md missing" -ForegroundColor Red
    $allPassed = $false
}

if ($allPassed) {
    Write-Host "`n>>> ALL LAZYAGENTIC TESTS PASSED <<<" -ForegroundColor Cyan
} else {
    Write-Host "`n>>> SOME TESTS FAILED <<<" -ForegroundColor Red
    exit 1
}
