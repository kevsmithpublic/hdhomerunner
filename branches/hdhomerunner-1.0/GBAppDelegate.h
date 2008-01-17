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
//  GBAppDelegate.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
// Import the hdhomerun library
//#import "hdhomerun.h"

// Import the tuner class
#import "GBTuner.h"

// Import window controller
#import "GBWindowController.h"

//#import "DBSourceSplitView.h"

// Declare classes
@class DSGeneralOutlineView;
//@class GBWindowController;

@interface GBAppDelegate : NSObject {

	// The tuners available on the network
					NSMutableArray			*tuners;
	
	// The outline view
	IBOutlet		DSGeneralOutlineView	*sourceListOutlineView;
					
	// The window controller to handle view data
	IBOutlet		GBWindowController		*windowController;
	
					CGFloat					row_height;
}

- (NSArray *)tuners;
- (void)setTuners:(NSArray *)newTuners;
- (void)addTuner:(GBTuner *)newTuner;
- (void)removeTuner:(GBTuner *)aTuner;
- (NSArray *)discoverTuners;

- (void)reloadDataForObject:(NSNotification *)notification;

- (BOOL)outlineView:(NSOutlineView *)outlineview shouldSelectItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldHandleKeyDown:(NSEvent *)keyEvent;
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tc item:(id)item;
- (NSImage *)outlineView:(NSOutlineView *)outlineview dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPointPointer)imageLocation dragImageSize:(NSSize)imageSize event:(NSEvent *)event;
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item;
@end
