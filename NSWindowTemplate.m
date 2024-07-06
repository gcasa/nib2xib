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
#import <AppKit/AppKit.h>

#import "NSWindowTemplate.h"

#import "XMLNode.h"
#import "NSString+Additions.h"
@implementation NSWindowTemplate (Methods)

- (int) interfaceStyle
{
    return wtFlags.style;
}

- (void) setInterfaceStyle:(int)fp16
{
    wtFlags.style = fp16;
}

- (NSRect) windowRect
{
    return windowRect;
}

- (int) windowStyleMask
{
    return windowStyleMask;
}

- (int) windowBacking
{
    return windowBacking;
}

- (NSString *) windowTitle
{
    return windowTitle;
}

- (NSString *) viewClass
{
    return viewClass;
}

- (NSString *) windowClass
{
    return windowClass;
}

- (id) windowView
{
    return windowView;
}

- (id) realObject
{
    return realObject;
}

- (NSSize) minSize
{
    return minSize;
}

- (GSWindowTemplateFlags) wtFlags
{
    return wtFlags;
}

- (NSRect) screenRect
{
    return screenRect;
}

- (NSMutableDictionary *) attributesFromProperties
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    // Title and other string properties...
    [result setObject: windowTitle forKey: @"title"];

    // Flags...
    // TODO...

    return result;
}

- (NSMutableDictionary *) frameAttributes
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject: [NSString stringWithFormat: @"%g", windowRect.origin.x] forKey: @"x"];
    [result setObject: [NSString stringWithFormat: @"%g", windowRect.origin.y] forKey: @"y"];
    [result setObject: [NSString stringWithFormat: @"%g", windowRect.size.width] forKey: @"width"];
    [result setObject: [NSString stringWithFormat: @"%g", windowRect.size.height] forKey: @"height"];
    [result setObject: @"contentRect" forKey: @"key"];
    return result;
}

- (XMLNode *) toXML
{
    XMLNode *windowViewXml = [windowView toXML];
    NSMutableDictionary *attributes = [self attributesFromProperties];
    NSMutableArray *elements = [NSMutableArray arrayWithObject: windowViewXml];
    NSString *name = [windowClass classNameToTagName];
    XMLNode *node = [[XMLNode alloc] initWithName: name value: @"" attributes: attributes elements: elements];
    XMLNode *frame = [[XMLNode alloc] initWithName: @"rect" value: @"" attributes: [self frameAttributes] elements: nil];

    // [subviewsXml setElements: [NSMutableArray arrayWithObject: windowViewXml]];
    [windowViewXml addAttribute: @"key" value: @"contentView"];
    [node addElement: frame];
    
    return node;
}

@end