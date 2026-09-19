# Status Line with Token Count

A lightweight PowerShell script that displays a status line with working directory, model information, and token usage statistics. Perfect for integrating into development environments or AI assistant workflows.

## Features

- 📁 **Current Directory Display** - Shows your working directory with home path shortcuts
- 🤖 **Model Information** - Displays the active model ID
- 📊 **Token Count Tracking** - Shows total input and output tokens used
- 📐 **Context Window Monitor** - Displays remaining context window capacity
- 🎯 **Human-Readable Formatting** - Automatically formats large numbers (e.g., 38.5k)
- ⚡ **Minimal Dependencies** - Pure PowerShell, no external requirements

## Installation

1. Download or clone this repository
2. Place `statusline.ps1` in your preferred scripts directory
3. Update your PowerShell profile or call the script from your application

```powershell
# Add to your PowerShell profile
. "C:\path\to\statusline.ps1"
```

## Usage

The script accepts JSON input via stdin containing workspace and model context information:

```powershell
$input | .\statusline.ps1
```

### Input Format

The script expects JSON input with the following structure:

```json
{
  "workspace": {
    "current_dir": "/home/user/projects/myapp"
  },
  "model": {
    "id": "claude-sonnet-4"
  },
  "context_window": {
    "total_input_tokens": 5000,
    "total_output_tokens": 2500,
    "context_window_size": 200000
  }
}
```

### Output

```
~/projects/myapp | claude-sonnet-4 | ContextWindow: 7.5k
```

## How It Works

1. **Reads JSON from stdin** - Parses structured context data
2. **Normalizes paths** - Converts full home directory paths to `~` shorthand
3. **Calculates token usage** - Sums input and output tokens
4. **Formats output** - Displays metrics in human-readable format
5. **Error handling** - Gracefully handles invalid input with error messages

## Error Handling

If the script encounters invalid JSON or missing fields, it will display an error message instead of crashing:

```
error
```

## Customization

You can easily modify the output format by editing the `Write-Host` line:

```powershell
# Current format
Write-Host "$cwd | $model | ContextWindow: $formatted"

# Custom format example
Write-Host "📍 $cwd | 🤖 $model | 📊 Tokens: $formatted/$ctx_size_k`k"
```

## Use Cases

- **IDE Integration** - Display token usage in your editor's status bar
- **AI Assistant Workflows** - Monitor context consumption in scripted environments
- **Development Dashboards** - Track resource usage across sessions
- **Automation Scripts** - Monitor token allocation in batch processing

## Requirements

- PowerShell 3.0 or higher
- Input JSON with the expected schema

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

**Note:** This script is designed to be simple and lightweight. It assumes well-formed JSON input and does minimal validation.
<img width="1460" height="245" alt="Screenshot 2026-09-20 010331" src="https://github.com/user-attachments/assets/8ebc5d83-01b2-40f0-adc5-bb56f297b130" />
