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

### Fast way to print functions in call order:
```
debugPrint(#function, param1, param2)
```


