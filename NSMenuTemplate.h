#import <Foundation/NSObject.h>
#import <Foundation/NSGeometry.h>

@class NSString;

@interface NSMenuTemplate : NSObject
{
	NSString *title;
	NSString *menuClassName;
	id        view;
	id        supermenu;
	id        realObject;
	id        extension;     
	NSPoint   location;
	BOOL      isWindowsMenu;
	BOOL      isRequestMenu;
	BOOL      isFontMenu;
	int       interfaceStyle;
}
@end

@interface NSMenuTemplate (Methods)

- (NSString *) title;
- (NSString *) menuClassName;
- (id) view;
- (id) supermenu;
- (id) realObject;
- (id) extension;
- (NSPoint) location;
- (BOOL) isWindowsMenu;
- (BOOL) isRequestMenu;
- (BOOL) isFontMenu;
- (int) interfaceStyle;
- (NSString *) altdescription;

@end