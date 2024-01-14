#import "NSCustomObject.h"
#import <Foundation/NSString.h>

@implementation NSCustomObject (Methods)

- (NSString *) className
{
    return className;
}

- (id) realObject
{
    return realObject;
}

- (id) extension
{
    return extension;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@ - <className = %@, realObject = %@, extension = %@>", [super description], className, realObject, extension];
}
@end