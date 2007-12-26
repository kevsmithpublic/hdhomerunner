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
	
	// Content View elements
	IBOutlet		NSView					*contentView;
	
					NSMutableArray			*contents;
}

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


@end
