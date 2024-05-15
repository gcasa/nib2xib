#import "NSMenuTemplate.h"
#import <Foundation/NSString.h>

@implementation NSMenuTemplate (Methods)

- (NSString *) title
{
	return title;
}

- (NSString *) menuClassName
{
	return menuClassName;
}

- (id) view
{
	return view;
}

- (id) supermenu
{
	return supermenu;
}

- (id) realObject
{
	return realObject;
}

- (id) extension
{
	return extension;
}

- (NSPoint) location
{
	return location;
}

- (BOOL) isWindowsMenu
{
	return isWindowsMenu;
}

- (BOOL) isRequestMenu
{
	return isRequestMenu;
}

- (BOOL) isFontMenu
{
	return isFontMenu;
}

- (int) interfaceStyle
{
	return interfaceStyle;
}

- (NSString *) altdescription
{
	// NSString *desc = [super description];
	return [NSString stringWithFormat: @"<NSMenuTemplate> - <title = %@, menuClassName = %@", // , view = %@, supermenu = %@, extension = %@, isWindowsMenu = %d, isRequestMenu = %d, isFontMenu = %d, interfaceStyle = %d",
			title, menuClassName]; // , view, supermenu, extension, isWindowsMenu, isRequestMenu, isFontMenu, interfaceStyle];
}

@end