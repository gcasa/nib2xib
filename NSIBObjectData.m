/* NSIBObjectData.h created by heron on Fri 13-Oct-2023 */

#import "NSIBObjectData.h"

@implementation NSIBObjectData (Methods)
- (NSMapTable *) instantiatedObjectTable
{
  return instantiatedObjectTable;
}

- (NSMapTable *) classTable
{
  return classTable;
}

- (NSMapTable *) oidTable
{
  return oidTable;
}

- (NSMapTable *) nameTable
{
  return nameTable;
}

- (NSMapTable *) objectTable
{
  return objectTable;
}

- (unsigned int) nextOid
{
  return nextOid;
}

- (NSArray *) connections
{
  return connections;
}

- (id) firstResponder
{
  return firstResponder;
}

- (id) fontManager
{
  return fontManager;
}

- (id) rootObject
{
  return rootObject;
}
@end
