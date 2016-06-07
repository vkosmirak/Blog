#Xcode


###Show `TODO:` and `FIXME:` as warnings
Select Target / Build Phases / Add run script
```bash
KEYWORDS="TODO:|FIXME:|\?\?\?:|\!\!\!:"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($KEYWORDS).*\$" | perl -p -e "s/($KEYWORDS)/ warning: \$1/"
```

###Debug 
When some crash ocurrapted, use `di -s 0x20344bs` to see where is an error


###Some standarts

1. Storyboard - use size `iPhone 4-inc` for all controllers, `Inferred` only by need 
2. Wrap all controllers in scrollView
3. Git commits should be revertable
