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
//  GBTunerSubViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBTunerSubViewController.h"


@implementation GBTunerSubViewController

// Initialize
- (id)init{

	// Call the super class's init
	if(self = [super init]){
		
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed: @"TunerSubView" owner: self]){
            
			// Release
			[self release];
			
			// Point to nil
            self = nil;
        }
	}

	return self;
}

- (void)awakeFromNib{
	
	// Replace the placeholders with their respective views
	[self placeView:_strength inView:levelIndicatorPlaceholder];
	[self placeView:_strengthValue inView:valuePlaceholder];
	
	[self placeView:snr_strength inView:snr_levelIndicatorPlaceholder];
	[self placeView:snr_strengthValue inView:snr_valuePlaceholder];
	
	[self placeView:seq_strength inView:seq_levelIndicatorPlaceholder];
	[self placeView:seq_strengthValue inView:seq_valuePlaceholder];
	
	[self placeView:firmware_Value inView:firmware_valuePlaceholder];
	
	// The font to use
	NSFont *font = [NSFont labelFontOfSize:16.0f];
	
	// Set the text size of the large type display
	[_strengthValue_largetype setFont:font];
	
	[snr_strengthValue_largetype setFont:font];
	
	[seq_strengthValue_largetype setFont:font];
	
	[firmware_Value_largetype setFont:font];
}

// Display large type
- (void)displayLargeType{

	// Whichever view hdhomerunner is active on (main display or external)
	// display the largetype window on that display
	NSScreen *screen = [[NSApp mainWindow] screen];
	NSRect frame = [screen visibleFrame];
	
	// Fill the screen
	[largeWindow setFrame:frame display:YES];
	
	
	// Make the display the key window
	[largeWindow makeKeyAndOrderFront:nil];
	
	// Center the window
	[largeWindow center];
}

// Register for Key Value Coding of the tuner
// When the signal strength changes we should update the view
- (void)registerAsObserverForTuner:(GBTuner *)tuner{

	// Bind the level indicators to the appropriate tuner properites
	
	// The main window
	[_strength bind:@"value" toObject:tuner withKeyPath:@"signalStrength" options:nil];
	[snr_strength bind:@"value" toObject:tuner withKeyPath:@"signalToNoiseRatio" options:nil];
	[seq_strength bind:@"value" toObject:tuner withKeyPath:@"symbolErrorQuality" options:nil];	
	
	// The largetype window
	[_strength_largetype bind:@"value" toObject:tuner withKeyPath:@"signalStrength" options:nil];
	[snr_strength_largetype bind:@"value" toObject:tuner withKeyPath:@"signalToNoiseRatio" options:nil];
	[seq_strength_largetype bind:@"value" toObject:tuner withKeyPath:@"symbolErrorQuality" options:nil];
	
	
	// Bind the text indicators to the appropriate tuner properites
	
	// The main window
	[_strengthValue bind:@"value" toObject:tuner withKeyPath:@"signalStrength" options:nil];
	[snr_strengthValue bind:@"value" toObject:tuner withKeyPath:@"signalToNoiseRatio" options:nil];
	[seq_strengthValue bind:@"value" toObject:tuner withKeyPath:@"symbolErrorQuality" options:nil];
	[firmware_Value bind:@"value" toObject:tuner withKeyPath:@"firmwareVersion" options:nil];	
	
	// The largetype window
	[_strengthValue_largetype bind:@"value" toObject:tuner withKeyPath:@"signalStrength" options:nil];
	[snr_strengthValue_largetype bind:@"value" toObject:tuner withKeyPath:@"signalToNoiseRatio" options:nil];
	[seq_strengthValue_largetype bind:@"value" toObject:tuner withKeyPath:@"symbolErrorQuality" options:nil];
	[firmware_Value_largetype bind:@"value" toObject:tuner withKeyPath:@"firmwareVersion" options:nil];		
}

- (void)unRegisterAsObserverForTuner:(GBTuner *)tuner{

    [tuner removeObserver:self forKeyPath:@"signalStrength"];
	[tuner removeObserver:self forKeyPath:@"signalToNoiseRatio"];
	[tuner removeObserver:self forKeyPath:@"symbolErrorQuality"];
	[tuner removeObserver:self forKeyPath:@"firmwareVersion"];
}

#pragma mark -
#pragma mark  Comparison Methods
#pragma mark -




#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{

	[super dealloc];
}
@end
