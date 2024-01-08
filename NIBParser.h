#import <Foundation/NSObject.h>

@class NSDictionary;
@class NSMutableDictionary;
@class NSString;

@interface NIBParser : NSObject
{
	NSMutableDictionary *_objectsDictionary;
	NSMutableDictionary *_classesDictionary;
	id _object;
	id _rootObject;
}

- (id) initWithNibNamed: (NSString *)nibNamed;
- (NSDictionary *) parse;

@end