# ──────────────────────────────────────────────────────────────────────────────
# 📦 Personal Aliases for iOS Development
#
# 🔧 How to install:
#   - Download aliases.sh file
#   - `source aliases.sh`
#   - `update_aliases`
#
# 🔧 How to update:
#   - `update_aliases`
# ──────────────────────────────────────────────────────────────────────────────

# Installs pods with a repo update, then opens the Xcode workspace or project
alias pods='pod install --repo-update && xc'

# Fixes certain CocoaPods issues by removing the default trunk repo
alias "pods fix"='pod repo remove trunk'


# === s7 workflow ===

# Resets all s7 modules, checks them out, installs pods, and opens the workspace/project
# Also ensures Xcode is not running before proceeding
alias s7s="pkill -x Xcode; s7 reset --all; s7 checkout; pods; xc"


# === Open Xcode workspace/project and trigger build ===
#
# This function searches the current directory for an Xcode workspace (*.xcworkspace)
# or project (*.xcodeproj) and opens the first match found.
#
# Once opened, it waits (up to 30 seconds) for the corresponding Xcode window to appear.
# After the window appears, it activates Xcode and triggers a build (Cmd + B) automatically.
#
xc() {
  local projectFile=$(find . -maxdepth 1 -name '*.xcworkspace' | head -n 1 || find . -maxdepth 1 -name '*.xcodeproj' | head -n 1)
  
  if [ -n "$projectFile" ]; then
    echo "Opening '$(basename "$projectFile")'"
    open "$projectFile"
  else
    echo "No .xcworkspace or .xcodeproj file found."
    return
  fi

  # Wait for Xcode window to appear
  local xcodeWindowName=$(basename "$projectFile" | sed 's/\.[^.]*$//')
  for i in {1..30}; do
    sleep 1
    if osascript -e 'tell application "System Events" to get name of every window of process "Xcode"' | grep -Fq "$xcodeWindowName"; then
      break
    fi
    echo "Waiting for Xcode window '$xcodeWindowName' to appear..."
  done

  # Activate and build project in Xcode
  echo "Triggering build"
  osascript -e 'tell application "Xcode" to activate' \
            -e 'tell application "System Events" to keystroke "b" using {command down}'      
}


# === Open Xcode DerivedData directory ===
#
# This function opens the Xcode DerivedData directory in Finder.
alias xc_open_derived_data='open ~/Library/Developer/Xcode/DerivedData'


# === Xcode output formatting ===

# Formats raw xcodebuild output using xcbeautify. Drag and drop path to log file
# Usage: xcb path/to/file.log
xcb() {
    cat "$1" | xcbeautify
}


# === Update aliases from GitHub ===
# Downloads latest aliases.sh from GitHub and replaces ~/.aliases.sh
# Ensures it's sourced in ~/.zshrc
update_aliases() {
  local url="https://api.github.com/repos/vkosmirak/Blog/contents/aliases.sh"
  local target="$HOME/.aliases.sh"

  echo "⬇️ Downloading latest aliases from GitHub..."
  if curl -fsSL "$url" \
    -H "Accept: application/vnd.github.v3.raw" \
    -o "$target"; then
    echo "✅ Saved to $target"
  else
    echo "❌ Failed to download aliases from $url"
    return 1
  fi

  if ! grep -qxF '[ -f ~/.aliases.sh ] && source ~/.aliases.sh' ~/.zshrc; then
     echo "🔧 Adding source line to ~/.zshrc..."
  {
    printf '\n# Load personal aliases (installed via update_aliases)\n'
    printf '[ -f ~/.aliases.sh ] && source ~/.aliases.sh\n'
  } >> ~/.zshrc
  else
    echo "✅ ~/.zshrc already sources ~/.aliases.sh"
  fi

  echo "🔄 Reloading ~/.aliases.sh into current shell..."
  source "$target"

  echo "✅ Done. Aliases updated and reloaded!"
}
