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
//  GBTunerSubViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GBViewController.h"
#import "GBTuner.h"

@interface GBTunerSubViewController : GBViewController {

		// Placeholder elements
		IBOutlet		NSView						*levelIndicatorPlaceholder;
		IBOutlet		NSView						*valuePlaceholder;
		
		IBOutlet		NSView						*snr_levelIndicatorPlaceholder;
		IBOutlet		NSView						*snr_valuePlaceholder;
		
		IBOutlet		NSView						*seq_levelIndicatorPlaceholder;
		IBOutlet		NSView						*seq_valuePlaceholder;
		
		IBOutlet		NSView						*firmware_valuePlaceholder;
		
		// Elements of the subview to control
		IBOutlet		NSLevelIndicator			*_strength;
		IBOutlet		NSTextField					*_strengthValue;

		IBOutlet		NSLevelIndicator			*snr_strength;
		IBOutlet		NSTextField					*snr_strengthValue;
		
		IBOutlet		NSLevelIndicator			*seq_strength;
		IBOutlet		NSTextField					*seq_strengthValue;
		
		IBOutlet		NSTextField					*firmware_Value;
}

// Key value observing methods
- (void)registerAsObserverForTuner:(GBTuner *)tuner;
- (void)unRegisterAsObserverForTuner:(GBTuner *)tuner;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
