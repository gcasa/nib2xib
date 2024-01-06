#import <Foundation/NSArchiver.h>
#import "NIBParser.h"

@implementation NIBParser

- (id) initWithNibNamed: (NSString *)nibNamed
{
	self = [super init];
	if (self != nil)
	{
		id obj = [NSUnarchiver unarchiveObjectWithFile: nibNamed];
		NSLog(@"obj = %@", obj);
	}
	return self;
}

@end