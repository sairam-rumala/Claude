<img width="1471" height="332" alt="image" src="https://github.com/user-attachments/assets/c4130272-651c-43df-a6cb-2febc4c560a8" />
# Installation Guide - Claude Code PowerShell Status Line

**For: Windows Users (PowerShell or cmd.exe)**

---

## Quick Path Reference

Replace `sairam` with YOUR Windows username in all paths below:

```
C:\Users\sairam\.claude\statusline.ps1       ← Script location
C:\Users\sairam\.claude\settings.json         ← Configuration file
```

---

## Step-by-Step Installation

### **Step 1: Create the `.claude` folder**

1. Press `Windows Key + R`
2. Type: `cmd` and press Enter
3. Copy and paste this:
```cmd
mkdir "%USERPROFILE%\.claude"
```
4. Press Enter

**OR manually:**
1. Open File Explorer
2. Go to: `C:\Users\sairam`
3. Right-click → New → Folder
4. Name it: `.claude`
5. Press Enter

---

### **Step 2: Create the PowerShell script file**

1. Right-click on your Desktop
2. Select: **New → Text Document**
3. Name it: `statusline.ps1`
4. Open it with Notepad (right-click → Open with → Notepad)
5. **Copy and paste the entire script below:**

```powershell
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
```

6. Save the file (Ctrl + S)
7. **Cut this file** (Ctrl + X)
8. Navigate to: `C:\Users\sairam\.claude`
9. **Paste it** (Ctrl + V)

✅ File is now at: `C:\Users\sairam\.claude\statusline.ps1`

---

### **Step 3: Edit settings.json**

1. Open File Explorer
2. Navigate to: `C:\Users\sairam\.claude`
3. Find `settings.json` file
4. Right-click → Open with → Notepad
5. Find this section (or add it if not present):

```json
"statusLine": {
  "type": "command",
  "command": "powershell -NoProfile -File $HOME/.claude/statusline.ps1"
}
```

**Full example of what settings.json might look like:**

```json
{
  "model": "openrouter/free",
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -File $HOME/.claude/statusline.ps1"
  }
}
```

**Important:** 
- Make sure JSON is valid (no extra commas at end of lines)
- All curly braces `{}` must match
- Save the file (Ctrl + S)

---

### **Step 4: Restart Claude Code**

1. Close Claude Code completely
2. Wait 5 seconds
3. Reopen Claude Code
4. Type any message (e.g., "hello")
5. Press Enter and wait for response

**You should see:**
```
DIR ~\.claude | MODEL openrouter/free
OK [########----------] 50
```

---

## Verify Installation

### Check 1: File exists?
1. Open cmd or PowerShell
2. Run:
```powershell
Test-Path "$env:USERPROFILE\.claude\statusline.ps1"
```
Should show: `True`

### Check 2: Script works?
1. Open PowerShell
2. Run:
```powershell
powershell -NoProfile -File "$env:USERPROFILE\.claude\statusline.ps1"
```
Should show: `ERROR` (because there's no JSON input, but script ran!)

### Check 3: JSON valid?
1. Open `C:\Users\sairam\.claude\settings.json`
2. Copy everything
3. Go to: https://jsonlint.com/
4. Paste and click "Validate JSON"
5. Should show: `Valid JSON`

---

## File Locations Reference

| File | Location |
|------|----------|
| Script | `C:\Users\sairam\.claude\statusline.ps1` |
| Settings | `C:\Users\sairam\.claude\settings.json` |
| Config Folder | `C:\Users\sairam\.claude\` |
| Home Folder | `C:\Users\sairam` |

Replace `sairam` with your actual Windows username.

---

## Troubleshooting

### Problem: "Status line not showing"

**Solution 1: Check execution policy**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**Solution 2: Verify file path in settings.json**
Check that command is:
```
"command": "powershell -NoProfile -File $HOME/.claude/statusline.ps1"
```

**Solution 3: Restart Claude Code**
- Close completely (not minimized)
- Wait 10 seconds
- Reopen

**Solution 4: Check settings.json syntax**
- Open with Notepad
- Make sure no trailing commas
- Make sure all `{` have matching `}`

### Problem: "ERROR something"

This means script ran but JSON parsing failed. 

**Solution:**
- Restart Claude Code
- Run another prompt
- Check if error persists

If error persists:
1. Open settings.json
2. Check JSON syntax is valid
3. Restart Claude Code

---

## Customize the Display

### Change bar width

Open `statusline.ps1`, find:
```powershell
$barWidth = 20
```

Change to:
```powershell
$barWidth = 30  # Wider
$barWidth = 10  # Narrower
```

### Change bar characters

Find:
```powershell
if ($i -lt $filled) { $bar += "#" } else { $bar += "-" }
```

Change to:
```powershell
if ($i -lt $filled) { $bar += "=" } else { $bar += " " }
if ($i -lt $filled) { $bar += "█" } else { $bar += "░" }
```

### Change status labels

Find:
```powershell
$label = "OK"
if ($pct -ge 90) { $label = "CRIT" }
elseif ($pct -ge 75) { $label = "HIGH" }
elseif ($pct -ge 50) { $label = "WARN" }
```

Change to:
```powershell
$label = "✓ OK"
if ($pct -ge 90) { $label = "🔴 CRITICAL" }
elseif ($pct -ge 75) { $label = "🟠 HIGH" }
elseif ($pct -ge 50) { $label = "🟡 WARNING" }
```

---

## What Each Output Means

```
DIR ~\.claude | MODEL openrouter/free
OK [########----------] 50
```

| Part | Meaning |
|------|---------|
| `DIR ~\.claude` | Your current directory |
| `MODEL openrouter/free` | AI model being used |
| `OK` | Status (OK/WARN/HIGH/CRIT) |
| `[########----------]` | Progress bar (20 chars) |
| `50` | Percentage of context used |

---

## Common Questions

**Q: Why is the status line at the bottom?**  
A: It appears after every response from Claude. Scroll down to see it.

**Q: Can I move it elsewhere?**  
A: It will always appear after Claude's response due to how statusLine works.

**Q: Does it slow Claude Code?**  
A: No, it runs after responses complete. <10ms overhead.

**Q: What if I want to remove it?**  
A: Delete the `"statusLine"` section from `settings.json`.

**Q: Can I change the colors?**  
A: The simple version uses text labels (OK/WARN/HIGH/CRIT). The bar is always `#` and `-`.

---

## Getting Help

If something doesn't work:

1. **Check the troubleshooting section above**
2. **Verify file paths are correct**
3. **Make sure settings.json is valid JSON**
4. **Restart Claude Code completely**
5. **Run a new prompt** (the status appears after responses)

---

## Summary

✅ Created `.claude` folder  
✅ Saved `statusline.ps1` script  
✅ Added `statusLine` config to `settings.json`  
✅ Restarted Claude Code  
✅ Status line now shows on every response!

Done! 🎉
