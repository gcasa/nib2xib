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

/* NSIBObjectData.h created by heron on Fri 13-Oct-2023 */

#import <AppKit/AppKit.h>
#import <Foundation/NSObject.h>

@interface NSIBObjectData : NSObject
{
  id rootObject;
  NSMapTable *objectTable;
  NSMapTable *nameTable;
  NSMutableSet *visibleWindows;
  NSMutableArray *connections;
  id firstResponder;
  id fontManager;
  NSMapTable *oidTable;
  unsigned int nextOid;
  NSMapTable *classTable;
  NSMapTable *instantiatedObjectTable;
}
@end 

@interface NSIBObjectData (Methods)
- (NSMapTable *) instantiatedObjectTable;
- (NSMapTable *) classTable;
- (NSMapTable *) oidTable;
- (NSMapTable *) nameTable;
- (NSMapTable *) objectTable;

- (unsigned int) nextOid;

- (NSArray *) connections;

- (id) firstResponder;
- (id) fontManager;
- (id) rootObject;
@end
