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
//  GBAboutBox.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBAboutBox :  NSObject {

	// Text fields
    IBOutlet		NSTextField		*appNameField;
    IBOutlet		NSTextView		*creditsField;
    IBOutlet		NSTextField		*versionField;
	
	// Images
	IBOutlet		NSImageView		*imageView;
	
	// Interface Buttons
	IBOutlet		NSButton		*websiteButton;
	IBOutlet		NSButton		*licenseButton;
	IBOutlet		NSButton		*sourceButton;
	
	// Timer to scroll the view
					NSTimer			*timer;
					
					float			currentPosition;
					float			maxScrollHeight;
					NSTimeInterval	startTime;
					BOOL			restartAtTop;
}
+ (GBAboutBox *)sharedInstance;

- (IBAction)openURL:(id)sender;
- (IBAction)showPanel:(id)sender;

- (void)scrollCredits:(NSTimer *)timer;
@end
