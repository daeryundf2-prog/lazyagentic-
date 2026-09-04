$base = "C:\Users\HP\.gemini\config\plugins\lazyagentic"
$junction = "C:\Users\HP\agentic"

Write-Host "=== TEST 1: Junction Path Integrity ==="
if ((Test-Path $junction) -and (Test-Path "$junction\rules")) {
    Write-Host "[PASS] Junction $junction exists and is readable" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Junction not accessible" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== TEST 2: File Length (<10k chars) & Existence ==="
$ruleFiles = Get-ChildItem -Path "$base\rules" -Filter "*.md"
$allPassed = $true
foreach ($file in $ruleFiles) {
    $len = (Get-Content $file.FullName -Raw).Length
    if ($len -gt 10000) {
        Write-Host "[FAIL] $($file.Name) length: $len chars (exceeds 10k)" -ForegroundColor Red
        $allPassed = $false
    } else {
        Write-Host "[PASS] $($file.Name): $len chars (within limit)" -ForegroundColor Green
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