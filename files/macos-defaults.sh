#!/usr/bin/env bash
#
# macOS defaults for the work machine.
#
# Ports only the settings actually customised on the source machine; macOS
# stock behaviour is left alone everywhere else. Safe to re-run.
#
# Usage: files/macos-defaults.sh [--no-restart]

set -euo pipefail

NO_RESTART=false
for arg in "$@"; do
  case "$arg" in
    --no-restart) NO_RESTART=true ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

# Keep sudo alive is deliberately omitted: nothing here needs root.

###############################################################################
# Appearance                                                                  #
###############################################################################

# Dark mode.
defaults write -g AppleInterfaceStyle -string "Dark"

###############################################################################
# Finder                                                                      #
###############################################################################

# List view in all Finder windows (Nlsv; others: icnv, clmv, Flwv).
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the path bar and status bar.
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Show all filename extensions.
defaults write -g AppleShowAllExtensions -bool true

# Do not write .DS_Store files to network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Fast key repeat.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Disable press-and-hold for accented characters in favour of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

###############################################################################
# Menu bar / Control Centre                                                   #
###############################################################################

# Always show the sound control in the menu bar, rather than only while it is
# in active use (the macOS default).
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

###############################################################################
# Restart affected applications                                               #
###############################################################################

if [ "$NO_RESTART" = false ]; then
  for app in "Finder" "Dock" "SystemUIServer" "ControlCenter"; do
    killall "$app" >/dev/null 2>&1 || true
  done
  echo "Restarted Finder, Dock, SystemUIServer and ControlCenter."
else
  echo "Defaults written. Some changes need a logout or app restart to appear."
fi
