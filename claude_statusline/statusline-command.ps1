$input = $Input | Out-String
$data = $input | ConvertFrom-Json

$model = if ($data.model.display_name) { $data.model.display_name } else { "Unknown Model" }

$usedPct = $data.context_window.used_percentage
$tokens = if ($null -ne $usedPct) { "Context: {0:0}%" -f $usedPct } else { "Context: --" }

$thinking = $data.thinking.enabled
$effort = $data.effort.level
$outputStyle = $data.output_style.name

if ($thinking -eq $true) {
    $mode = "Thinking"
} elseif ($effort) {
    $mode = "Effort:" + (Get-Culture).TextInfo.ToTitleCase($effort)
} else {
    $mode = "Normal"
}

if ($outputStyle -and $outputStyle -ne "default" -and $outputStyle -ne "null") {
    $mode = "$mode [$outputStyle]"
}

$fiveH = $data.rate_limits.five_hour.used_percentage
$sevenD = $data.rate_limits.seven_day.used_percentage
$usage = if ($null -ne $fiveH) { "5h:{0:0}% 7d:{1:0}%" -f $fiveH, $sevenD } else { "" }

$parts = @("`e[0;36m$model`e[0m", "`e[0;33m$tokens`e[0m", "`e[0;32m$mode`e[0m")
if ($usage) { $parts += "`e[0;35m$usage`e[0m" }
Write-Host -NoNewline ($parts -join " | ")
