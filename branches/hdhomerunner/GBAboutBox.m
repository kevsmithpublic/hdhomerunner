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
//  GBAboutBox.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBAboutBox.h"

// Portions of this document uses code from CocoaDevCentral's 
// Scrolling About Box http://cocoadevcentral.com/articles/000044.php

@implementation GBAboutBox

#define START_DELAY			2.0
#define TIME_INTERVAL		1/2

static GBAboutBox *sharedInstance = nil;

// Initialize
- (id)init{

	// If an instance of the class already exists
	if(sharedInstance){

		// dealloc it
		[self dealloc];
	} else {
	
		// Call the super class's init
		sharedInstance = [super init];
			
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed: @"AboutBox" owner: sharedInstance]){
			
			// Release
			[sharedInstance release];
			
			// Point to nil
			sharedInstance = nil;
		}
	}

	return sharedInstance;
}

// Awake from NIB
- (void)awakeFromNib{
	
	[imageView setImageScaling:NSScaleProportionally];
}

// Only allow one instance of GBAboutBox to be displayed
+ (GBAboutBox *)sharedInstance{
    return sharedInstance ? sharedInstance : [[self alloc] init];
}

// Open a url depending on the button pressed
- (IBAction)openURL:(id)sender{
	
	// The url to open
	NSURL *url;
	
	// Set the url depending on the button pressed
	if(sender == websiteButton){
	
		// Set the url to hdhomerunner's homepage
		url = [NSURL URLWithString:@"http://www.barchard.net/projects/hdhomerunner/hdhomerunner.html"];
	} else if(sender == licenseButton){
	
		// Set the url to hdhomerunner's license
		url = [NSURL URLWithString:@"http://www.gnu.org/licenses/gpl.html"];	
	} else if(sender == sourceButton){
	
		// Set the url to hdhomerunner's source code
		url = [NSURL URLWithString:@"http://hdhomerunner.googlecode.com/"];	
	}
	
	// Open the url in the workspace
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	[workspace openURL:url];
}

// We are showing the panel so set up the text fields
- (IBAction)showPanel:(id)sender{

	// The localized info dictionary
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		
	// Set up the text fields
	[appNameField setObjectValue:[infoDictionary objectForKey:@"CFBundleName"]];	
	[versionField setObjectValue:[NSString stringWithFormat:@"Version %@", [infoDictionary objectForKey:@"CFBundleVersion"]]];
	
	// Set up the icon view
	[imageView setImage:[NSApp applicationIconImage]];
	
	// Set up the scroll variables
	
	NSString *creditsPath = [[NSBundle mainBundle] pathForResource:@"Credits" 
                                             ofType:@"rtf"];

	NSAttributedString *creditsString = [[NSAttributedString alloc] initWithPath:creditsPath 
                                                    documentAttributes:nil];
    
	// Put the file into the view
	[creditsField replaceCharactersInRange:NSMakeRange( 0, 0 ) 
                      withRTF:[creditsString RTFFromRange:
                               NSMakeRange( 0, [creditsString length] ) 
                                             documentAttributes:nil]];
	
	// The max scroll height
	maxScrollHeight = [[creditsField string] length];
	
	// The current position in the school
	currentPosition = 0;
	
	// Whether we should start at the top
	restartAtTop = NO;
	
	// The time to start scrolling
	startTime = [NSDate timeIntervalSinceReferenceDate] + START_DELAY;
	
	// The beginning
	[creditsField scrollPoint:NSMakePoint( 0, 0 )];
	
	
	// Show the window at front
    [[appNameField window] makeKeyAndOrderFront:nil];
}

// When the about box becomes the focused window begin the scrolling
- (void)windowDidBecomeKey:(NSNotification *)notification{
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL 
                           target:self 
                           selector:@selector(scrollCredits:) 
                           userInfo:nil 
                           repeats:YES];
}

// When the about box loses focus stop the scrolling
- (void)windowDidResignKey:(NSNotification *)notification{
    [timer invalidate];
}

// Periodically scroll the credits
- (void)scrollCredits:(NSTimer *)timer{
	
	// If we have passed our start time
	if ([NSDate timeIntervalSinceReferenceDate] >= startTime){
		
		if (restartAtTop){
		
            // Reset the startTime
            startTime = [NSDate timeIntervalSinceReferenceDate] + START_DELAY;
            restartAtTop = NO;
            
            // Set the position
            [creditsField scrollPoint:NSMakePoint( 0, 0 )];
            
            return;
        }
		
		//  If the current position is greater than the max scroll height
		if (currentPosition >= maxScrollHeight){
		
            // Reset the startTime
            startTime = [NSDate timeIntervalSinceReferenceDate] + START_DELAY;
            
            // Reset the position
            currentPosition = 0;
            restartAtTop = YES;
        } else {
		
            // Scroll to the position
            [creditsField scrollPoint:NSMakePoint( 0, currentPosition )];
            
            // Increment the scroll position
            currentPosition += 0.01;
        }
	}
}

- (void)dealloc{

	[timer release];
	
	[super dealloc];
}
@end
