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
#import <Foundation/NSArchiver.h>
#import <Foundation/NSDictionary.h>

#import "NSIBObjectData.h"
#import "NSCustomObject.h"
#import "NSWindowTemplate.h"
#import "NSMenuTemplate.h"

#import "NIBParser.h"
#import "XMLDocument.h"
#import "XMLNode.h"

// #define DEBUG
@interface NSMutableDictionary (LoadNibFormat)
+ (NSMutableDictionary *) dictionaryWithContentsOfClassesFile: (NSString *)file;
@end

@implementation NSMutableDictionary (LoadNibFormat)
+ (NSMutableDictionary *) dictionaryWithContentsOfClassesFile: (NSString *)file
{
	NSString *fileContents = [NSString stringWithContentsOfFile: file];
	NSString *string = [NSString stringWithFormat: @"{ %@ }", fileContents];
	NSDictionary *dict = [string propertyList];
	return [NSMutableDictionary dictionaryWithDictionary: dict];
}
@end

void PrintMapTable(NSMapTable *mt)
{
	NSArray *keys = NSAllMapTableKeys(mt);
	NSEnumerator *en = [keys objectEnumerator];
	id k = nil;

	while ((k = [en nextObject]) != nil)
	{
		id v = NSMapGet(mt, k);
		NSLog(@"k = %@, v = %@", k, v);
	}
}

void PrintMapTableOids(NSMapTable *mt)
{
	NSArray *keys = NSAllMapTableKeys(mt);
	NSEnumerator *en = [keys objectEnumerator];
	void *k = NULL;

	while ((k = [en nextObject]) != nil)
	{
		void *v = NSMapGet(mt, k);
		NSLog(@"k = %@, v = %d", k, v);
	}
}

@implementation NIBParser

- (id) initWithNibNamed: (NSString *)nibNamed
{
	self = [super init];
	if (self != nil)
	{
		NSString *objectsNib = [nibNamed stringByAppendingPathComponent: @"objects.nib"];
		NSString *dataClasses = [nibNamed stringByAppendingPathComponent: @"data.classes"];
		NSArray *connections = nil;
		NSMapTable *nameTable = NULL;
		NSMapTable *oidTable = NULL;
		NSMapTable *objectTable = NULL;

		_object = [NSUnarchiver unarchiveObjectWithFile: objectsNib];
		_rootObject = [_object rootObject];
		
		nameTable = [_object nameTable];
		oidTable = [_object oidTable];
		objectTable = [_object objectTable];
		connections = [_object connections];

#ifdef DEBUG
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

#ifdef DEBUG
		NSLog(@"== nameTable");
		PrintMapTable(nameTable);
		NSLog(@"== objectTable");
		PrintMapTable(objectTable);
		NSLog(@"== oidTable");
		PrintMapTableOids(oidTable);
#endif
	}
	return self;
}

- (id) parse
{
	NSArray *os = [NSArray arrayWithObjects: @"com.apple.InterfaceBuilder3.Cocoa.XIB", @"3.0", @"32700.99.1234", @"MacOSX.Cocoa", @"none", @"YES", @"direct", nil];
	NSArray *ks = [NSArray arrayWithObjects: @"type", @"version", @"toolsVersion", @"targetRuntime", @"propertyAccessControl", @"useAutolayout", @"customObjectInstantiationMethod", nil];
	NSMutableDictionary *docAttrs = [NSMutableDictionary dictionaryWithObjects: os forKeys: ks];
	XMLDocument *document = [[XMLDocument alloc] initWithName: @"document" value: nil attributes: docAttrs elements: nil];
	NSMapTable *nameTable = [_object nameTable];
#ifdef DEBUG	
	NSArray *values = NSAllMapTableValues(nameTable);
#endif
	NSArray *keys = NSAllMapTableKeys(nameTable);
	NSEnumerator *en = [keys objectEnumerator];
	id o = nil;

#ifdef DEBUG
	NSLog(@"values = %@", values);
	NSLog(@"keys = %@", keys);
#endif

	// Create the root entry...
	[_objectsDictionary setObject: [NSMutableDictionary dictionary]	forKey: @"objects"];

	// Iterate over all objects in the map table...
	while ((o = [en nextObject]) != nil)
	{
		NSString *label = NSMapGet(nameTable, o);
		if ([o isKindOfClass: [NSWindowTemplate class]])
		{
			XMLNode *window = [o toXML];
			NSLog(@"XML = %@", window);
		}
		else if ([o isKindOfClass: [NSCustomObject class]])
		{
			XMLNode *co = [o toXML];
			[co addAttribute:@"userLabel" value: label];
			NSLog(@"XML = %@", co);
		}
		else if ([o isKindOfClass: [NSMenuTemplate class]])
		{
			// [self handleMenuObject: o];
		}
		else
		{
			NSLog(@"Unknown class: %@", o);
		}
	}

	return nil;
}

@end