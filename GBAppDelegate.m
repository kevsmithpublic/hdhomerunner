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
//  GBAppDelegate.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBAppDelegate.h"

// The number of tuners per hdhomerun device
#define TUNERS_PER_DEVICE	2

// GUI Definitions
#define TITLE_HEIGHT			12.0
#define TITLE_FONT				@"Lucida Grande Bold"

#define CAPTION_HEIGHT			(TITLE_HEIGHT - 2.0)
#define CAPTION_FONT			@"Lucida Grande Bold"

#define TUNER_NIB_NAME			@"TunerView"			// nib name for the tuner view

@implementation GBAppDelegate

#pragma mark -
#pragma mark  Init Methods
#pragma mark -

- (id)init{
	
	if(self = [super init]){
		
		// Initialize the mutable array of tuners
		tuners = [[NSMutableArray alloc] initWithCapacity:0];
		
		// Mutable dictionary of the toolbar items
		toolbarItems = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		// Initialize the window controller
		windowController = [[GBWindowController alloc] initWithWindowNibName:TUNER_NIB_NAME];
		
		// Ensure that the nibs are loaded
		[windowController window];
		
		// Initialize the toolbaritem
		NSToolbarItem *_record = [[NSToolbarItem alloc] initWithItemIdentifier:@"Record"];
		[_record setAction:@selector(record:)];
		[_record setTarget:self];
		[_record setPaletteLabel:@"Record"];
		[_record setLabel:@"Record"];
		[_record setToolTip:@"Record"];
		[_record setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_record forKey:@"Record"];
		
		// Release the toolbar item
		[_record release];
		
		// Initialize the toolbaritem
		NSToolbarItem *_previous = [[NSToolbarItem alloc] initWithItemIdentifier:@"Previous"];
		[_previous setAction:@selector(previous:)];
		[_previous setTarget:self];
		[_previous setPaletteLabel:@"Previous"];
		[_previous setLabel:@"Previous"];
		[_previous setToolTip:@"Previous"];
		//[_previous setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_previous forKey:@"Previous"];
		
		// Release the toolbar item
		[_previous release];
		
		// Initialize the toolbaritem
		NSToolbarItem *_play = [[NSToolbarItem alloc] initWithItemIdentifier:@"Play"];
		[_play setAction:@selector(previous:)];
		[_play setTarget:self];
		[_play setPaletteLabel:@"Play"];
		[_play setLabel:@"Play"];
		[_play setToolTip:@"Play"];
		[_play setImage:[NSImage imageNamed:@"Play"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_play forKey:@"Play"];
		
		// Release the toolbar item
		[_play release];
		
		// Initialize the toolbaritem
		NSToolbarItem *_next = [[NSToolbarItem alloc] initWithItemIdentifier:@"Next"];
		[_next setAction:@selector(next:)];
		[_next setTarget:self];
		[_next setPaletteLabel:@"Next"];
		[_next setLabel:@"Next"];
		[_next setToolTip:@"Next"];
		//[_next setImage:[NSImage imageNamed:@"Next"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_next forKey:@"Next"];
		
		// Release the toolbar item
		[_next release];
		
		// Initialize the toolbaritem
		NSToolbarItem *_info = [[NSToolbarItem alloc] initWithItemIdentifier:@"Info"];
		[_info setAction:@selector(getInfo:)];
		[_info setTarget:self];
		[_info setPaletteLabel:@"Info"];
		[_info setLabel:@"Info"];
		[_info setToolTip:@"Info"];
		[_info setImage:[NSImage imageNamed:@"Get Info"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_info forKey:@"Info"];
		
		// Release the toolbar item
		[_info release];
		
		// Initialize the toolbaritem
		NSToolbarItem *_preferences = [[NSToolbarItem alloc] initWithItemIdentifier:@"Preferences"];
		[_preferences setAction:@selector(openPreferences:)];
		[_preferences setTarget:self];
		[_preferences setPaletteLabel:@"Preferences"];
		[_preferences setLabel:@"Preferences"];
		[_preferences setToolTip:@"Preferences"];
		[_preferences setImage:[NSImage imageNamed:@"General Preferences"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_preferences forKey:@"Preferences"];
		
		// Release the toolbar item
		[_preferences release];		
	}
	
	return self;
}

#pragma mark -
#pragma mark  Finish Launching & Awake from Nib
#pragma mark -

// The application will finish launching. Load contents from disk
- (void)applicationWillFinishLaunching:(NSNotification *)notification{
	

}

// Actions to complete before awaking from the NIB
- (void)awakeFromNib{
	
	// This will center the main window if there's no stored position for it.
	// The frame name (set up in IB) to MainWindow
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil){
		
		// Center the window
		[window center];
	}
	
	// Set the splitView's autosave name.
	[splitView setPositionAutosaveName:@"MainWindowSplitView"];

	// Load tuners from preferences

	// Locate all the tuners on the network
	NSArray *available_tuners = [self discoverTuners];
	
	// Any tuner not in the preferences but available should be added
	NSEnumerator	*tuner_enumerator = [available_tuners objectEnumerator];
	
	// The tuner
	GBTuner		*tuner;
	
	// Loop over the available tuners and try to add it to tuners
	while(tuner = [tuner_enumerator nextObject]){
	
		// Add the tuner to the array. addTuners: will check if the tuner is already
		// inside tuners so we don't have to check for that here.
		[self addTuner:tuner];
	}
	
	
	// Set the splitters' autosave names.
	//[splitView setPositionAutosaveName:@"SourceListSplitView"];
	//[splitView setPositionAutosaveName:@"ListSplitView"];

	// Set the source list view into the main window
	[sourceListView setFrameSize:[sourceListViewPlaceholder frame].size];
	[sourceListViewPlaceholder addSubview:sourceListView];
	
	// The font to use
	NSFont *font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];

	// Use the font height 
	float fontSize = TITLE_HEIGHT + CAPTION_HEIGHT;
	
	// Padding is the average of the top and bottom of the font
	float padding = ceilf( ( fabs([font ascender]) + fabs([font descender]) ) / 2. );
	
	// fontSize = fontSize * 2;
	fontSize *= 2;
	
	// Pad the fontSize. fontSize = fontSize + padding
	fontSize += padding;
	
	// If the fontSize is greater than 32 then make the larger of the two numbers (fontSize or 32).
	row_height = ( fontSize > 32. ? fontSize : 32. );

	// Set the row height
	[sourceListOutlineView setRowHeight:(row_height + 2.)];
	
	// Set up the outline view
	[sourceListOutlineView setAutoresizesOutlineColumn:NO];
	[sourceListOutlineView selectRow:0 byExtendingSelection:NO];
	
	// Set up the toolbar on the main window
	theToolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[theToolbar setDelegate:self];
    
	// Make the toolbar configurable
	[theToolbar setAllowsUserCustomization:YES];
	[theToolbar setAutosavesConfiguration:YES];
    
	// Attach the toolbar to the window
	[window setToolbar:theToolbar];
}

#pragma mark -
#pragma mark   Toolbar Delegate methods
#pragma mark -

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag{
	return [toolbarItems objectForKey:itemIdentifier];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{

	// Return all the keys as valid items plus the standard toolbar items
	return [[toolbarItems allKeys] arrayByAddingObjectsFromArray:
							[NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
													NSToolbarSpaceItemIdentifier,
													NSToolbarFlexibleSpaceItemIdentifier,
													NSToolbarCustomizeToolbarItemIdentifier,
													nil]];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{

	return [NSArray arrayWithObjects:NSToolbarSpaceItemIdentifier,
									@"Record",
									NSToolbarSeparatorItemIdentifier,
									@"Previous",
									@"Play",
									@"Next",
									NSToolbarSeparatorItemIdentifier,
									@"Get Info",
									NSToolbarFlexibleSpaceItemIdentifier,
									@"Preferences",
									NSToolbarCustomizeToolbarItemIdentifier,
									nil];
}

#pragma mark -
#pragma mark   Toolbar actions
#pragma mark -

// Play ToobarItem action
// Play the currently selected channel when the user clicks this item
- (IBAction)play:(id)sender{
	NSLog(@"play toolbar item selected");
}

// Next Toolbar action
// Move to the next channel when the user clicks this item
- (IBAction)next:(id)sender{
	NSLog(@"next toolbar item selected");
}

// Previous Toolbar action
// Move to the previous channel when the user clicks this item
- (IBAction)previous:(id)sender{
	NSLog(@"previous toolbar item selected");
}

// Get Info ToobarItem action
// Get info on the currently selected object when the user clicks this item
- (IBAction)getInfo:(id)sender{
	NSLog(@"info toolbar item selected");
}

// Refresh Device List ToobarItem action
// Manually refresh the list of devices when the user clicks this item
- (IBAction)refreshDevices:(id)sender{
	NSLog(@"refresh toolbar item selected");
}

// Open Preferences action
// Open the application preferences when the user clicks this item.
- (IBAction)openPreferences:(id)sender{
	NSLog(@"prefrences toolbar item selected");
}

// Record action
// Record the current channel when the user clicks this item
- (IBAction)record:(id)sender{
	NSLog(@"record toolbar item selected");
}

#pragma mark -
#pragma mark  Set, Add, remove, and discover tuners
#pragma mark -

// Get the tuners
- (NSArray *)tuners{
	return tuners;
}

// Set the tuners to new tuners while remaining key value coding compliant
- (void)setTuners:(NSArray *)newTuners{

	// If the new tuner array is not equal the existing array
	if(newTuners && ![tuners isEqualToArray:newTuners]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners setArray:newTuners];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Add a tuner to the array while remaining key value coding complaint
- (void)addTuner:(GBTuner *)newTuner{
	
	// Only add new tuner to the array if it isn't already in there
	if(![tuners containsObject:newTuner]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners addObject:newTuner];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Remove a tuner from the array while remaining key value coding complaint
- (void)removeTuner:(GBTuner *)aTuner{
	
	// Only remove the tuner from the array it is already in there
	if([tuners containsObject:aTuner]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners removeObject:aTuner];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Discover any tuners on the network
- (NSArray *)discoverTuners{
	
	// A temporary array to hold tuners that we find on the network
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
	
	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	struct hdhomerun_discover_device_t result_list[128];
	
	// Query the network for devices. Return the number of devices into count and populate the devices into the result list.
	uint32_t IP_WILD_CARD = 0;
	int count = hdhomerun_discover_find_devices_custom(IP_WILD_CARD, HDHOMERUN_DEVICE_TYPE_TUNER, HDHOMERUN_DEVICE_ID_WILDCARD, result_list, 128);
	//int count = hdhomerun_discover_find_devices(HDHOMERUN_DEVICE_TYPE_TUNER, result_list, 128);
	
	// Print the number of devices found.
	//NSLog(@"found %d devices", count);
	
	// Loop over all the devices. Create a GBTuner with each device we find.
	
	// The int we are going to use to loop
	int i;
	
	// Loop over each tuner in the results list
	for(i = 0; i < count; i++){
	
		// Assign the hdhomerun's device id parameter to dev_id
		unsigned int dev_id = result_list[i].device_id;

		// The int we are going to loop over
		int j;
		
		// Each hdhomerun physically has more than 1 tuner. Since the result_list does not factor this in
		// we should create an appropriate number of tuners.
		for(j = 0; j < TUNERS_PER_DEVICE; j++){
		
			// Print the tuner and device id that we are about to add
			//NSLog(@"Device ID: %x Tuner Number: %@", [[NSNumber numberWithUnsignedInt:dev_id] unsignedIntValue], [NSNumber numberWithUnsignedInt:j]);
			
			// Allocate the device
			GBTuner *aTuner = [[GBTuner alloc] initWithIdentificationNumber:[NSNumber numberWithUnsignedInt:dev_id] andTunerNumber:[NSNumber numberWithInt:j]];
			
			// Allocate and Initiate a newly created GBTuner object with the device id (dev_id) and tuner number (j)
			[tmp addObject:aTuner];
			
			// Register for notifications of when this objects title, caption, or image values change
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			[notificationCenter addObserver:self selector:@selector(reloadDataForObject:) name:@"GBTunerDataChanged" object:aTuner];
		}
	}
	
	// Return the collection of tuners
	return tmp;
}

#pragma mark -
#pragma mark  Notification Center Methods
#pragma mark -

// Reload the table data for the object posting the notification
- (void)reloadDataForObject:(NSNotification *)notification{

	// Get the object that posted the notification
	GBTuner *theTuner = [notification object];
	
	// Print debug info
	//NSLog(@"notification received from %@", [theTuner title]);
	
	// Get the row of the item that posted the notification
	int row = [sourceListOutlineView rowForItem:theTuner];
	
	// Make sure the row is greater than -1
	if(row > -1){
		
		// Tell the outline view to update only the row that posted the notification
		// This is more efficient than calling reloadData since we are only updating the single
		// cell rather than the entire table.
		[sourceListOutlineView setNeedsDisplayInRect:[sourceListOutlineView rectOfRow:row]];
	}
}

#pragma mark -
#pragma mark  Outlineview Delegate Methods
#pragma mark -

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
	
	// Print debug info
	NSLog(@"selection did change for view %@", [notification object]);
	
	// Set the window controller to display the selected tuner
	[windowController setRepresentedTuner:[sourceListOutlineView itemAtRow:[sourceListOutlineView selectedRow]]];
	
	// Change the view to the proper view
	[self changeCurrentView:[windowController view]];
	
	//[self changeCurrentView:[[sourceListOutlineView itemAtRow:[sourceListOutlineView selectedRow]] view]];
	
	//NSLog(@"selection did change notification %@", [[GBOutlineView itemAtRow:[GBOutlineView selectedRow]] class]);

	//id selectedObject = [GBOutlineView itemAtRow:[GBOutlineView selectedRow]];
		
	// We are going to loop over the contents and find out who the selected item belongs to
	//NSEnumerator *enumerator = [contents objectEnumerator];
	
	// The parent in contents
	//id parent;
	
	/*while(parent = [enumerator nextObject]){
		
		// If the selected item is in children
		if([[parent children] containsObject:selectedObject]){
			
			// We assume that we found the view somewhere,
			// that the selected object is unique to all parents,
			// and that all children do not have children themselves
			// else we may never find the selected object if it is a nested child.
			NSLog(@"found it");
			[self changeCurrentView:[parent viewForChild:selectedObject]];
		}
	}*/
	
	//[self changeContentView:[[contents objectAtIndex:1] view]];
	
	//NSLog(@"trying %@", [[contents objectAtIndex:1] view]);
	/*if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;

	// ask the tree controller for the current selection
	NSArray *selection = [treeController selectedObjects];
	if ([selection count] > 1)
	{
		// multiple selection - clear the right side view
		[self removeSubview];
		currentView = nil;
	}
	else
	{
		if ([selection count] == 1)
		{
			// single selection
			[self changeItemView];
		}
		else
		{
			// there is no current selection - no view to display
			[self removeSubview];
			currentView = nil;
		}
	}*/
}

// Specify whether the user should be able to select a particular item
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldSelectItem:(id)item{
	/*if ( [item isKindOfClass:[NSDictionary class]] ) {
		if ( [[item objectForKey:@"String"] isKindOfClass:[NSString class]] ) {
			if ( [[item objectForKey:@"String"] isEqualToString:@""] ) {
				return NO;
			}
		}
	}*/
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldHandleKeyDown:(NSEvent *)keyEvent{
	/*if ( [[olv selectedRowIndexes] count] == 1 ) {
		unichar aChar;
		
		if ( ([keyEvent characters] != nil) && ![keyEvent isARepeat] ) {
			aChar = [[keyEvent characters] characterAtIndex:0];
			if ( (aChar == NSCarriageReturnCharacter) || (aChar == NSEnterCharacter) ) {
				[olv editColumn:0 row:[[olv selectedRowIndexes] firstIndex] withEvent:keyEvent select:YES];
				return NO;
			}
		}
	}*/
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tc item:(id)item{
	if ( textMovement == NSReturnTextMovement )
		return NO;
	else if ( (textMovement == NSTabTextMovement) || (textMovement == NSBacktabTextMovement) ) 
		return NO;
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (NSImage *)outlineView:(NSOutlineView *)outlineview dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPointPointer)imageLocation dragImageSize:(NSSize)imageSize event:(NSEvent *)event
{
	NSImage *theImage = nil;
	NSPoint mouseLoc = [outlineview convertPoint:[event locationInWindow] fromView:nil];
	int draggedRow = [outlineview rowAtPoint:mouseLoc];
	int thisIndex = [selectedRows firstIndex];
	NSRect imageRect = [outlineview frameOfCellAtColumn:0 row:draggedRow];
	NSTableColumn *myColumn = [outlineview tableColumnWithIdentifier:@"The Column"];
	id anItem = nil;
	NSBezierPath *aPath = [NSBezierPath bezierPath];
	
	if ( [selectedRows containsIndex:draggedRow] && ([selectedRows count] > 1) ) {
		imageRect = NSUnionRect( [outlineview frameOfCellAtColumn:0 row:[selectedRows firstIndex]], [outlineview frameOfCellAtColumn:0 row:[selectedRows lastIndex]] );
		if ( NSHeight(imageRect) > NSHeight([[outlineview enclosingScrollView] documentVisibleRect]) )
			imageRect = NSIntersectionRect( imageRect, [[outlineview enclosingScrollView] documentVisibleRect] );
	}	
	imageRect.origin.y = 0.;
	imageRect.origin.x = 0.;
	
	imageRect = NSIntegralRect( imageRect );

	[aPath moveToPoint:NSMakePoint(NSMinX(imageRect) + 5., NSMinY(imageRect) )];
	[aPath curveToPoint:NSMakePoint(NSMinX(imageRect), NSMinY(imageRect) + 5.) controlPoint1:NSMakePoint(NSMinX(imageRect) + 2.5, NSMinY(imageRect)) controlPoint2:NSMakePoint(NSMinX(imageRect), NSMinY(imageRect) + 2.5)];
	
	[aPath lineToPoint:NSMakePoint(NSMinX(imageRect), NSMaxY(imageRect) - 5.)];
	[aPath curveToPoint:NSMakePoint(NSMinX(imageRect) + 5., NSMaxY(imageRect)) controlPoint1:NSMakePoint(NSMinX(imageRect), NSMaxY(imageRect) - 2.5) controlPoint2:NSMakePoint(NSMinX(imageRect) + 2.5, NSMaxY(imageRect))];
	
	[aPath lineToPoint:NSMakePoint(NSMaxX(imageRect) - 5., NSMaxY(imageRect))];
	[aPath curveToPoint:NSMakePoint(NSMaxX(imageRect), NSMaxY(imageRect) - 5.) controlPoint1:NSMakePoint(NSMaxX(imageRect) - 2.5, NSMaxY(imageRect)) controlPoint2:NSMakePoint(NSMaxX(imageRect), NSMaxY(imageRect) - 2.5)];
	
	[aPath lineToPoint:NSMakePoint(NSMaxX(imageRect), NSMinY(imageRect) + 5.)];
	[aPath curveToPoint:NSMakePoint(NSMaxX(imageRect) - 5., NSMinY(imageRect)) controlPoint1:NSMakePoint(NSMaxX(imageRect), NSMinY(imageRect) + 2.5) controlPoint2:NSMakePoint(NSMaxX(imageRect) - 2.5, NSMinY(imageRect))];
	[aPath closePath];
	
	theImage = [[NSImage alloc] initWithSize:imageRect.size];
	
	[theImage lockFocus];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[aPath addClip];
	[[[NSColor alternateSelectedControlColor] colorWithAlphaComponent:0.6] set];
	NSRectFillUsingOperation( imageRect, NSCompositeSourceOver );
	[[[NSColor blackColor] colorWithAlphaComponent:0.7] set];
	[aPath stroke];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
	if ( [selectedRows containsIndex:draggedRow] && ([selectedRows count] > 1) ) {
		NSRect totalRect = [[outlineview enclosingScrollView] documentVisibleRect];
		while ( thisIndex != NSNotFound ) {
			NSRect thisRect = [outlineview frameOfCellAtColumn:0 row:thisIndex];
			NSCell *aCell = [[[myColumn dataCellForRow:thisIndex] copy] autorelease];
			float indentLevel = ([outlineview indentationPerLevel] * [outlineview levelForRow:thisIndex]);
			float heightDiff = 0. - NSMinY(totalRect);

			anItem = [outlineview itemAtRow:thisIndex];
			[aCell setObjectValue:[[outlineview dataSource] outlineView:outlineview objectValueForTableColumn:myColumn byItem:anItem]];
			
			/* There's probably a better way to lay these out, but this is pretty close.
			   I actually spent about 12 hours on just this.  Getting the drag image working.
			   I wish there was an easy way to flip the coordinates... well, since I cut the
			   drag image to be the size of the outline view AND explicitly set its X and Y
			   coordinates to 0, I'm pretty much stuck doing it this way.
			   
			   Oh, and you probably shouldn't be using cells like this.
			*/
			if ( NSIntersectsRect( thisRect, totalRect ) ) {
				thisRect.origin.x = 0.;
				thisRect.origin.x += indentLevel;
				thisRect.origin.y = fabs( ((thisRect.origin.y - 1) + heightDiff) - NSHeight(imageRect) ) - NSHeight( thisRect );
				if ( (NSMinY(thisRect) <= (NSMinY(imageRect) - (NSHeight(thisRect) / 2))) || (NSMaxY(thisRect) >= (NSMaxY(imageRect) + (NSHeight(thisRect) / 2))) ) {
					thisIndex = [selectedRows indexGreaterThanIndex:thisIndex];
					continue;
				}
				[aCell drawWithFrame:thisRect inView:[[outlineview window] contentView]];
			}
			thisIndex = [selectedRows indexGreaterThanIndex:thisIndex];
		}
	} else {
		NSCell *aCell = [[[myColumn dataCellForRow:draggedRow] copy] autorelease];
		anItem = [outlineview itemAtRow:draggedRow];
		[aCell setObjectValue:[[outlineview dataSource] outlineView:outlineview objectValueForTableColumn:myColumn byItem:anItem]];
		[aCell drawWithFrame:imageRect inView:[[outlineview window] contentView]];
	}
	[theImage unlockFocus];
	
	return [theImage autorelease];
}

#pragma mark -
#pragma mark  View Change Methods
#pragma mark -

- (void)changeCurrentView:(NSView *)newView{
	
	// If the view is not null
	if(newView){
	
		// Remove any subview that is present
		//[self removeSubview];
	
		// Add the view as a subview to the current view
		[currentViewPlaceholder addSubview:newView];
		
		// Apply the changes immediately
		[currentViewPlaceholder displayIfNeeded];
		
		// Get the bounds of the current view
		NSRect newBounds;
		newBounds.origin.x = 0;
		newBounds.origin.y = 0;
		newBounds.size.width = [[newView superview] frame].size.width;
		newBounds.size.height = [[newView superview] frame].size.height;
		
		// Apply the bounds to the new view
		[newView setFrame:[[newView superview] frame]];
		
		// Make sure our added subview is placed and resizes correctly
		[newView setFrameOrigin:NSMakePoint(0,0)];
		[newView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
}

- (void)removeSubview{
	// empty selection
	NSArray *subViews = [currentViewPlaceholder subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[currentViewPlaceholder displayIfNeeded];	// we want the removed views to disappear right away
}

#pragma mark -
#pragma mark  Outlineview Datasource Methods
#pragma mark -

// Return the child of the item at the index
- (id)outlineView:(NSOutlineView *)outlineview child:(int)index ofItem:(id)item{
	
	// NOTE: ? is the ternary operator. It is equivelant to if(){ } else{ }
	// DISCUSSION: http://en.wikipedia.org/wiki/Ternary_operation
	
	// If the item is not null return the objectAtIndex of item
	// Else if item is null return the objectAtIndex of tuners
	
	// Print debug info
	NSLog(@"index = %i item = %@", index, item);

	return [(item ? item : tuners) objectAtIndex:index];
}

// Return YES if the item is expandable
- (BOOL)outlineView:(NSOutlineView *)outlineview isItemExpandable:(id)item{

	// The only expandable items are the Tuners. They will have a drop down of all tuneable channels
	//return [(item ? item : tuners) isKindOfClass:[GBTuner class]];
	return NO;
}

// Return the number of children of the item
- (int)outlineView:(NSOutlineView *)outlineview numberOfChildrenOfItem:(id)item{
	
	// Int to hold the result
	int result = [tuners count];
	
	// If item is not null
	if(item){
	
		// Set the result to the number of channels of the item
		//result = [item numberOfChannels];
		result = 0;
	}
	
	// Print debugging info
	NSLog(@"item = %@ result = %i", item, result);
	
	return result;
}

// The value for the table column
- (id)outlineView:(NSOutlineView *)outlineview objectValueForTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{

	//NSLog(@"item = %@", item);
	
	// Assign the tuner to item
	GBTuner *theItem = item;
	
	if(theItem){
	
		// The font to use for the title
		NSFont *title_font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];
	
		// Attributes to use
		NSDictionary *title_attributes = [NSDictionary dictionaryWithObjectsAndKeys:title_font, NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		
		// The title string
		NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:[theItem title] attributes:title_attributes] autorelease];
		
		// The font to use for the caption
		NSFont *caption_font = [NSFont fontWithName:CAPTION_FONT size:CAPTION_HEIGHT];
		
		// Attributes to use
		NSDictionary *caption_attributes = [NSDictionary dictionaryWithObjectsAndKeys:caption_font, NSFontAttributeName, [NSColor grayColor], NSForegroundColorAttributeName, nil];
		
		// The caption string below the title
		NSAttributedString *caption = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%s", [[theItem caption] UTF8String]] attributes:caption_attributes] autorelease];
		
		// Append the two attributed strings
		[string appendAttributedString:caption];
		
		// The image
		NSImage *image = [[[NSImage alloc] initWithData:[[NSApp applicationIconImage] TIFFRepresentation]] autorelease];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize( row_height, row_height )];
		
		return [NSDictionary dictionaryWithObjectsAndKeys:image, @"Image", string, @"String", nil];

	}
	
	return item;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tc byItem:(id)item
{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
}

#pragma mark -
#pragma mark  Dealloc Methods
#pragma mark -

- (void)dealloc{
	
	[tuners release];
	
	[super dealloc];
}
@end
