#import <Foundation/NSObject.h>

@class NSString;

@protocol OidProvider

- (NSString *) oidForObject: (id)obj;

@end