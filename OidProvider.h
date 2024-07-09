#import <Foundation/NSObject.h>

@class NSNumber;

@protocol OidProvider

- (NSNumber *) oidForObject: (id)obj;

@end