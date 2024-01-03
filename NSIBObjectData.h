/* NSIBObjectData.h created by heron on Fri 13-Oct-2023 */

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface NSIBObjectData : NSObject
{
  id rootObject;
  NSMapTable *objectTable;
  NSMapTable *nameTable;
  NSMutableSet *visibleWindows;
  NSMutableArray *connections;
  id firstResponder;
  id fontManager;
  NSMapTable *oidTable;
  unsigned int nextOid;
  NSMapTable *classTable;
  NSMapTable *instantiatedObjectTable;
}
@end 

@interface NSIBObjectData (Methods)
- (NSMapTable *) instantiatedObjectTable;
- (NSMapTable *) classTable;
- (NSMapTable *) oidTable;
- (NSMapTable *) nameTable;
- (NSMapTable *) objectTable;

- (unsigned int) nextOid;

- (NSArray *) connections;

- (id) firstResponder;
- (id) fontManager;
- (id) rootObject;
@end
