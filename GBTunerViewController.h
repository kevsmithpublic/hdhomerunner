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
//  GBTunerViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GBViewController.h"
#import "GBTunerSubViewController.h"
#import "GBTuner.h"

@interface GBTunerViewController : GBViewController {

		// Placeholder elements
		IBOutlet		NSView						*titlePlaceholder;
		IBOutlet		NSView						*captionPlaceholder;
		IBOutlet		NSView						*iconPlaceholder;

		// The elements in the view to control
		IBOutlet		NSTextField					*_title;
		IBOutlet		NSTextField					*_caption;
		IBOutlet		NSImageView					*_icon;
		
		// The tuner to represent
						GBTuner						*tuner;
		
		// The subviews of the tuner
						NSMutableArray				*subviews;
						
		// The menu to display when a user right clicks a tuner
		IBOutlet		NSMenuItem					*_play_menu;
		IBOutlet		NSMenuItem					*_scan_menu;
}

// Accessor Methods
- (void)setTuner:(GBTuner *)aTuner;
- (GBTuner *)tuner;

// Manage menu items
- (NSMenuItem *)playMenu;
- (void)setPlayMenu:(NSMenuItem *)menu;
- (void)addPlayMenuItem:(NSMenuItem *)menuItem;
- (void)removePlayMenuItem:(NSMenuItem *)menuItem;

// Returm the scan menu
- (NSMenuItem *)scanMenu;

// Set the scan menu
- (void)setScanMenu:(NSMenu *)menu;

// Add a menu item to the scanning menu
- (void)addScanMenuItem:(NSMenuItem *)menuItem;

// Remove a menu item from the scanning menu
- (void)removeScanMenuItem:(NSMenuItem *)menuItem;

- (NSArray *)subviews;
- (void)setSubviews:(NSArray *)array;

// Add a subview controller to the array
- (void)addSubview:(GBTunerSubViewController *)controller;

// Remove a subview controller to the array
- (void)removeSubview:(GBTunerSubViewController *)controller;

// Register all subviews as observers of aTuner
- (void)registerSubviewsForTuner:(GBTuner *)aTuner;

// Unregister all subviews as observers of aTuner
- (void)unRegisterSubviewsForTuner:(GBTuner *)aTuner;

// Register as an observer of aTuner
- (void)registerAsObserverForTuner:(GBTuner *)aTuner;

// Unregister as an observer of aTuner
- (void)unRegisterAsObserverForTuner:(GBTuner *)aTuner;

- (void)reloadView;
- (void)hideSubviews;
- (void)unhideSubviews;
- (void)redrawSubviews;

- (IBAction)largeType:(id)sender;

//- (BOOL)isEqual:(GBTunerViewController *)controller;
@end
