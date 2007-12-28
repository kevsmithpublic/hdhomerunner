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
//  GBWindowController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DBSourceSplitView.h"
#import "DBListSplitView.h"

#import "GBTunerController.h"
#import "GBChannelController.h"

#import "GBSourceListOutlineView.h"

#import "GBTuner.h"
#import "GBChannel.h"

@interface GBWindowController : NSWindowController {

	// Main Window
	/*IBOutlet DBSourceSplitView *sourceSplitView;
	IBOutlet DBListSplitView *listSplitView;
	IBOutlet NSView *sourceViewPlaceholder;
	IBOutlet NSView *contentViewPlaceholder;
	
	// Source View
	IBOutlet	NSView						*sourceView;
	IBOutlet	GBSourceListOutlineView		*outlineView;
	
	
	IBOutlet	NSSplitView					*splitView;
	IBOutlet	NSView						*contentView;
	
	IBOutlet	NSTreeController	*treeController;
	IBOutlet	NSButton			*addFolderButton;
	IBOutlet	NSButton			*removeButton;
	IBOutlet	NSPopUpButton		*actionButton;
	
				NSMutableArray		*contents;*/
				
	// Main window elements
	IBOutlet		DBSourceSplitView		*splitView;
	IBOutlet		NSView					*sourceViewPlaceholder;
	IBOutlet		NSView					*contentViewPlaceholder;
	IBOutlet		NSToolbar				*toolbar;
	
	// Toolbar Items
	IBOutlet		NSToolbarItem			*playToolbarItem;
	IBOutlet		NSToolbarItem			*infoToolbarItem;
	IBOutlet		NSToolbarItem			*reloadToolbarItem;
	IBOutlet		NSToolbarItem			*preferencesToolbarItem;
	
	// Source View elements
	IBOutlet		NSView					*sourceView;
	IBOutlet		GBSourceListOutlineView	*GBOutlineView;
	
	// Content View elements
	IBOutlet		NSView					*contentView;
	
	// Current View portion of the Content View
	IBOutlet		NSView					*currentView;
	
	// The menu item associated with importing HDHomeRunControl ChannelMaps
	IBOutlet		NSMenuItem				*importhdhrcontrol;				
	
	// The menu item associated with exporting HDHomeRunControl ChannelMaps
	IBOutlet		NSMenuItem				*exporthdhrcontrol;

	
					NSMutableArray			*contents;
}

- (NSMutableArray *)contents;
- (void)setContents:(NSArray *)newContents;

- (void)changeContentView:(NSView *)newView;

// Toolbar actions
- (IBAction)play:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)getInfo:(id)sender;
- (IBAction)refreshDevices:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)record:(id)sender;

// Outline view datasource methods
- (id)outlineView:(NSOutlineView *)outlineView 
    child:(int)index 
    ofItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView 
    isItemExpandable:(id)item;
- (int)outlineView:(NSOutlineView *)outlineView 
    numberOfChildrenOfItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView 
    objectValueForTableColumn:(NSTableColumn *)tableColumn 
    byItem:(id)item;
	
// Outline view delegate methods
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
- (BOOL)selectionShouldChangeInOutlineView:(NSOutlineView *)outlineView;
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item;
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;

// File Panel to import/export Channels
-(IBAction)importChannels:(id)sender;
-(IBAction)exportChannels:(id)sender;
-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// User Default methods
- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)resetUserDefaults;
- (BOOL)resetUserDefaultsRequired;
- (void)loadUserDefaults;

@end
