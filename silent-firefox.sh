#!/bin/bash
# ============================================================================
# Silent-Firefox for Kali Linux
# Silences Firefox completely for penetration testing with Burp Suite
# ============================================================================
#
# SYNOPSIS:
#     Silences Firefox completely for penetration testing with Burp Suite.
#
# DESCRIPTION:
#     This script configures Firefox to be completely silent during pentesting by:
#     - Disabling all telemetry and data collection
#     - Disabling automatic updates (browser, extensions, media plugins)
#     - Disabling sponsored content, recommendations, and Pocket
#     - Disabling captive portal and connectivity checks
#     - Disabling safe browsing lookups
#     - Disabling remote settings, experiments, and Normandy studies
#     - Disabling search suggestions and Privacy Preserving Attribution
#     - Disabling GMP (Widevine/OpenH264) updates
#     - Cleaning up cached/queued telemetry pings
#     - Creating enterprise policies for system-wide enforcement
#
# USAGE:
#     ./silent-firefox.sh [OPTIONS]
#
# OPTIONS:
#     -p, --profile PATH    Specific Firefox profile path
#     -n, --no-backup       Skip creating backups of existing user.js files
#     -s, --skip-policies   Skip creating enterprise policies
#     -c, --skip-cleanup    Skip deleting cached telemetry pings
#     -h, --help            Show this help message
#
# EXAMPLES:
#     ./silent-firefox.sh
#     ./silent-firefox.sh --profile ~/.mozilla/firefox/abc123.default-release
#     ./silent-firefox.sh --no-backup --skip-policies
#     sudo ./silent-firefox.sh  # For enterprise policies
#
# NOTES:
#     Author: Silent-Firefox Project
#     Version: 1.0
#     Run this script before starting a new pentest engagement.
#     Restart Firefox after running for changes to take effect.
# ============================================================================

set -e

# ============================================================================
# COLORS
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# ============================================================================
# DEFAULT OPTIONS
# ============================================================================
PROFILE_PATH=""
NO_BACKUP=false
SKIP_POLICIES=false
SKIP_CLEANUP=false

# ============================================================================
# CONFIGURATION: All Firefox Silent Preferences
# ============================================================================
generate_silent_preferences() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat << 'PREFS_EOF'
// ============================================================================
// Firefox Silent Configuration for Pentesting
// Generated: TIMESTAMP_PLACEHOLDER
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
PREFS_EOF
}

# ============================================================================
# FUNCTIONS
# ============================================================================

print_banner() {
    echo ""
    echo -e "${CYAN}  ╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║           FIREFOX SILENT - Pentesting Mode                ║${NC}"
    echo -e "${CYAN}  ║         Silence Firefox for Burp Suite Usage              ║${NC}"
    echo -e "${CYAN}  ║                   (Kali Linux Edition)                    ║${NC}"
    echo -e "${CYAN}  ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Silences Firefox completely for penetration testing with Burp Suite."
    echo ""
    echo "Options:"
    echo "  -p, --profile PATH    Specific Firefox profile path"
    echo "  -n, --no-backup       Skip creating backups of existing user.js files"
    echo "  -s, --skip-policies   Skip creating enterprise policies"
    echo "  -c, --skip-cleanup    Skip deleting cached telemetry pings"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 --profile ~/.mozilla/firefox/abc123.default-release"
    echo "  $0 --no-backup --skip-policies"
    echo "  sudo $0  # For enterprise policies"
    echo ""
}

get_firefox_profiles_path() {
    # Standard Firefox profile locations on Linux
    local profile_paths=(
        "$HOME/.mozilla/firefox"
        "$HOME/snap/firefox/common/.mozilla/firefox"
        "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"
    )
    
    for path in "${profile_paths[@]}"; do
        if [[ -d "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

get_firefox_profiles() {
    local profiles_path
    profiles_path=$(get_firefox_profiles_path)
    
    if [[ -z "$profiles_path" ]]; then
        return 1
    fi
    
    # Find profile directories (they contain prefs.js)
    local profiles=()
    while IFS= read -r -d '' profile; do
        profiles+=("$profile")
    done < <(find "$profiles_path" -maxdepth 2 -name "prefs.js" -printf "%h\0" 2>/dev/null)
    
    if [[ ${#profiles[@]} -eq 0 ]]; then
        return 1
    fi
    
    printf '%s\n' "${profiles[@]}"
}

set_firefox_silent_preferences() {
    local profile_dir="$1"
    local user_js_path="$profile_dir/user.js"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Backup existing user.js if it exists and backup is enabled
    if [[ "$NO_BACKUP" != true ]] && [[ -f "$user_js_path" ]]; then
        local backup_path="${user_js_path}.backup_$(date '+%Y%m%d_%H%M%S')"
        cp "$user_js_path" "$backup_path"
        echo -e "  ${GRAY}[+] Backed up existing user.js to: $backup_path${NC}"
    fi
    
    # Write preferences to user.js
    generate_silent_preferences | sed "s/TIMESTAMP_PLACEHOLDER/$timestamp/" > "$user_js_path"
    echo -e "  ${GREEN}[+] Created/updated user.js${NC}"
}

clear_telemetry_pings() {
    local profile_dir="$1"
    local cleaned=false
    
    local ping_folders=(
        "saved-telemetry-pings"
        "datareporting/archived"
        "datareporting/active"
    )
    
    for folder in "${ping_folders[@]}"; do
        local target="$profile_dir/$folder"
        if [[ -d "$target" ]]; then
            local items
            items=$(find "$target" -type f 2>/dev/null | head -1)
            if [[ -n "$items" ]]; then
                rm -rf "${target:?}"/* 2>/dev/null || true
                cleaned=true
            fi
        fi
    done
    
    if [[ "$cleaned" == true ]]; then
        echo -e "  ${YELLOW}[+] Cleared cached telemetry pings${NC}"
    fi
}

get_firefox_install_path() {
    # Common Firefox installation paths on Linux/Kali
    local firefox_paths=(
        "/usr/lib/firefox-esr"
        "/usr/lib/firefox"
        "/usr/lib64/firefox"
        "/opt/firefox"
        "/snap/firefox/current/usr/lib/firefox"
    )
    
    for path in "${firefox_paths[@]}"; do
        if [[ -d "$path" ]] && [[ -f "$path/firefox" || -f "$path/firefox-esr" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    # Try to find firefox binary and get its directory
    local firefox_bin
    firefox_bin=$(which firefox-esr 2>/dev/null || which firefox 2>/dev/null || true)
    if [[ -n "$firefox_bin" ]]; then
        # Follow symlinks and get the real path
        local real_path
        real_path=$(readlink -f "$firefox_bin" 2>/dev/null || echo "$firefox_bin")
        local dir_path
        dir_path=$(dirname "$real_path")
        if [[ -d "$dir_path" ]]; then
            echo "$dir_path"
            return 0
        fi
    fi
    
    return 1
}

set_firefox_enterprise_policy() {
    local firefox_install_path
    firefox_install_path=$(get_firefox_install_path)
    
    if [[ -z "$firefox_install_path" ]]; then
        echo -e "  ${YELLOW}[-] Firefox installation not found. Skipping enterprise policies.${NC}"
        return 1
    fi
    
    # Check for system-wide policies directory
    local distribution_path="$firefox_install_path/distribution"
    local policies_path="$distribution_path/policies.json"
    
    # Alternative: /etc/firefox/policies (Debian/Ubuntu style)
    local etc_policies_dir="/etc/firefox/policies"
    local etc_policies_path="$etc_policies_dir/policies.json"
    
    # Try distribution folder first
    if [[ ! -d "$distribution_path" ]]; then
        if ! mkdir -p "$distribution_path" 2>/dev/null; then
            # Try /etc/firefox/policies as fallback
            if ! mkdir -p "$etc_policies_dir" 2>/dev/null; then
                echo -e "  ${YELLOW}[-] Cannot create policies folder (need root?). Skipping policies.${NC}"
                return 1
            fi
            policies_path="$etc_policies_path"
        fi
    fi
    
    # Create policies JSON
    local policies_json
    policies_json=$(cat << 'POLICIES_EOF'
{
    "policies": {
        "DisableTelemetry": true,
        "DisableFirefoxStudies": true,
        "DisablePocket": true,
        "DisableFirefoxAccounts": true,
        "DisableSetDesktopBackground": true,
        "DisableMasterPasswordCreation": false,
        "DisableAppUpdate": true,
        "DisableSystemAddonUpdate": true,
        "DontCheckDefaultBrowser": true,
        "DisplayBookmarksToolbar": false,
        "NoDefaultBookmarks": true,
        "OverrideFirstRunPage": "",
        "OverridePostUpdatePage": "",
        "CaptivePortal": false,
        "NetworkPrediction": false,
        "DNSOverHTTPS": {
            "Enabled": false
        },
        "Preferences": {
            "network.captive-portal-service.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "network.connectivity-service.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "datareporting.policy.dataSubmissionEnabled": {
                "Value": false,
                "Status": "locked"
            },
            "toolkit.telemetry.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "browser.safebrowsing.malware.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "browser.safebrowsing.phishing.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "dom.private-attribution.submission.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "services.settings.server": {
                "Value": "",
                "Status": "locked"
            },
            "extensions.blocklist.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "extensions.fxmonitor.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "browser.topsites.contile.enabled": {
                "Value": false,
                "Status": "locked"
            },
            "browser.newtabpage.activity-stream.feeds.topsites": {
                "Value": false,
                "Status": "locked"
            }
        }
    }
}
POLICIES_EOF
)
    
    if echo "$policies_json" > "$policies_path" 2>/dev/null; then
        echo -e "${GREEN}[+] Created enterprise policies at: $policies_path${NC}"
        return 0
    else
        echo -e "  ${YELLOW}[-] Failed to write policies (need root?).${NC}"
        return 1
    fi
}

check_firefox_running() {
    if pgrep -x "firefox" > /dev/null 2>&1 || pgrep -x "firefox-esr" > /dev/null 2>&1; then
        echo -e "${YELLOW}[!] Warning: Firefox appears to be running.${NC}"
        echo -e "${YELLOW}    Close Firefox for changes to take effect.${NC}"
        echo ""
    fi
}

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--profile)
            PROFILE_PATH="$2"
            shift 2
            ;;
        -n|--no-backup)
            NO_BACKUP=true
            shift
            ;;
        -s|--skip-policies)
            SKIP_POLICIES=true
            shift
            ;;
        -c|--skip-cleanup)
            SKIP_CLEANUP=true
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            print_help
            exit 1
            ;;
    esac
done

# ============================================================================
# MAIN EXECUTION
# ============================================================================

print_banner

# Check if Firefox is running
check_firefox_running

# Process profiles
if [[ -n "$PROFILE_PATH" ]]; then
    # Use specific profile
    if [[ -d "$PROFILE_PATH" ]]; then
        echo -e "${YELLOW}[*] Using specified profile:${NC}"
        echo -e "${WHITE}    $PROFILE_PATH${NC}"
        echo ""
        
        set_firefox_silent_preferences "$PROFILE_PATH"
        
        if [[ "$SKIP_CLEANUP" != true ]]; then
            clear_telemetry_pings "$PROFILE_PATH"
        fi
    else
        echo -e "${RED}[-] Specified profile path does not exist: $PROFILE_PATH${NC}"
        exit 1
    fi
else
    # Configure all profiles
    profiles=()
    while IFS= read -r profile; do
        profiles+=("$profile")
    done < <(get_firefox_profiles)
    
    if [[ ${#profiles[@]} -gt 0 ]]; then
        echo -e "${YELLOW}[*] Found ${#profiles[@]} Firefox profile(s)${NC}"
        echo ""
        
        for profile in "${profiles[@]}"; do
            profile_name=$(basename "$profile")
            echo -e "${CYAN}[*] Configuring: $profile_name${NC}"
            
            set_firefox_silent_preferences "$profile"
            
            if [[ "$SKIP_CLEANUP" != true ]]; then
                clear_telemetry_pings "$profile"
            fi
            
            echo ""
        done
    else
        echo -e "${RED}[-] No Firefox profiles found.${NC}"
        echo -e "${YELLOW}[!] Firefox may not be installed or hasn't been run yet.${NC}"
        echo -e "${YELLOW}[!] Run Firefox once to create a profile, then run this script again.${NC}"
        exit 1
    fi
fi

# Create enterprise policies (requires root for system directories)
if [[ "$SKIP_POLICIES" != true ]]; then
    echo -e "${YELLOW}[*] Setting up enterprise policies...${NC}"
    set_firefox_enterprise_policy || true
    echo ""
fi

# Success message
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Firefox has been silenced!                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "${WHITE}  1. Close Firefox completely (pkill firefox or pkill firefox-esr)${NC}"
echo -e "${WHITE}  2. Restart Firefox${NC}"
echo -e "${WHITE}  3. Configure Firefox to use Burp Suite proxy (127.0.0.1:8080)${NC}"
echo -e "${WHITE}  4. Verify in Burp Suite that background noise is gone${NC}"
echo ""
echo -e "${GRAY}Tip: If enterprise policies failed, re-run with sudo.${NC}"
echo ""

