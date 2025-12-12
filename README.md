# 🦊 Silent-Firefox

> Silence Firefox completely for penetration testing with Burp Suite

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4.0+-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-0078D6?style=flat-square&logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-GPL%203.0-blue?style=flat-square)

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

### Windows (PowerShell)

```powershell
# Basic usage - configures all Firefox profiles
.\Silent-Firefox.ps1

# Run as Administrator for enterprise policies
Start-Process powershell -Verb RunAs -ArgumentList "-File .\Silent-Firefox.ps1"
```

### Linux/Kali (Bash)

```bash
# Make executable
chmod +x silent-firefox.sh

# Basic usage - configures all Firefox profiles
./silent-firefox.sh

# Run with sudo for enterprise policies
sudo ./silent-firefox.sh
```

## Installation

### Windows

1. Clone this repository or download `Silent-Firefox.ps1`
2. Open PowerShell
3. Navigate to the script directory
4. Run the script

```powershell
git clone https://github.com/yourusername/Silent-Firefox.git
cd Silent-Firefox
.\Silent-Firefox.ps1
```

### Linux/Kali

1. Clone this repository or download `silent-firefox.sh`
2. Open a terminal
3. Navigate to the script directory
4. Make executable and run

```bash
git clone https://github.com/yourusername/Silent-Firefox.git
cd Silent-Firefox
chmod +x silent-firefox.sh
./silent-firefox.sh
```

## Usage

### Windows (PowerShell)

#### Basic Usage

Configure all Firefox profiles:

```powershell
.\Silent-Firefox.ps1
```

#### Specific Profile

Configure a specific profile:

```powershell
.\Silent-Firefox.ps1 -ProfilePath "C:\Users\User\AppData\Roaming\Mozilla\Firefox\Profiles\abc123.default-release"
```

#### Command-Line Options

| Parameter | Description |
|-----------|-------------|
| `-ProfilePath` | Specific Firefox profile path. If not provided, all profiles will be configured. |
| `-NoBackup` | Skip creating backups of existing `user.js` files. |
| `-SkipPolicies` | Skip creating enterprise policies (useful if not running as admin). |
| `-SkipCleanup` | Skip deleting cached telemetry pings. |

#### Examples

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

### Linux/Kali (Bash)

#### Basic Usage

Configure all Firefox profiles:

```bash
./silent-firefox.sh
```

#### Specific Profile

Configure a specific profile:

```bash
./silent-firefox.sh --profile ~/.mozilla/firefox/abc123.default-esr
```

#### Command-Line Options

| Option | Description |
|--------|-------------|
| `-p, --profile PATH` | Specific Firefox profile path. If not provided, all profiles will be configured. |
| `-n, --no-backup` | Skip creating backups of existing `user.js` files. |
| `-s, --skip-policies` | Skip creating enterprise policies (useful if not running as root). |
| `-c, --skip-cleanup` | Skip deleting cached telemetry pings. |
| `-h, --help` | Show help message. |

#### Examples

```bash
# Configure all profiles, skip backups
./silent-firefox.sh --no-backup

# Configure without enterprise policies (no root required)
./silent-firefox.sh --skip-policies

# Quick setup - no backup, no policies
./silent-firefox.sh --no-backup --skip-policies

# Target specific profile, keep telemetry cache
./silent-firefox.sh --profile ~/.mozilla/firefox/abc123.default-esr --skip-cleanup

# Run with sudo for enterprise policies
sudo ./silent-firefox.sh
```

## Post-Installation Steps

After running the script:

1. **Close Firefox completely**
   - Windows: Check Task Manager for `firefox.exe`
   - Linux: Run `pkill firefox` or `pkill firefox-esr`
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

When run with elevated privileges, the script also creates enterprise policies:

**Windows** (run as Administrator):
```
C:\Program Files\Mozilla Firefox\distribution\policies.json
```

**Linux/Kali** (run with sudo):
```
/usr/lib/firefox-esr/distribution/policies.json
```
or
```
/etc/firefox/policies/policies.json
```

These policies provide system-wide enforcement that can't be overridden by the user.

## Reverting Changes

### Windows

#### Restore `user.js`

Backups are created automatically (unless `-NoBackup` is used):

```powershell
# Find backups
Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\*\user.js.backup_*"

# Restore a backup
Copy-Item "path\to\user.js.backup_20231201_120000" "path\to\user.js"
```

#### Remove Enterprise Policies

Delete the policies file (requires Administrator):

```powershell
Remove-Item "C:\Program Files\Mozilla Firefox\distribution\policies.json"
```

### Linux/Kali

#### Restore `user.js`

Backups are created automatically (unless `--no-backup` is used):

```bash
# Find backups
ls ~/.mozilla/firefox/*/user.js.backup_*

# Restore a backup
cp ~/.mozilla/firefox/yourprofile/user.js.backup_20231201_120000 ~/.mozilla/firefox/yourprofile/user.js
```

#### Remove Enterprise Policies

Delete the policies file (requires root):

```bash
sudo rm /usr/lib/firefox-esr/distribution/policies.json
# or
sudo rm /etc/firefox/policies/policies.json
```

Or simply delete the entire `distribution` folder if it was created by this script.

## Compatibility

### Windows
- **OS**: Windows 10, 11, Server 2016+
- **PowerShell**: 5.1 or later
- **Firefox**: All modern versions (tested on 115+)

### Linux
- **OS**: Kali Linux, Debian, Ubuntu, and other distributions
- **Bash**: 4.0 or later
- **Firefox**: Firefox ESR, Firefox (standard), Snap, Flatpak installations

## Security Considerations

⚠️ **Important**: This script disables security features like Safe Browsing. Only use this configuration for:

- Dedicated penetration testing browsers
- Isolated testing environments
- Controlled lab scenarios

**Do not** use Silent-Firefox on your daily browsing profile.

## Troubleshooting

### Windows

#### "Cannot create distribution folder"

Run PowerShell as Administrator:
```powershell
Start-Process powershell -Verb RunAs -ArgumentList "-File .\Silent-Firefox.ps1"
```

### Linux/Kali

#### "bad interpreter: /bin/bash^M: no such file or directory"

This error occurs when the script has Windows-style line endings (CRLF). Fix it with:
```bash
sudo sed -i 's/\r$//' silent-firefox.sh
```

Or using dos2unix:
```bash
dos2unix silent-firefox.sh
```

#### "Permission denied" when writing policies

Run the script with sudo:
```bash
sudo ./silent-firefox.sh
```

#### "No Firefox profiles found" when running with sudo

This should be handled automatically, but if it occurs, specify the profile path directly:
```bash
sudo ./silent-firefox.sh --profile /home/yourusername/.mozilla/firefox/abc123.default-esr
```

### General

#### "No Firefox profiles found"

Firefox hasn't been run yet. Launch Firefox once to create a profile, then run the script again.

#### Settings not taking effect

1. Ensure Firefox is completely closed (check Task Manager on Windows, or run `pkill firefox` on Linux)
2. Check that `user.js` was created in your profile folder
3. Open `about:config` in Firefox and verify settings

## Contributing

Contributions are welcome! If you find additional preferences that should be disabled or improvements to the script, please submit a pull request.

## License

GPL 3.0 License - See [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by the need for clean proxy logs during penetration testing
- References: [Firefox Source Docs](https://firefox-source-docs.mozilla.org/), [arkenfox/user.js](https://github.com/arkenfox/user.js)

---

**Happy (quiet) hunting! 🎯**
