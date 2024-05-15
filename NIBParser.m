#import <Foundation/NSArchiver.h>
#import <Foundation/NSDictionary.h>

#import "NSIBObjectData.h"
#import "NSCustomObject.h"
#import "NSWindowTemplate.h"

#import "NIBParser.h"

#define DEBUG

@interface NSMutableDictionary (LoadNibFormat)
+ (NSMutableDictionary *) dictionaryWithContentsOfClassesFile: (NSString *)file;
@end

@implementation NSMutableDictionary (LoadNibFormat)
+ (NSMutableDictionary *) dictionaryWithContentsOfClassesFile: (NSString *)file
{
	NSString *fileContents = [NSString stringWithContentsOfFile: file];
	NSString *string = [NSString stringWithFormat: @"{ %@ }", fileContents];
	NSDictionary *dict = nil; // [string propertyList];

	// NSLog(@"String = %@", string);

	dict = [string propertyList];
	return [NSMutableDictionary dictionaryWithDictionary: dict];
}
@end

@implementation NIBParser

- (id) initWithNibNamed: (NSString *)nibNamed
{
	self = [super init];
	if (self != nil)
	{
		NSString *objectsNib = [nibNamed stringByAppendingPathComponent: @"objects.nib"];
		NSString *dataClasses = [nibNamed stringByAppendingPathComponent: @"data.classes"];
		NSArray *connections = nil;

		_object = [NSUnarchiver unarchiveObjectWithFile: objectsNib];
		_rootObject = [_object rootObject];

#ifdef DEBUG		
		connections = [_object connections];
		NSLog(@"objectsNib = %@", objectsNib);
		NSLog(@"dataClasses = %@", dataClasses);
		NSLog(@"connections = %@", connections);
#endif

		_objectsDictionary = [NSMutableDictionary dictionary];
		_classesDictionary = [NSMutableDictionary dictionaryWithContentsOfClassesFile: dataClasses];

#ifdef DEBUG
		NSLog(@"_object = %@", _object);
		NSLog(@"_rootObject = %@", _rootObject);
		NSLog(@"_classesDictionary = %@", _classesDictionary);
#endif
	}
	return self;
}


- (void) handleCustomObject: (NSCustomObject *)o
                    withKey: (NSString *)key
{
	NSLog(@"key = %@, o = %@", key, o);
}


- (void) processWindowViews: (NSView *)view level: (int)level
{
	NSEnumerator *en = [[view subviews] objectEnumerator];
	id v = nil;

	while((v = [en nextObject]) != nil)
	{
		[self processWindowViews: v level: level + 1];
	}

	NSLog(@"view = %@, level = %d", view, level);

}


- (NSDictionary *) parse
{
	NSMapTable *nameTable = [_object nameTable];
	NSArray *values = NSAllMapTableValues(nameTable);
	NSArray *keys = NSAllMapTableKeys(nameTable);
	NSEnumerator *en = [keys objectEnumerator];
	id o = nil;

	NSLog(@"values = %@", values);
	NSLog(@"keys = %@", keys);

	// Create the root entry...
	[_objectsDictionary setObject: [NSMutableDictionary dictionary]	forKey: @"objects"];

	// Iterate over all objects in the map table...
	while ((o = [en nextObject]) != nil)
	{
		NSString *key = NSMapGet(nameTable, o);

		if ([o isKindOfClass: [NSWindowTemplate class]])
		{
			NSView *windowView = [o windowView];

			NSLog(@"Window Title = %@", [o windowTitle]);
			NSLog(@"Window View = %@", windowView);
			[self processWindowViews: windowView level: 0];
		}
		else if ([o isKindOfClass: [NSCustomObject class]])
		{
			[self handleCustomObject: o withKey: key];
		}
		else
		{
			NSLog(@"Unknown class: %@", o);
		}
	}

	return nil;
}

@end