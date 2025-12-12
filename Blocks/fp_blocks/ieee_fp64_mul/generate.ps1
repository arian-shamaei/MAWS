# Invoke the Berkeley HardFloat generator for this block.
$ErrorActionPreference = "Stop"
$blockRoot = $PSScriptRoot
$fpBlocksRoot = Split-Path -Parent $blockRoot
$blocksRoot = Split-Path -Parent $fpBlocksRoot
$hfCandidates = @(
  (Join-Path (Join-Path $blocksRoot "generators") "berkeley-hardfloat"),
  (Join-Path (Join-Path (Join-Path $blocksRoot "generators") "berkeley-hardfloat-master") "berkeley-hardfloat-master")
)
$hfRoot = $null
foreach ($cand in $hfCandidates) {
  if (Test-Path $cand) {
    $hfRoot = $cand
    break
  }
}
if (-not $hfRoot) {
  throw "Berkeley HardFloat not found. Run python scripts/bootstrap_hardfloat.py before regenerating RTL."
}
Push-Location $hfRoot
try {
  if (Get-Command sbt -ErrorAction SilentlyContinue) {
    sbt "runMain hardfloat.Emitieee_fp64_mul ../../fp_blocks/ieee_fp64_mul/rtl"
  } elseif (Test-Path "sbt-launch.jar") {
    java -jar sbt-launch.jar "runMain hardfloat.Emitieee_fp64_mul ../../fp_blocks/ieee_fp64_mul/rtl"
  } else {
    throw "sbt not found and no sbt-launch.jar present"
  }
  if ($LASTEXITCODE -ne 0) { throw "sbt failed" }
} finally {
  Pop-Location
}
