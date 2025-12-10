<#
.SYNOPSIS
    Silences Firefox completely for penetration testing with Burp Suite.

.DESCRIPTION
    This script configures Firefox to be completely silent during pentesting by:
    - Disabling all telemetry and data collection
    - Disabling automatic updates (browser, extensions, media plugins)
    - Disabling sponsored content, recommendations, and Pocket
    - Disabling captive portal and connectivity checks
    - Disabling safe browsing lookups
    - Disabling remote settings, experiments, and Normandy studies
    - Disabling search suggestions and Privacy Preserving Attribution
    - Disabling GMP (Widevine/OpenH264) updates
    - Cleaning up cached/queued telemetry pings
    - Creating enterprise policies for system-wide enforcement

.PARAMETER ProfilePath
    Specific Firefox profile path. If not provided, all profiles will be configured.

.PARAMETER NoBackup
    Skip creating backups of existing user.js files.

.PARAMETER SkipPolicies
    Skip creating enterprise policies (useful if not running as admin).

.PARAMETER SkipCleanup
    Skip deleting cached telemetry pings.

.EXAMPLE
    .\Silent-Firefox.ps1

.EXAMPLE
    .\Silent-Firefox.ps1 -ProfilePath "C:\Users\User\AppData\Roaming\Mozilla\Firefox\Profiles\abc123.default-release"

.EXAMPLE
    .\Silent-Firefox.ps1 -NoBackup -SkipPolicies

.NOTES
    Author: Silent-Firefox Project
    Version: 1.0
    Run this script before starting a new pentest engagement.
    Restart Firefox after running for changes to take effect.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ProfilePath,

    [Parameter(Mandatory = $false)]
    [switch]$NoBackup,

    [Parameter(Mandatory = $false)]
    [switch]$SkipPolicies,

    [Parameter(Mandatory = $false)]
    [switch]$SkipCleanup
)

# ============================================================================
# CONFIGURATION: All Firefox Silent Preferences
# ============================================================================

$SilentPreferences = @"
// ============================================================================
// Firefox Silent Configuration for Pentesting
// Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
// ============================================================================

// === TELEMETRY & DATA COLLECTION ===
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.sessions.current.clean", true);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.server_owner", "");
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// === EXPERIMENTS & NORMANDY STUDIES ===
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("experiments.enabled", false);
user_pref("experiments.supported", false);
user_pref("experiments.activeExperiment", false);
user_pref("network.allow-experiments", false);

// === UPDATES (Browser, Extensions, Search, Themes) ===
user_pref("app.update.enabled", false);
user_pref("app.update.auto", false);
user_pref("app.update.service.enabled", false);
user_pref("app.update.staging.enabled", false);
user_pref("app.update.silent", false);
user_pref("extensions.update.enabled", false);
user_pref("extensions.update.autoUpdateDefault", false);
user_pref("browser.search.update", false);
user_pref("lightweightThemes.update.enabled", false);

// === CAPTIVE PORTAL & CONNECTIVITY CHECKS ===
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);
user_pref("network.connectivity-check.enabled", false);
user_pref("network.connectivity-check.IPv4.url", "");
user_pref("network.connectivity-check.IPv6.url", "");

// === SAFE BROWSING (Google/Mozilla Lookups) ===
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.passwords.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.mozilla.updateURL", "");
user_pref("browser.safebrowsing.provider.mozilla.gethashURL", "");

// === POCKET ===
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.api", "");
user_pref("extensions.pocket.site", "");

// === SPONSORED CONTENT & ADS ===
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("browser.promo.focus.enabled", false);

// === FIREFOX ACCOUNTS & SYNC ===
user_pref("identity.fxaccounts.enabled", false);
user_pref("identity.fxaccounts.toolbar.enabled", false);
user_pref("services.sync.prefs.sync.browser.safebrowsing.downloads.remote.enabled", false);

// === REMOTE SETTINGS & CONTENT SIGNATURES ===
// (Stops firefox.settings.services.mozilla.com)
user_pref("services.settings.server", "");
user_pref("services.settings.default_signer", "");
user_pref("security.remote_settings.crlite_filters.enabled", false);
user_pref("security.remote_settings.intermediates.enabled", false);

// === BLOCKLIST & REMOTE UPDATES ===
user_pref("extensions.blocklist.enabled", false);
user_pref("extensions.blocklist.url", "");
user_pref("services.blocklist.update_enabled", false);
user_pref("services.blocklist.onecrl.collection", "");
user_pref("services.blocklist.addons.collection", "");
user_pref("services.blocklist.plugins.collection", "");
user_pref("services.blocklist.gfx.collection", "");

// === FIREFOX MONITOR (Stops fxmonitor-breaches) ===
user_pref("extensions.fxmonitor.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("signon.management.page.breachAlertUrl", "");

// === TOP SITES & TIPPYTOP ICONS ===
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.contile.endpoint", "");
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// === MESSAGING SYSTEM (What's New, etc.) ===
user_pref("browser.newtabpage.activity-stream.asrouter.providers.whats-new-panel", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.cfr", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.message-groups", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.messaging-experiments", "");
user_pref("messaging-system.rsexperimentloader.enabled", false);

// === CRASH REPORTS ===
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// === PREFETCH & DNS ===
user_pref("network.predictor.enabled", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// === WEBRTC (Leak Prevention) ===
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);

// === GEOLOCATION ===
user_pref("geo.enabled", false);
user_pref("geo.provider.network.url", "");
user_pref("geo.provider.ms-windows-location", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

// === EXTENSION RECOMMENDATIONS ===
user_pref("browser.discovery.enabled", false);
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// === SEARCH SUGGESTIONS (Stops google.com/complete/search) ===
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.calculator", false);
user_pref("browser.urlbar.suggest.topsites", false);

// === PRIVACY PRESERVING ATTRIBUTION (Stops mozgcp.net / OHTTP) ===
user_pref("dom.private-attribution.submission.enabled", false);

// === GECKO MEDIA PLUGINS (Stops aus5.mozilla.org/update/3/GMP) ===
user_pref("media.gmp-manager.url", "");
user_pref("media.gmp-manager.updateEnabled", false);
user_pref("media.gmp-provider.enabled", false);

// === ADDITIONAL NOISE REDUCTION ===
user_pref("extensions.webcompat-reporter.enabled", false);
user_pref("extensions.abuseReport.enabled", false);
user_pref("browser.uitour.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");

// === PERFORMANCE (Keep caching enabled for usability) ===
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.memory.enable", true);

// ============================================================================
// End of Silent Configuration
// ============================================================================
"@

# ============================================================================
# FUNCTIONS
# ============================================================================

function Write-Banner {
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║           FIREFOX SILENT - Pentesting Mode                ║" -ForegroundColor Cyan
    Write-Host "  ║         Silence Firefox for Burp Suite Usage              ║" -ForegroundColor Cyan
    Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Get-FirefoxProfiles {
    <#
    .SYNOPSIS
        Finds all Firefox profile directories
    #>
    $firefoxProfilesPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    
    if (Test-Path $firefoxProfilesPath) {
        $profiles = Get-ChildItem -Path $firefoxProfilesPath -Directory
        return $profiles
    }
    return $null
}

function Set-FirefoxSilentPreferences {
    <#
    .SYNOPSIS
        Creates/updates user.js with silent preferences
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProfileDirectory
    )
    
    $userJsPath = Join-Path $ProfileDirectory "user.js"
    
    # Backup existing user.js if it exists and backup is enabled
    if (-not $NoBackup -and (Test-Path $userJsPath)) {
        $backupPath = "$userJsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $userJsPath $backupPath
        Write-Host "  [+] Backed up existing user.js to: $backupPath" -ForegroundColor DarkGray
    }
    
    # Write preferences to user.js
    Set-Content -Path $userJsPath -Value $SilentPreferences -Encoding UTF8
    Write-Host "  [+] Created/updated user.js" -ForegroundColor Green
}

function Clear-TelemetryPings {
    <#
    .SYNOPSIS
        Deletes cached/queued telemetry pings from disk
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProfileDirectory
    )
    
    $pingFolders = @(
        "saved-telemetry-pings",
        "datareporting\archived",
        "datareporting\active"
    )
    
    $cleaned = $false
    foreach ($folder in $pingFolders) {
        $target = Join-Path -Path $ProfileDirectory -ChildPath $folder
        if (Test-Path $target) {
            $items = Get-ChildItem -Path $target -ErrorAction SilentlyContinue
            if ($items) {
                Remove-Item -Path "$target\*" -Recurse -Force -ErrorAction SilentlyContinue
                $cleaned = $true
            }
        }
    }
    
    if ($cleaned) {
        Write-Host "  [+] Cleared cached telemetry pings" -ForegroundColor Yellow
    }
}

function Set-FirefoxEnterprisePolicy {
    <#
    .SYNOPSIS
        Creates enterprise policies.json for system-wide enforcement
    #>
    
    # Find Firefox installation
    $firefoxPaths = @(
        "${env:ProgramFiles}\Mozilla Firefox",
        "${env:ProgramFiles(x86)}\Mozilla Firefox"
    )
    
    $firefoxInstallPath = $null
    foreach ($path in $firefoxPaths) {
        if (Test-Path $path) {
            $firefoxInstallPath = $path
            break
        }
    }
    
    if (-not $firefoxInstallPath) {
        Write-Host "  [-] Firefox installation not found. Skipping enterprise policies." -ForegroundColor Yellow
        return $false
    }
    
    $distributionPath = Join-Path $firefoxInstallPath "distribution"
    
    # Create distribution folder if needed
    if (-not (Test-Path $distributionPath)) {
        try {
            New-Item -ItemType Directory -Path $distributionPath -Force | Out-Null
        }
        catch {
            Write-Host "  [-] Cannot create distribution folder (need admin rights?). Skipping policies." -ForegroundColor Yellow
            return $false
        }
    }
    
    $policiesPath = Join-Path $distributionPath "policies.json"
    
    $policies = @{
        policies = @{
            DisableTelemetry                = $true
            DisableFirefoxStudies           = $true
            DisablePocket                   = $true
            DisableFirefoxAccounts          = $true
            DisableSetDesktopBackground     = $true
            DisableMasterPasswordCreation   = $false
            DisableAppUpdate                = $true
            DisableSystemAddonUpdate        = $true
            DontCheckDefaultBrowser         = $true
            DisplayBookmarksToolbar         = $false
            NoDefaultBookmarks              = $true
            OverrideFirstRunPage            = ""
            OverridePostUpdatePage          = ""
            CaptivePortal                   = $false
            NetworkPrediction               = $false
            DNSOverHTTPS                    = @{
                Enabled = $false
            }
            Preferences                     = @{
                "network.captive-portal-service.enabled"        = @{
                    Value  = $false
                    Status = "locked"
                }
                "network.connectivity-service.enabled"          = @{
                    Value  = $false
                    Status = "locked"
                }
                "datareporting.policy.dataSubmissionEnabled"    = @{
                    Value  = $false
                    Status = "locked"
                }
                "toolkit.telemetry.enabled"                     = @{
                    Value  = $false
                    Status = "locked"
                }
                "browser.safebrowsing.malware.enabled"          = @{
                    Value  = $false
                    Status = "locked"
                }
                "browser.safebrowsing.phishing.enabled"         = @{
                    Value  = $false
                    Status = "locked"
                }
                "dom.private-attribution.submission.enabled"    = @{
                    Value  = $false
                    Status = "locked"
                }
                "services.settings.server"                      = @{
                    Value  = ""
                    Status = "locked"
                }
                "extensions.blocklist.enabled"                  = @{
                    Value  = $false
                    Status = "locked"
                }
                "extensions.fxmonitor.enabled"                  = @{
                    Value  = $false
                    Status = "locked"
                }
                "browser.topsites.contile.enabled"              = @{
                    Value  = $false
                    Status = "locked"
                }
                "browser.newtabpage.activity-stream.feeds.topsites" = @{
                    Value  = $false
                    Status = "locked"
                }
            }
        }
    }
    
    try {
        $policiesJson = $policies | ConvertTo-Json -Depth 10
        Set-Content -Path $policiesPath -Value $policiesJson -Encoding UTF8
        Write-Host "[+] Created enterprise policies at: $policiesPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [-] Failed to write policies (need admin rights?): $_" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Banner

try {
    # Process profiles
    if ($ProfilePath) {
        # Use specific profile
        if (Test-Path $ProfilePath) {
            Write-Host "[*] Using specified profile:" -ForegroundColor Yellow
            Write-Host "    $ProfilePath" -ForegroundColor White
            
            Set-FirefoxSilentPreferences -ProfileDirectory $ProfilePath
            
            if (-not $SkipCleanup) {
                Clear-TelemetryPings -ProfileDirectory $ProfilePath
            }
        }
        else {
            Write-Host "[-] Specified profile path does not exist: $ProfilePath" -ForegroundColor Red
            exit 1
        }
    }
    else {
        # Configure all profiles
        $profiles = Get-FirefoxProfiles
        
        if ($profiles -and $profiles.Count -gt 0) {
            Write-Host "[*] Found $($profiles.Count) Firefox profile(s)" -ForegroundColor Yellow
            Write-Host ""
            
            foreach ($profile in $profiles) {
                Write-Host "[*] Configuring: $($profile.Name)" -ForegroundColor Cyan
                
                Set-FirefoxSilentPreferences -ProfileDirectory $profile.FullName
                
                if (-not $SkipCleanup) {
                    Clear-TelemetryPings -ProfileDirectory $profile.FullName
                }
                
                Write-Host ""
            }
        }
        else {
            Write-Host "[-] No Firefox profiles found." -ForegroundColor Red
            Write-Host "[!] Firefox may not be installed or hasn't been run yet." -ForegroundColor Yellow
            Write-Host "[!] Run Firefox once to create a profile, then run this script again." -ForegroundColor Yellow
            exit 1
        }
    }
    
    # Create enterprise policies (requires admin for Program Files)
    if (-not $SkipPolicies) {
        Write-Host "[*] Setting up enterprise policies..." -ForegroundColor Yellow
        Set-FirefoxEnterprisePolicy | Out-Null
        Write-Host ""
    }
    
    # Success message
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║              Firefox has been silenced!                   ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Close Firefox completely (check Task Manager for firefox.exe)" -ForegroundColor White
    Write-Host "  2. Restart Firefox" -ForegroundColor White
    Write-Host "  3. Configure Firefox to use Burp Suite proxy (127.0.0.1:8080)" -ForegroundColor White
    Write-Host "  4. Verify in Burp Suite that background noise is gone" -ForegroundColor White
    Write-Host ""
    Write-Host "Tip: If enterprise policies failed, re-run as Administrator." -ForegroundColor DarkGray
    Write-Host ""
    
}
catch {
    Write-Host ""
    Write-Host "[-] Error: $_" -ForegroundColor Red
    exit 1
}

