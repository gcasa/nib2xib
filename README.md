# nib2xib
This tool runs only on OPENSTEP 4.2 currently.  It best approximates the XIB file structure from the typed stream nibs on the NeXT machine.   It is possible, in the future, for this tool to be used to regenerate XIB files from the NIB that is created by Xcode's build process.

The idea behind this is to have a native tool that is buildable without GNUstep to create a format that is useful for porting.  XIBs are readable by GNUstep and by Gorm as well.

## License
This tool is licensed under the GPL3.0+
