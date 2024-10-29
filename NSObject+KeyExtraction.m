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
#import "OidProvider.h"

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

/*
    titleWithMnemonic, 
    nextText, 
    previousText, 
    selectable, 
    editable, 
    bezeled, 
    bordered, 
    enabled, 
    textColor, 
    drawsBackground, 
    backgroundColor, 
    frameSize, 
    refusesFirstResponder, 
    needsDisplay, 
    objectValue, 
    doubleValue, 
    floatValue, 
    attributedStringValue, 
    intValue, 
    stringValue, 
    font, 
    alignment, 
    floatingPointFormatleftright, 
    enabled, 
    continuous, 
    ignoresMultiClick, 
    tag, 
    action, 
    target, 
    cell, 
    frameSize, 
    */

+ (NSArray *) skippedKeys
{
  NSArray *_skippedKeys = [NSArray arrayWithObjects: 
    @"needsDisplay",
    @"needsDisplayInRect",
    @"upGState",
    @"allowsEditingTextAttributes", 
    @"importsGraphics", 
    @"delegate", 
    @"errorAction", 
    @"postsBoundsChangedNotifications", 
    @"postsFrameChangedNotifications", 
    @"nextKeyView",
    @"prevKeyView",
    @"nextResponder",
    nil];
  return _skippedKeys;
}

+ (NSArray *) keyObjects
{
  NSArray *_keyObjects = [NSArray arrayWithObjects:
    @"contentView",
    @"cell",
    @"contentRect",
    @"screenRect",
    @"frame",
    @"autoresizingMask",
    @"windowStyleMask",
    nil];
  return _keyObjects;
}

+ (NSArray *) nonObjects
{
  NSArray *_nonObjects = [NSArray arrayWithObjects:
    @"contentRect",
    @"screenRect",
    @"frame",
    @"autoresizingMask",
    @"windowStyleMask",
    @"windowPositionMask",
    @"interfaceStyle", 
    @"boundsRotation", 
    @"boundsSize", 
    @"boundsOrigin", 
    @"bounds",
    @"frameRotation", 
    @"frame", 
    @"frameSize", 
    @"frameOrigin", 
    @"autoresizesSubviews",
    @"minSize",
    nil];
  return _nonObjects;
}

- (NSSet *) keysForObject
{
  NSArray *methods = [NSObject recursiveGetAllMethodsForClass: [self class]];
  NSEnumerator *en = [methods objectEnumerator];
  NSString *selectorName = nil;
  NSMutableSet *result = [NSMutableArray arrayWithCapacity: [methods count]];
  
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

- (NSString *) classNameForParser
{
  NSString *className = NSStringFromClass([self class]);    
  return className;
}

- (XMLNode *) processObjectWithParser: (id<OidProvider>)parser
{
  NSSet *allKeys = [self keysForObject];
  NSEnumerator *e = [allKeys objectEnumerator];
  id k = nil;
  NSString *className = [self classNameForParser];    
  NSString *name = [className classNameToTagName];
  XMLNode *result = [[XMLNode alloc] initWithName: name];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  NSString *oid = [parser oidForObject: self];

  if ([self isKindOfClass: [NSView class]])
  {
    NSLog(@"class = %@, keys = %@", className, allKeys);
  }
  
  [result addAttribute: @"id" value: oid];
  while ( (k = [e nextObject]) != nil )
  { 
    if ([[NSObject skippedKeys] containsObject: k] == NO)
    {
      SEL s = NSSelectorFromString(k);

      if ([[NSObject nonObjects] containsObject: k]) // frames, sizes, flags...
      {
        NSLog(@"Current NON-Object = %@", k);
        if ([[NSObject keyObjects] containsObject: k])
        {
          IMP imp = [self methodForSelector: s];
          if ([k hasSuffix: @"Rect"] || [k isEqualToString: @"frame"])
          {
            NSRect (*func)(id, SEL) = (NSRect (*)(id, SEL))imp;
            NSRect rect = (func)(self, s);
            XMLNode *rectNode = [XMLNode nodeForRect: rect type: k];
            [result addElement: rectNode];
          }
          else if ([k hasSuffix: @"Size"])
          {
            NSSize (*func)(id, SEL) = (NSSize (*)(id, SEL))imp;
            NSSize size = (func)(self, s);
            XMLNode *szNode = [XMLNode nodeForSize: size type: k];
            [result addElement: szNode];
          }
        }
      }
      else // Objects...
      {
        id o = [self performSelector: s];
        
        if ([[NSObject keyObjects] containsObject: k])
        {
        }
        else
        {
          NSLog(@"Current object = %@", k);
          if ([o isKindOfClass: [NSArray class]])
          {
            NSEnumerator *aen = [o objectEnumerator];
            id obj = nil;
            XMLNode *arrayObject = [[XMLNode alloc] initWithName: k];

            while ((obj = [aen nextObject]) != nil)
            {
              XMLNode *xmlObject = [obj processObjectWithParser: parser];
              [arrayObject addElement: xmlObject];
            }

            [result addElement: arrayObject];
          }
          else if ([o isKindOfClass: [NSString class]])
          {
            [result addAttribute: k value: o];
          }
        }
      }
    }
  }

  return result;
}

@end