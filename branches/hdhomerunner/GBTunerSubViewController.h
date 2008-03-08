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

		// Large type elements
		IBOutlet		NSWindow					*largeWindow;

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
		
		// Elements of the largetype subview to control
		IBOutlet		NSLevelIndicator			*_strength_largetype;
		IBOutlet		NSTextField					*_strengthValue_largetype;

		IBOutlet		NSLevelIndicator			*snr_strength_largetype;
		IBOutlet		NSTextField					*snr_strengthValue_largetype;
		
		IBOutlet		NSLevelIndicator			*seq_strength_largetype;
		IBOutlet		NSTextField					*seq_strengthValue_largetype;
		
		IBOutlet		NSTextField					*firmware_Value_largetype;
}

// Display large type
- (void)displayLargeType;

// Key value observing methods
- (void)registerAsObserverForTuner:(GBTuner *)tuner;
- (void)unRegisterAsObserverForTuner:(GBTuner *)tuner;
@end
