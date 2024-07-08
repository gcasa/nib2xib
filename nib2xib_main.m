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

#import <AppKit/AppKit.h>
#import "NIBParser.h"

static NIBParser *_globalParser = nil;

int main(int argc, const char *argv[]) 
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  // If we have more than one argument, assume it is the nib file...
  if (argc > 1)
  {
    NSString *nibName = [NSString stringWithCString: argv[1]];
    NIBParser *parser = [[NIBParser alloc] initWithNibNamed: nibName];
    id output = [parser parse];

    _globalParser = parser;
    NSLog(@"--- Output");
    NSLog(@"parser = %@", parser);
    NSLog(@"output = %@", output);
  }

  [pool release];

  return 0;
}
