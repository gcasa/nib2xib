/* Copyright (C) 2024 Free Software Foundation, Inc.
 *
 * Author:      Gregory John Casamento <greg.casamento@gmail.com>
 * Date:        2024
 *
 * This file is part of GNUstep.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111
 * USA.
 */

#import <Foundation/Foundation.h>

#import "XMLNode.h"

@implementation XMLNode

- (id) initWithName: (NSString *)name value: (NSString *)value attributes: (NSMutableDictionary *)attributes elements: (NSMutableArray *)elements
{
	self = [super init];
	if (self != nil)
	{
		[self setName: name];
		[self setAttributes: attributes];
		[self setElements: elements];
		[self setValue: value];
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

- (NSString *) describeAttributes
{
	NSString *result = @"";
	NSEnumerator *en = [_attributes keyEnumerator];
	NSString *k = nil;

	while ((k = [en nextObject]) != nil)
	{
		NSString *v = [_attributes objectForKey: k];
		result = [result stringByAppendingString: [NSString stringWithFormat: @" %@ = %@", k, v]];
	}

	return result;
}

- (NSString *) description
{
	NSString *result = [NSString stringWithFormat: @"<%@%@>%@%@</%@>", 
		_name, [self describeAttributes], _value, _elements, _name];
	return result;
}

@end
