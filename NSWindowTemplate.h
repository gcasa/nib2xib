#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef struct _GSWindowTemplateFlags
{
    unsigned int isHiddenOnDeactivate:1;
    unsigned int isNotReleasedOnClose:1;
    unsigned int isDeferred:1;
    unsigned int isOneShot:1;
    unsigned int isVisible:1;
    unsigned int wantsToBeColor:1;
    unsigned int dynamicDepthLimit:1;
    unsigned int autoPositionMask:6;
    unsigned int savePosition:1;
    unsigned int style:2;
    unsigned int _unused2:3;
    unsigned int isNotShadowed:1;
    unsigned int autorecalculatesKeyViewLoop:1;
    unsigned int _unused:11;
} GSWindowTemplateFlags;


@interface NSWindowTemplate : NSObject 
{
    NSRect windowRect;
    int windowStyleMask;
    int windowBacking;
    NSString *windowTitle;
    NSString *viewClass;
    NSString *windowClass;
    id windowView;
    NSWindow *realObject;
    id extension;
    NSSize minSize;
    GSWindowTemplateFlags wtFlags;
    NSRect screenRect;
}
@end

@interface NSWindowTemplate (Methods)

- (int) interfaceStyle;
- (void) setInterfaceStyle:(int)fp16;

- (NSRect) windowRect;
- (int) windowStyleMask;
- (int) windowBacking;
- (NSString *) windowTitle;
- (NSString *) viewClass;
- (NSString *) windowClass;
- (id) windowView;
- (id) realObject;
- (NSSize) minSize;
- (GSWindowTemplateFlags) wtFlags;
- (NSRect) screenRect;

@end