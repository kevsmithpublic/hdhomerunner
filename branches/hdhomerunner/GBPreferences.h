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
//  GBPreferences.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBPreferences : NSObject {

		// The window to display all the items in
		IBOutlet		NSWindow				*window;
		
		// The views to switch between
		IBOutlet		NSView					*generalView;
		IBOutlet		NSView					*updateView;
		IBOutlet		NSView					*donateView;
		IBOutlet		NSView					*recordView;
		
		// Dictionary of toolbar items
						NSMutableDictionary		*toolbarItems;
}

+ (GBPreferences *)sharedInstance;

- (IBAction)showPanel:(id)sender;
- (IBAction)switchView:(id)sender;
- (IBAction)donate:(id)sender;
@end
