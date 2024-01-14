#import <Foundation/NSObject.h>

@class NSString;

@interface NSCustomObject : NSObject 
{
    NSString *className;
    id realObject;
    id extension;
}
@end

@interface NSCustomObject (Methods)

- (NSString *) className;
- (id) realObject;
- (id) extension;

@end