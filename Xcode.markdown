# Xcode

### Check build time  
1. Build menu  
2. Copy transcripts for shown results  
3. in Terminal:  
`pbpaste | egrep '\.[0-9]ms' | sort -t "." -k 1 -n | tail -10`


### Print current directory
```
po NSHomeDirectory()
```

### Show gestures on simulator: 
```
defaults write http://com.apple .iphonesimulator ShowSingleTouches 1
```

