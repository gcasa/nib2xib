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

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *) classNameToTagName
{
    NSString *modifiedString = self;

    // Check if the string starts with "NS"
    if ([self hasPrefix:@"NS"]) 
    {
        modifiedString = [self substringFromIndex: 2];
    }

    // Lowercase the first letter
    if ([modifiedString length] > 0) 
    {
        NSString *firstLetter = [[modifiedString substringToIndex: 1] lowercaseString];
        NSString *remainingString = [modifiedString substringFromIndex: 1];
        modifiedString = [firstLetter stringByAppendingString: remainingString];
    }

    return modifiedString;
}

@end