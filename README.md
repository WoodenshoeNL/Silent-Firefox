# 🦊 Silent-Firefox

> Silence Firefox completely for penetration testing with Burp Suite

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat-square&logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## The Problem

When using Firefox through Burp Suite for web application testing, you'll notice **constant background noise** flooding your proxy logs:

- Telemetry pings to `telemetry.mozilla.org`
- Update checks to `aus5.mozilla.org`
- Safe browsing lookups to Google
- Captive portal checks to `detectportal.firefox.com`
- Remote settings from `firefox.settings.services.mozilla.com`
- Sponsored content from `contile.services.mozilla.com`
- And many more...

This noise makes it harder to focus on actual application traffic and can leak information during engagements.

## The Solution

**Silent-Firefox** configures Firefox to be completely silent by:

- ✅ Disabling all telemetry and data collection
- ✅ Disabling automatic updates (browser, extensions, media plugins)
- ✅ Disabling sponsored content, recommendations, and Pocket
- ✅ Disabling captive portal and connectivity checks
- ✅ Disabling safe browsing lookups (Google/Mozilla)
- ✅ Disabling remote settings, experiments, and Normandy studies
- ✅ Disabling search suggestions and Privacy Preserving Attribution
- ✅ Disabling GMP (Widevine/OpenH264) updates
- ✅ Cleaning up cached/queued telemetry pings
- ✅ Creating enterprise policies for system-wide enforcement

## Quick Start

```powershell
# Basic usage - configures all Firefox profiles
.\Silent-Firefox.ps1

# Run as Administrator for enterprise policies
Start-Process powershell -Verb RunAs -ArgumentList "-File .\Silent-Firefox.ps1"
```

## Installation

1. Clone this repository or download `Silent-Firefox.ps1`
2. Open PowerShell
3. Navigate to the script directory
4. Run the script

```powershell
git clone https://github.com/yourusername/Silent-Firefox.git
cd Silent-Firefox
.\Silent-Firefox.ps1
```

## Usage

### Basic Usage

Configure all Firefox profiles:

```powershell
.\Silent-Firefox.ps1
```

### Specific Profile

Configure a specific profile:

```powershell
.\Silent-Firefox.ps1 -ProfilePath "C:\Users\User\AppData\Roaming\Mozilla\Firefox\Profiles\abc123.default-release"
```

### Command-Line Options

| Parameter | Description |
|-----------|-------------|
| `-ProfilePath` | Specific Firefox profile path. If not provided, all profiles will be configured. |
| `-NoBackup` | Skip creating backups of existing `user.js` files. |
| `-SkipPolicies` | Skip creating enterprise policies (useful if not running as admin). |
| `-SkipCleanup` | Skip deleting cached telemetry pings. |

### Examples

```powershell
# Configure all profiles, skip backups
.\Silent-Firefox.ps1 -NoBackup

# Configure without enterprise policies (no admin required)
.\Silent-Firefox.ps1 -SkipPolicies

# Quick setup - no backup, no policies
.\Silent-Firefox.ps1 -NoBackup -SkipPolicies

# Target specific profile, keep telemetry cache
.\Silent-Firefox.ps1 -ProfilePath "C:\Path\To\Profile" -SkipCleanup
```

## Post-Installation Steps

After running the script:

1. **Close Firefox completely** (check Task Manager for `firefox.exe`)
2. **Restart Firefox**
3. **Configure proxy settings** to use Burp Suite (`127.0.0.1:8080`)
4. **Verify in Burp Suite** that background noise is gone

## What Gets Configured

### Profile-Level (`user.js`)

The script creates a `user.js` file in each Firefox profile with ~80 preferences that disable:

- Telemetry & data reporting
- Normandy studies & experiments
- Browser/extension/theme updates
- Captive portal detection
- Safe browsing lookups
- Pocket integration
- Sponsored content & ads
- Firefox Accounts & Sync
- Remote settings & blocklists
- Crash reporting
- DNS prefetching
- Geolocation services
- Search suggestions
- WebRTC IP leaks

### System-Level (`policies.json`)

When run as Administrator, the script also creates enterprise policies in:
```
C:\Program Files\Mozilla Firefox\distribution\policies.json
```

These policies provide system-wide enforcement that can't be overridden by the user.

## Reverting Changes

### Restore `user.js`

Backups are created automatically (unless `-NoBackup` is used):

```powershell
# Find backups
Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\*\user.js.backup_*"

# Restore a backup
Copy-Item "path\to\user.js.backup_20231201_120000" "path\to\user.js"
```

### Remove Enterprise Policies

Delete the policies file (requires Administrator):

```powershell
Remove-Item "C:\Program Files\Mozilla Firefox\distribution\policies.json"
```

Or simply delete the entire `distribution` folder if it was created by this script.

## Compatibility

- **Windows**: 10, 11, Server 2016+
- **PowerShell**: 5.1 or later
- **Firefox**: All modern versions (tested on 115+)

## Security Considerations

⚠️ **Important**: This script disables security features like Safe Browsing. Only use this configuration for:

- Dedicated penetration testing browsers
- Isolated testing environments
- Controlled lab scenarios

**Do not** use Silent-Firefox on your daily browsing profile.

## Troubleshooting

### "Cannot create distribution folder"

Run PowerShell as Administrator:
```powershell
Start-Process powershell -Verb RunAs -ArgumentList "-File .\Silent-Firefox.ps1"
```

### "No Firefox profiles found"

Firefox hasn't been run yet. Launch Firefox once to create a profile, then run the script again.

### Settings not taking effect

1. Ensure Firefox is completely closed (check Task Manager)
2. Check that `user.js` was created in your profile folder
3. Open `about:config` in Firefox and verify settings

## Contributing

Contributions are welcome! If you find additional preferences that should be disabled or improvements to the script, please submit a pull request.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by the need for clean proxy logs during penetration testing
- References: [Firefox Source Docs](https://firefox-source-docs.mozilla.org/), [arkenfox/user.js](https://github.com/arkenfox/user.js)

---

**Happy (quiet) hunting! 🎯**
