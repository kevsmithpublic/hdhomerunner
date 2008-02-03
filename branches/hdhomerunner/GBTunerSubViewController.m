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
}

// Register for Key Value Coding of the tuner
// When the signal strength changes we should update the view
- (void)registerAsObserverForTuner:(GBTuner *)tuner{
	
	[tuner addObserver:self
			forKeyPath:@"signalStrength"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
					
	[tuner addObserver:self
			forKeyPath:@"signalToNoiseRatio"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];

	[tuner addObserver:self
			forKeyPath:@"symbolErrorQuality"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];		
			
	[tuner addObserver:self
			forKeyPath:@"firmwareVersion"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];	
	
}

- (void)unRegisterAsObserverForTuner:(GBTuner *)tuner{

    [tuner removeObserver:self forKeyPath:@"signalStrength"];
	[tuner removeObserver:self forKeyPath:@"signalToNoiseRatio"];
	[tuner removeObserver:self forKeyPath:@"symbolErrorQuality"];
	[tuner removeObserver:self forKeyPath:@"firmwareVersion"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
						ofObject:(id)object
                        change:(NSDictionary *)change
						context:(void *)context {
	// Lock the view
	//[[[self view] superview] lockFocus];
	
	// If the signal strength changed
	if ([keyPath isEqual:@"signalStrength"]) {
		
		// Update the level indicator
		[_strength setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
		
		// Update the level indicator text value
		[_strengthValue setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
    } else if([keyPath isEqual:@"signalToNoiseRatio"]) {

		// Update the level indicator
		[snr_strength setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
		
		// Update the level indicator text value
		[snr_strengthValue setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];	
	} else if([keyPath isEqual:@"symbolErrorQuality"]) {

		// Update the level indicator
		[seq_strength setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
		
		// Update the level indicator text value
		[seq_strengthValue setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];	
	} else if([keyPath isEqual:@"firmwareVersion"]) {
		
		// Update the firmware version text value
		[firmware_Value setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];	
	}
	
	// Unlock the view
	//[[[self view] superview] unlockFocus];
}

#pragma mark -
#pragma mark  Comparison Methods
#pragma mark -

// Compare self and controller to see if they're equal
- (BOOL)isEqual:(GBTunerSubViewController *)controller{
	
	// Return they are equal if the tuners are equal
	return [super isEqual:controller];
}


#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{
	//[_subview release];
	[_strength release];

	[super dealloc];
}
@end
