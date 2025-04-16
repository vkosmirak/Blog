# Workplace


## Applications:

### General:
- 1password
- AdGuard
- CleanMyMac
- Google Chrome
- Grammarly
- Movist Pro
- Things 3
- Wallpaper Wizard

### Communication:
- Skype
- Slack
- Spark
- Telegram
- Viber

### Development:
- CopyLess 2
- SimPholders
- Sublime (Packages: Markdown, Pretty JSON)
- Open rdar
- Postman
- TablePlus 
- Tower
- Xcode

### Other:
- Gestime
- Kap (video & gif screen recorder)


## Configurations:

### OSX:
1. Update OS X to the latest version
2. Change language by Command + space
3. Open spotlight: Control + space
4. Tree fingers drag (https://support.apple.com/en-us/HT204609)
5. Terminal green theme (Preferences/Profile/Grass/Default)
6. Set Sublime 4 as default text editor (https://stackoverflow.com/a/22141204)


### Xcode:
1. Preferences / Account / Sign in
2. Preferences / Fonts & Colors / Dusk (with modifications)
3. Preferences / Navigation / Command-click on code / Jump to definition 

### Settings:
1. PM/AM
2. Start week from Monday

Install certificates

### Terminal:
1. install cocoapods (`sudo gem install cocoapods`)
   * specific version: `sudo gem install cocoapods -v 1.12.0`
   * uninstall all other versions `sudo gem uninstall cocoapods`
3. install [homebrew](https://brew.sh/index_uk)
4. install fastlane (`brew install fastlane`)
5. install swiftlint (`brew install swiftlint`)
6. create `pods` aliases
   * `open ~/.zshrc`, add next lines in the end
```
alias xc='open "$(find . -maxdepth 1 -name "*.xcworkspace" | head -n 1)"'
alias pods='pod install --repo-update && xc'
alias "pods fix"='pod repo remove trunk'
```

### iTerm:
1. Fix jumps back a word ([how](https://apple.stackexchange.com/a/293988))

### VScode
1. Make it a default files open app. in Terminal:
```
brew install duti
duti -s com.microsoft.VSCode public.plain-text all      # .txt
duti -s com.microsoft.VSCode public.source-code all      # .js, .rb, .py, etc.
duti -s com.microsoft.VSCode public.json all             # .json
duti -s com.microsoft.VSCode net.daringfireball.markdown all  # .md
duti -s com.microsoft.VSCode public.xml all              # .xml, .plist
duti -s com.microsoft.VSCode public.data all             # all other
```

### Git
1. Install git hook to automatically append to commit message a prefix - ticket number, parsed from the branch name
```
cat << 'EOF' > .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg
#!/bin/bash

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Extract the last JIRA ticket from the branch name (matches pattern ABC-123456)
ticket=$(echo "$branch_name" | grep -oE '[A-Z]+-[0-9]+' | tail -n 1)

# File containing the commit message
commit_msg_file=$1

# Read the commit message
commit_msg=$(cat "$commit_msg_file")

# Check if the ticket is missing from the commit message
if [[ -n "$ticket" && ! "$commit_msg" =~ ^\[ ]]; then
  # Format the commit message as [TICKET] Commit message
  echo "[$ticket] $commit_msg" > "$commit_msg_file"
fi
EOF
```

### Sublime:
1. Command + shift + P
2. Package Control: Install Package
3. Pretty JSON
4. Preferences / Package Control / Pretty JSON / User
5. Add  { “sort_keys": false }

### Skype:
1. /me has left this chat

### Safari:
- Grammarly
- Show bookmarks: Command + shift + B
- Pin page: google translate


### Before re-installing OS X backup needed
1. Files
2. Git stashes
3. Certificates
4. Recovery codes / trusted devices

### After reinstalling iOS:
1. Google Authenticator:
 - Gitlab/Settings/Account/Disable 2factor authentication/Register again     
 - Microsoft/sign in/remove and regenerate authenticator app (optional)

