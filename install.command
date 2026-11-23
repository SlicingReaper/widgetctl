#!/bin/bash
# WIDGET//CTL installer — double-click in Finder (first time: right-click → Open), or run: bash install.command
# Safe to run again: it updates the code and never touches your data.
D="$(cd "$(dirname "$0")" && pwd)"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:$PATH"
SUP="$HOME/Library/Application Support/STUDYTERM"; SA="$SUP/standalone"
pause() { [ -n "$NOPAUSE" ] || read -r -p "Press Enter to close"; }
die() { echo "✗ $*"; pause; exit 1; }
APP="$(ls -d /Applications/*bersicht.app 2>/dev/null | head -1)"
if [ -z "$APP" ]; then
  echo "… Übersicht not found, downloading it"
  curl -fL --retry 2 -o /tmp/uebersicht.zip "https://tracesof.net/uebersicht/releases/Uebersicht-1.6.82.app.zip" \
    && ditto -x -k /tmp/uebersicht.zip /Applications && rm -f /tmp/uebersicht.zip
  APP="$(ls -d /Applications/*bersicht.app 2>/dev/null | head -1)"
  [ -n "$APP" ] && xattr -dr com.apple.quarantine "$APP" 2>/dev/null
fi
[ -n "$APP" ] || die "Übersicht install failed — get it from https://tracesof.net/uebersicht/ and run this again"
[ -d "$HOME/Library/Application Support/Übersicht/widgets" ] || { open -g "$APP"; sleep 5; }
W="$(ls -d "$HOME/Library/Application Support/"*bersicht/widgets 2>/dev/null | head -1)"
[ -n "$W" ] || W="$HOME/Library/Application Support/Übersicht/widgets"; mkdir -p "$W"

LA="$HOME/Library/LaunchAgents"; mkdir -p "$LA" "$SUP"
command -v swiftc >/dev/null || die "swiftc missing — run: xcode-select --install   then run this again"
# 1. WIDGET//CTL app
T="$(mktemp -d)"; A="$T/WidgetCTL.app"; mkdir -p "$A/Contents/MacOS" "$A/Contents/Resources"
swiftc -O "$D/WidgetCTL.swift" -o "$A/Contents/MacOS/WidgetCTL" -framework Cocoa -framework WebKit -framework Carbon || die "WIDGET//CTL compile failed"
cp "$D/ctl.html" "$A/Contents/Resources/"; cp "$D/Info.plist" "$A/Contents/"
IS="$T/AppIcon.iconset"; mkdir -p "$IS"
for s in 16 32 128 256 512; do sips -z $s $s "$D/icon.png" --out "$IS/icon_${s}x${s}.png" >/dev/null; d=$((s*2)); sips -z $d $d "$D/icon.png" --out "$IS/icon_${s}x${s}@2x.png" >/dev/null; done
iconutil -c icns "$IS" -o "$A/Contents/Resources/AppIcon.icns" 2>/dev/null
codesign --force --deep -s - "$A" 2>/dev/null
DEST="/Applications"; [ -w "$DEST" ] || { DEST="$HOME/Applications"; mkdir -p "$DEST"; }
pkill -x WidgetCTL 2>/dev/null; sleep 1; rm -rf "$DEST/WidgetCTL.app"; ditto "$A" "$DEST/WidgetCTL.app" && echo "✓ WIDGET//CTL → $DEST/WidgetCTL.app"
rm -rf "$T"
cat > "$LA/com.felix.widgetctl.plist" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>Label</key><string>com.felix.widgetctl</string>
<key>ProgramArguments</key><array><string>/usr/bin/open</string><string>-g</string><string>$DEST/WidgetCTL.app</string></array>
<key>RunAtLoad</key><true/></dict></plist>
PL
# 2. ⌃⌥⌘W hotkey
swiftc -O "$D/hotkey/widget-hotkey.swift" -o "$SUP/widget-hotkey" || die "hotkey compile failed"
cat > "$LA/com.felix.studyterm.hotkey.plist" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>Label</key><string>com.felix.studyterm.hotkey</string>
<key>ProgramArguments</key><array><string>$SUP/widget-hotkey</string></array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/></dict></plist>
PL
launchctl bootout gui/$(id -u)/com.felix.studyterm.hotkey 2>/dev/null
launchctl bootstrap gui/$(id -u) "$LA/com.felix.studyterm.hotkey.plist" && echo "✓ ⌃⌥⌘W hotkey running"
rm -f "$SUP/hidden"
open "$DEST/WidgetCTL.app" --args --show && echo "✓ WIDGET//CTL running — ⌃⌥⌘S opens it, ▦ in the menu bar"
osascript -e 'tell application id "tracesOf.Uebersicht" to refresh' 2>/dev/null
pause
