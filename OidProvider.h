#import <Foundation/NSObject.h>

@class NSString;

@protocol OidProvider

- (NSString *) oidForObject: (id)obj;
- (NSString *) oidString;

@end