#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

#import "XMLNode.h"

@implementation XMLNode

- (id) initWithName: (NSString *)name value: (NSString *)value attributes: (NSMutableDictionary *)attributes elements: (NSMutableArray *)elements
{
	self = [super init];
	if (self != nil)
	{
		[self setName: name];
		[self setAttributes: _attributes];
		[self setElements: _elements];
		[self setValue: _value];
	}
	return self;
}

- (id) initWithName: (NSString *)name
{
	return [self initWithName: name value: nil attributes: [NSMutableDictionary dictionary] elements: [NSMutableArray array]];
}

- (void) dealloc
{
	[_name release];
	[_attributes release];
	[_elements release];
	[_value release];
	[super dealloc];
}

- (NSString *) name
{
	return _name;
}

- (void) setName: (NSString *)name
{
	_name = [[name copy] retain];
}

- (NSMutableDictionary *) attributes
{
	return _attributes;
}

- (void) setAttributes: (NSMutableDictionary *) attributes
{
	_attributes = [[attributes copy] retain];
}

- (NSMutableArray *) elements
{
	return _elements;
}

- (void) setElements: (NSMutableArray *) elements
{
	_elements = [[elements copy] retain];
}

- (NSString *) value
{
	return _value;
}

- (void) setValue: (NSString *)value
{
	_value = [[value copy] retain];
}

- (void) addElement: (XMLNode *)element
{
	[_elements addObject: element];
}

- (void) addAttribute: (NSString *)key value: (NSString *)value
{
	[_attributes setObject: value forKey: key];
}

- (id) copyWithZone: (NSZone *)zone
{
	XMLNode *node = [[XMLNode allocWithZone: zone]
		initWithName: [self name]
		value: [self value]
		attributes: [self attributes]
		elements: [self elements]];

	return node;
}

@end