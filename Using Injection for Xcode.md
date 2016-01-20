# Using [Injection for Xcode](https://github.com/johnno1962/injectionforxcode)

Using in simulator

1. Install InjectionPlugin in Alcatraz
2. Make sure main.m (empty for Swift) and Prefix.pch (connected in Build Settings/Prefix Header) exists
2. Product -> Injection Plugin -> Patch Project for Injection
3. Run on simulator 
4. Select some .m class and make some changes
5. Product -> Inject Source

Using in device:

1. Add Run script to target 
`echo "$CODESIGNING_FOLDER_PATH" >/tmp/"$USER.ident" && echo "$CODE_SIGN_IDENTITY" >>/tmp/"$USER.ident" && exit;`
2. Build Settings -> Code Sign Identity -> Debug  - change `iOS Developer` to your custom  certificate, e.g. `iPhone Developer: My Name (XX4XXXXX64)`
3. ProjectFolder/iOSInjectionProject/(x86_64 or armv7)/identity.txt - change last line `iPhone Developer` to  `iPhone Developer: My Name (XX4XXXXX64)`
4. Run it on Device

Handling changes in storyboards:

1. Product -> Injection Plugin -> Tunable App Parameters - Check Inject Storyboards
2. Rebuild app

Using Tunable App Parameters:

1. Make sure that Prefix.pch contain `#import "/tmp/injectionforxcode/BundleInterface.h"`
2. Use `INParameters[0]`, `INColors[0]` and `INImageTarget`


> My comment:
> There are some cases when injection failed. Try to reinject
