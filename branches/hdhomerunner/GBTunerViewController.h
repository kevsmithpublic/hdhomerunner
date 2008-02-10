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
}

// Accessor Methods
- (void)setTuner:(GBTuner *)aTuner;
- (GBTuner *)tuner;

// Manage menu items
- (NSMenuItem *)playMenu;
- (void)setPlayMenu:(NSMenuItem *)menu;
- (void)addPlayMenuItem:(NSMenuItem *)menuItem;
- (void)removePlayMenuItem:(NSMenuItem *)menuItem;

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
