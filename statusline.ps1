# Status line with token count (simple version)
$input_json = [Console]::In.ReadToEnd()
if (-not $input_json) { exit }

try {
    $data = $input_json | ConvertFrom-Json
    
    # Get current directory
    $cwd = $data.workspace.current_dir
    if (-not $cwd) { $cwd = (Get-Location).Path }
    
    # Shorten path to home
    $home_path = $env:USERPROFILE
    if ($cwd.StartsWith($home_path)) {
        $cwd = "~" + $cwd.Substring($home_path.Length)
    }
    
    # Get model
    $model = $data.model.id
    
    # Get token counts
    $total_input = $data.context_window.total_input_tokens
    $total_output = $data.context_window.total_output_tokens
    $ctx_size = $data.context_window.context_window_size
    
    # Calculate total tokens used
    $total_tokens = $total_input + $total_output
    
    # Format large numbers with K (e.g., 38.5k)
    if ($total_tokens -ge 1000) {
        $formatted = "{0:N1}k" -f ($total_tokens / 1000)
    } else {
        $formatted = $total_tokens
    }
    
    $ctx_size_k = $ctx_size / 1000
    
    # Simple output without color codes
    Write-Host "$cwd | $model | ContextWindow: $formatted"
}
catch {
    Write-Host "error"
}