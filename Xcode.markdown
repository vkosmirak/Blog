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



### During debug
1. Skip line on debug:
   ```
   thread jump —by 1
   Expression view.backgroundColor = red
   ```
   or move the cursor in the right
2.  Update frame  
   `CATransaction.flush()`
3. Observe property - use Watchpoints
4. Create and use debug variable (use prefix $)
   ```
   expression let $a = 2
   expression a == 2
   ```
5. Print Dictionary as JSON
   ```
   po  NSString(data: try! JSONSerialization.data(withJSONObject: queryParams!, options: [.prettyPrinted]), encoding: String.Encoding.utf8.rawValue)
   ```



### Fast way to print functions in call order:
```
debugPrint(#function, param1, param2)
```


### Open terminal after pod failed (not completed)
1. Add this line in Build Phases / Check pods Manifest.lock
2. after echo:
3. `osascript -e 'tell app "Terminal" to do script "cd '${PODS_PODFILE_DIR_PATH}'; pod install"'`
4. Problem: this is cleared after pod installed
5. Question: can we have workaround?
6. Alternative command: 
`open -a Terminal "${PODS_PODFILE_DIR_PATH}"`
7. Question: can we use post install script
https://stackoverflow.com/questions/20072937/add-run-script-build-phase-to-xcode-project-from-podspec
