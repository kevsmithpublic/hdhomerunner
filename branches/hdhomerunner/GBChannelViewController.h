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
//  GBChannelViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GBViewController.h"
#import "GBChannel.h"

@interface GBChannelViewController : GBViewController {

		// Interface elements
		IBOutlet			NSTextField			*_description;
		IBOutlet			NSTextField			*_channelNumber;
		IBOutlet			NSTextField			*_program;
		IBOutlet			NSTextField			*_url;
		IBOutlet			NSImageView			*_imageView;
		
		// The channel to display info for
							GBChannel			*channel;
}
- (void)reloadView;

// Accessor Methods
- (void)setChannel:(GBChannel *)aChannel;
- (GBChannel *)channel;

// IBAction methods
- (IBAction)setIcon:(id)sender;

- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString;

// Compare self and controller to see if they're equal
- (BOOL)isEqual:(GBChannelViewController *)controller;
@end
