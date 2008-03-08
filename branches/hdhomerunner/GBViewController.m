// The MIT License
//
// Copyright (c) 2008 Gregory Barchard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
