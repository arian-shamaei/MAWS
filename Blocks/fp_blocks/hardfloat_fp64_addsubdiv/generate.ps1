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
    sbt "runMain hardfloat.Emithardfloat_fp64_addsubdiv ../../fp_blocks/hardfloat_fp64_addsubdiv/rtl"
  } elseif (Test-Path "sbt-launch.jar") {
    java -jar sbt-launch.jar "runMain hardfloat.Emithardfloat_fp64_addsubdiv ../../fp_blocks/hardfloat_fp64_addsubdiv/rtl"
  } else {
    throw "sbt not found and no sbt-launch.jar present"
  }
  if ($LASTEXITCODE -ne 0) { throw "sbt failed" }
} finally {
  Pop-Location
}
