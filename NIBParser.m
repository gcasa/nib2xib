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
		
		_nameTable = NULL;
		_oidTable = NULL;
		_objectTable = NULL;

		_object = [NSUnarchiver unarchiveObjectWithFile: objectsNib];
		_rootObject = [_object rootObject];
		
		_nameTable = [_object nameTable];
		_oidTable = [_object oidTable];
		_objectTable = [_object objectTable];
		_connections = [_object connections];
		
#ifdef DEBUG
		NSLog(@"objectsNib = %@", objectsNib);
		NSLog(@"dataClasses = %@", dataClasses);
		NSLog(@"connections = %@", _connections);
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
		PrintMapTable(_nameTable);
		NSLog(@"== objectTable");
		PrintMapTable(_objectTable);
		NSLog(@"== oidTable");
		PrintMapTableOids(_oidTable);
#endif
	}
	return self;
}

- (NSString *) oidForObject: (id)obj
{
	int k = (int)NSMapGet(_oidTable, obj);
	int n = (k != 0) ? k : [obj hash]; // if no oid, use the hash
	NSString *result = [NSString stringWithFormat: @"%08x", n];
	NSString *first = [result substringWithRange: NSMakeRange(0, 3)];
	NSString *middle = [result substringWithRange: NSMakeRange(3, 2)];
	NSString *last = [result substringWithRange: NSMakeRange(5, 3)];
	return [NSString stringWithFormat: @"%@-%@-%@", first, middle, last];
}

- (NSString *) oidString
{
	
}

- (id) parse
{
	NSArray *os = [NSArray arrayWithObjects: @"com.apple.InterfaceBuilder3.Cocoa.XIB", @"3.0", @"32700.99.1234", @"MacOSX.Cocoa", @"none", @"YES", @"direct", nil];
	NSArray *ks = [NSArray arrayWithObjects: @"type", @"version", @"toolsVersion", @"targetRuntime", @"propertyAccessControl", @"useAutolayout", @"customObjectInstantiationMethod", nil];
	NSMutableDictionary *docAttrs = [NSMutableDictionary dictionaryWithObjects: os forKeys: ks];
	XMLDocument *document = [[XMLDocument alloc] initWithName: @"document"]; // value: nil attributes: docAttrs elements: nil];
	NSMapTable *nameTable = [_object nameTable];
#ifdef DEBUG	
	NSArray *values = NSAllMapTableValues(nameTable);
#endif
	NSArray *keys = NSAllMapTableKeys(nameTable);
	NSEnumerator *en = [keys objectEnumerator];
	XMLNode *dependencies = [[XMLNode alloc] initWithName: @"dependencies"];
	XMLNode *deployment = [[XMLNode alloc] initWithName: @"deployment"];
	XMLNode *plugIn = [[XMLNode alloc] initWithName: @"plugIn"];
	XMLNode *capability = [[XMLNode alloc] initWithName: @"capability"];
	XMLNode *objects = [[XMLNode alloc] initWithName: @"objects"];
	id o = nil;

#ifdef DEBUG
	NSLog(@"values = %@", values);
	NSLog(@"keys = %@", keys);
#endif

	// Create objects element...
	[document setAttributes: docAttrs];
	[deployment addAttribute: @"identifier" value: @"macosx"];
	[plugIn addAttribute: @"identifier" value: @"com.apple.InterfaceBuilder.CocoaPlugin"];
	[plugIn addAttribute: @"version" value: @"22690"];
	[capability addAttribute: @"name" value: @"documents saved in the Xcode 8 format"];
	[capability addAttribute: @"minToolsVersion" value: @"8.0"];
	[dependencies addElement: deployment];
	[dependencies addElement: plugIn];
	[dependencies addElement: capability];
	[document addElement: dependencies];
	[document addElement: objects];

	// Iterate over all objects in the map table...
	// NOTE: At first this is confusing and it looks backwards...
	//   it's important to remember that in the maptable in a nib, the
	//   keys are the objects.   This table maps the objects back to their
	//   symbolic names in the nib file.
	while ((o = [en nextObject]) != nil)
	{
		NSString *label = NSMapGet(nameTable, o);
		if ([o isKindOfClass: [NSWindowTemplate class]])
		{
			XMLNode *window = [o toXMLWithParser: self];

			[objects addElement: window];
		}
		else if ([o isKindOfClass: [NSCustomObject class]])
		{
			XMLNode *co = [o toXMLWithParser: self];

			[co addAttribute:@"userLabel" value: label];
			[objects addElement: co];
		}
		else if ([o isKindOfClass: [NSMenuTemplate class]])
		{
			XMLNode *menu = [o toXMLWithParser: self];

			[objects addElement: menu];
			// NSLog(@"menuNode = %@", menuNode);
		}
		else
		{
			NSLog(@"Unknown class: %@", o);
		}
	}

	return document;
}

@end