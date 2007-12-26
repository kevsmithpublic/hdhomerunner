//    This file is part of hdhomerunner.

//    hdhomerunner is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    hdhomerunner is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//  GBChannelController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannelController.h"


@implementation GBChannelController
- (id)init{
	if(self = [super init]){
		[self setDescription:@"CHANNELS"];								// Set the description of the collection
		[self setTitle:@"CHANNELS"];									// Set the title of the collection
		[self setIsExpandable:YES];										// Set this is an expandable collection
		[self setChildren:[NSMutableArray arrayWithCapacity:0]];		// Set the collection to initially be empty
	
		//NSImage *icon = [NSImage imageNamed:@"Folder"];					// Set the icon to appear next to the title in the nsoutlineview
		//[self setIcon:icon];
	}
	
	return self;
}

#pragma mark - Clean up

// Clean up
- (void)dealloc{

	[super dealloc];
}

@end
