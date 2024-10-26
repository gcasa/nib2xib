/*
   Copyright (C) 2024 Free Software Foundation, Inc.

   Written by: Gregory John Casamento <greg.casamento@gmail.com>
   Date: 2024

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110 USA.
*/

#import <objc/objc.h>
#import <objc/objc-class.h>

#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import <AppKit/NSView.h>

#import "NSObject+KeyExtraction.h"
#import "NSString+Additions.h"
#import "XMLNode.h"

@implementation NSObject (KeyExtraction)

+ (void) getAllMethodsForClass: (Class)cls
		     intoArray: (NSMutableArray *)methodsArray
{
	void *iterator = 0;
  struct objc_method_list *mlist;
  struct objc_class *superclass;

  // NSLog(@"class = %@", cls);
  if (cls == nil || cls == [NSObject class])
  {
    return;
  }
  
  // NSLog(@"Processing method list...");
  while ( mlist = class_nextMethodList( cls, &iterator ) )
  {
  	unsigned int count = 0; 
  	unsigned int i = 0;

  	count = mlist->method_count;
    // NSLog(@"count = %d", count);
  	for (i = 0; i < count; i++)
  	{
    	struct objc_method method = mlist->method_list[i];
    	SEL method_name = method.method_name;
      NSString *methodName = NSStringFromSelector(method_name);

    	[methodsArray addObject: methodName];
      // NSLog(@"i = %d, methodName = %@", i, methodName);
  	}
  }
  // NSLog(@"Done processing");

  // Recursively call this method for the superclass
  superclass = cls->super_class;
  [self getAllMethodsForClass:superclass intoArray:methodsArray];
}

+ (NSArray *) recursiveGetAllMethodsForClass: (Class)cls
{
  NSMutableArray *methodsArray = [NSMutableArray array];
  [self getAllMethodsForClass: cls
		    intoArray: methodsArray];
  return [methodsArray copy];
}

+ (NSArray *) skippedKeys
{
  NSArray *_skippedKeys = [NSArray arrayWithObjects: 
    @"needsDisplay",
    @"needsDisplayInRect",
    @"upGState",
    nil];
  return _skippedKeys;
}

+ (NSArray *) keyObjects
{
  NSArray *_keyObjects = [NSArray arrayWithObjects:
    @"contentView",
    @"frame",
    nil];
  return _keyObjects;
}

- (NSArray *) keysForObject
{
  NSArray *methods = [NSObject recursiveGetAllMethodsForClass: [self class]];
  NSEnumerator *en = [methods objectEnumerator];
  NSString *selectorName = nil;
  NSMutableArray *result = [NSMutableArray arrayWithCapacity: [methods count]];
  
  while ((selectorName = [en nextObject]) != nil)
  {
    if ([selectorName hasPrefix: @"set"] && [selectorName isEqualToString: @"settings"] == NO)
		{
	  	NSString *keyName = [selectorName substringFromIndex: 3];

		  keyName = [keyName stringByReplacingOccurrencesOfString: @":" withString: @""];
		  keyName = [keyName lowercaseFirstCharacter];
	  	[result addObject: keyName];
		}
  } 

  return result;
}

- (XMLNode *) processObject
{
  NSArray *allKeys = [self keysForObject];
  NSEnumerator *e = [allKeys objectEnumerator];
  id k = nil;
  NSString *className = NSStringFromClass([self class]);    
  NSString *name = [className classNameToTagName];
  XMLNode *result = [[XMLNode alloc] initWithName: name];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

  NSLog(@"class = %@, keys = %@", className, allKeys);
  while ( (k = [e nextObject]) != nil )
  { 
    if ([[NSObject skippedKeys] containsObject: k] == NO)
    {
      SEL s = NSSelectorFromString(k);
      id o = [self performSelector: s];
      
      if ([o isKindOfClass: [NSArray class]])
      {
        NSEnumerator *aen = [o objectEnumerator];
        id obj = nil;

        while ((obj = [aen nextObject]) != nil)
        {
          XMLNode *xmlObject = [obj processObject];
          [result addElement: xmlObject];
        }
      }
      else if ([o isKindOfClass: [NSString class]])
      {
        [result addAttribute: k value: o];
      }
      else if ([o isKindOfClass: [NSObject class]])
      {
        if ([k isEqualToString: k])
        {
          NSArray *views = [o performSelector: s];
          XMLNode *sv = nil;
          NSEnumerator *sen = [views objectEnumerator];
          NSView *view = nil;
          NSMutableArray *elements = [NSMutableArray array];

          while ((view = [sen nextObject]) != nil)
          {
            XMLNode *node = [view processObject];
            [elements addObject: node];
          }

          sv = [[XMLNode alloc] initWithName: k value: @"" attributes: nil elements: elements];
        }
        else
        {

        }
      }
    }
  }

  return result;
}

@end