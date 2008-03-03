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
