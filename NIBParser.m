#import <Foundation/NSArchiver.h>
#import <Foundation/NSDictionary.h>

#import "NSIBObjectData.h"
#import "NIBParser.h"

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
		// connections = [_object connections];

		// NSLog(@"objectsNib = %@", objectsNib);
		// NSLog(@"dataClasses = %@", dataClasses);

		// NSLog(@"connections = %@", connections);
		_objectsDictionary = [NSMutableDictionary dictionary];
		_classesDictionary = [NSMutableDictionary dictionaryWithContentsOfClassesFile: dataClasses];

		NSLog(@"_object = %@", _object);
		NSLog(@"_rootObject = %@", _rootObject);
		NSLog(@"_classesDictionary = %@", _classesDictionary);
	}
	return self;
}

- (NSDictionary *) parse
{
	return nil;
}

@end