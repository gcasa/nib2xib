/* NSClassSwapper.h created by heron on Fri 13-Oct-2023 */

#import <AppKit/AppKit.h>

@interface NSClassSwapper : NSObject
{
  NSString *className;
  id template;
}

- (void) setTemplate: (id)t;
- (id) template;

- (void) setClassName: (NSString *)cn;
- (NSString *) className;
@end
