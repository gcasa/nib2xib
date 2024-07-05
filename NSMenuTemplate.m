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

#import "NSMenuTemplate.h"
#import <Foundation/NSString.h>

@implementation NSMenuTemplate (Methods)

- (NSString *) title
{
	return title;
}

- (NSString *) menuClassName
{
	return menuClassName;
}

- (id) view
{
	return view;
}

- (id) supermenu
{
	return supermenu;
}

- (id) realObject
{
	return realObject;
}

- (id) extension
{
	return extension;
}

- (NSPoint) location
{
	return location;
}

- (BOOL) isWindowsMenu
{
	return isWindowsMenu;
}

- (BOOL) isRequestMenu
{
	return isRequestMenu;
}

- (BOOL) isFontMenu
{
	return isFontMenu;
}

- (int) interfaceStyle
{
	return interfaceStyle;
}

@end