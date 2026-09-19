$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

try {
    $data = $inputJson | ConvertFrom-Json

    $cwd = $null
    if ($data.workspace -and $data.workspace.current_dir) {
        $cwd = $data.workspace.current_dir
    }
    elseif ($data.cwd) {
        $cwd = $data.cwd
    }
    if (-not $cwd) {
        $cwd = (Get-Location).Path
    }

    $homePath = $env:USERPROFILE
    if ($cwd -and $homePath -and $cwd.StartsWith($homePath)) {
        $cwd = "~" + $cwd.Substring($homePath.Length)
    }

    $model = "unknown"
    if ($data.model) {
        if ($data.model.display_name) { $model = $data.model.display_name }
        elseif ($data.model.id) { $model = $data.model.id }
    }

    $pct = 0
    if ($data.context_window -and $data.context_window.used_percentage -ne $null) {
        $pct = [int]$data.context_window.used_percentage
    }

    $barWidth = 20
    $filled = [Math]::Floor(($pct / 100) * $barWidth)
    if ($filled -lt 0) { $filled = 0 }
    if ($filled -gt $barWidth) { $filled = $barWidth }

    $bar = ""
    for ($i = 0; $i -lt $barWidth; $i++) {
        if ($i -lt $filled) { $bar += "#" } else { $bar += "-" }
    }

    $label = "OK"
    if ($pct -ge 90) { $label = "CRIT" }
    elseif ($pct -ge 75) { $label = "HIGH" }
    elseif ($pct -ge 50) { $label = "WARN" }

    Write-Host "DIR $cwd | MODEL $model"
    Write-Host "$label [$bar] $pct"
    exit 0
}
catch {
    Write-Host "ERROR $($_.Exception.Message)"
    exit 1
}
