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
#import "NSView+Additions.h"
#import "NSString+Additions.h"

@implementation NSView (toXML)

- (NSMutableArray *) subviewsToXml
{
    NSMutableArray *array = [NSMutableArray array];
    NSEnumerator *en = [[self subviews] objectEnumerator];
    NSView *v = nil;

    while ((v = [en nextObject]) != nil)
    {
        XMLNode *n = [v toXML];
        [array addObject: n];        
    }

    return array;
}

- (NSMutableDictionary *) attributesFromProperties
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    // TODO
    return result;
}

- (NSMutableDictionary *) frameAttributes
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject: [NSString stringWithFormat: @"%g", [self frame].origin.x] forKey: @"x"];
    [result setObject: [NSString stringWithFormat: @"%g", [self frame].origin.y] forKey: @"y"];
    [result setObject: [NSString stringWithFormat: @"%g", [self frame].size.width] forKey: @"width"];
    [result setObject: [NSString stringWithFormat: @"%g", [self frame].size.height] forKey: @"height"];
    [result setObject: @"frame" forKey: @"key"];
    return result;
}

- (XMLNode *) toXML
{
    NSMutableDictionary *attributes = [self attributesFromProperties];
    NSMutableArray *elements = [self subviewsToXml];
    NSString *className = NSStringFromClass([self class]);    
    NSString *name = [className classNameToTagName];
    XMLNode *node = [[XMLNode alloc] initWithName: name value: @"" attributes: attributes elements: elements];
    XMLNode *frame = [[XMLNode alloc] initWithName: @"rect" value: @"" attributes: [self frameAttributes] elements: nil];
    [node addElement: frame];
    return node;
}

@end