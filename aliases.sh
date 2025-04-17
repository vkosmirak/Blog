# === iOS utilities ===

# Installs pods with a repo update, then opens the Xcode workspace or project
alias pods='pod install --repo-update && xc'

# Fixes certain CocoaPods issues by removing the default trunk repo
alias "pods fix"='pod repo remove trunk'


# === s7 workflow ===

# Resets all s7 modules, checks them out, installs pods, and opens the workspace/project
# Also ensures Xcode is not running before proceeding
alias s7s="pkill -x Xcode; s7 reset --all; s7 checkout; pods; xc"


# === Xcode output formatting ===

# Formats raw xcodebuild output using xcbeautify
# Usage: xcb path/to/log.txt
xcb() {
    cat "$1" | xcbeautify
}


# === Open Xcode workspace/project ===

# Opens the .xcworkspace if present; otherwise opens the .xcodeproj
# If neither exists, shows a friendly message
xc() {
  local workspace=$(find . -maxdepth 1 -name "*.xcworkspace" | head -n 1)
  if [ -n "$workspace" ]; then
    echo "Opening $(basename "$workspace")"
    open "$workspace"
  else
    local project=$(find . -maxdepth 1 -name "*.xcodeproj" | head -n 1)
    if [ -n "$project" ]; then
      echo "Opening $(basename "$project")"
      open "$project"
    else
      echo "No .xcworkspace or .xcodeproj file found."
    fi
  fi
}
alias xc=xc
