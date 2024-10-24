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

#import "NSObject+KeyExtraction.h"
#import "NSString+Additions.h"

@implementation NSObject (KeyExtraction)

+ (void) getAllMethodsForClass: (Class)cls
		     intoArray: (NSMutableArray *)methodsArray
{
	void *iterator = 0;
  struct objc_method_list *mlist;
  struct objc_class *superclass;

  if (cls == nil || cls == [NSObject class])
  {
    return;
  }
  
  while ( mlist = class_nextMethodList( cls, &iterator ) )
  {
  	unsigned int count = 0; 
  	unsigned int i = 0;

  	count = mlist->method_count;
  	for (i = 0; i < count; count++)
  	{
    	struct objc_method method = mlist->method_list[i];
    	SEL method_name = method.method_name;
    	[methodsArray addObject: NSStringFromSelector(method_name)];
  	}
  }
  
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
  return [NSArray array]; // WithObjects: @"context", // @"buildConfigurationList", @"buildConfigurations",
		  //@"array", @"valueforKey", @"objectatIndexedSubscript", @"totalFiles",
		  //@"filename", @"currentFile", @"parameter", @"showEnvVarsInLog", nil];
}

- (NSArray *) keysForObject: (id)object
{
  NSArray *methods = [NSObject recursiveGetAllMethodsForClass: [object class]];
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

@end