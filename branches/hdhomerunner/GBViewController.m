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
//
//  GBViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBViewController.h"


@implementation GBViewController


+ (id) controller{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if (self = [super init]){
 
    }
    
    return self;
}

- (void)placeView:(NSView *)newView inView:(NSView *)viewPlaceholder{

	// If the view is not null
	if(newView){
	
		// Add the view as a subview to the current view
		[viewPlaceholder addSubview:newView];
		
		// Apply the changes immediately
		[viewPlaceholder displayIfNeeded];
		
		// Get the bounds of the current view
		NSRect newBounds;
		newBounds.origin.x = 0;
		newBounds.origin.y = 0;
		newBounds.size.width = [[newView superview] frame].size.width;
		newBounds.size.height = [[newView superview] frame].size.height;
		
		// Apply the bounds to the new view
		[newView setFrame:[[newView superview] frame]];
		
		// Make sure our added subview is placed and resizes correctly
		[newView setFrameOrigin:NSMakePoint(0,0)];
		[newView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
}

- (void)dealloc{
    [_view release];
    
    [super dealloc];
}

- (NSView *)view{
    return _view;
}

@end
