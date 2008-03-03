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
