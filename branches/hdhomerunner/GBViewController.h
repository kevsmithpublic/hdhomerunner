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
//  GBViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Based on code from SubviewController.h
// Joar Wingfors joar.com

@interface GBViewController : NSObject {
		
		// The view to control
		IBOutlet		NSView			*_view;

}

// Convenience factory method
+ (id)controller;

// The view displayed in the table view
- (NSView *)view;

// Load a new view in place of the old view
- (void)placeView:(NSView *)newView inView:(NSView *)viewPlaceholder;

@end
