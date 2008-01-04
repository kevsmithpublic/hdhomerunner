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
//  GBWindowController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBWindowController.h"

// Default folder titles
#define DEVICES_NAME			@"DEVICES"
#define CHANNELS_NAME			@"CHANNELS"
#define GROUPS_NAME				@"GROUPS"

#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs

#define COLUMNID_NAME			@"nameColumn"	// the single column name in our outline view

#define CHANNEL_NIB_NAME		@"ChannelView"	// nib name for the channel view
#define TUNER_NIB_NAME			@"TunerView"		// nib name for the file view
#define CHILDEDIT_NAME			@"ChildEdit"	// nib name for the child edit window controller

#define FONT_HEIGHT				11.0
#define ROW_HEIGHT				18.0

@implementation GBWindowController

- (id)initWithWindow:(NSWindow *)window{
	if(self = [super initWithWindow:window]){
	
		// Contents of the source list
		contents = [[NSMutableArray alloc] init];
	
		// Add the objects to the contents
		tunerController = [[GBTunerController alloc] initWithWindowNibName:TUNER_NIB_NAME];
		channelController = [[GBChannelController alloc] initWithWindowNibName:CHANNEL_NIB_NAME];
			
		[contents addObject:tunerController];
		[contents addObject:channelController];
		
		// Ensure that the nibs are loaded
		[[contents objectAtIndex:0] window];
		[[contents objectAtIndex:1] window];
		
		// Mutable dictionary of the toolbar items
		toolbarItems = [[NSMutableDictionary alloc] initWithCapacity:0];
		
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

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"MainWindow"];
	
	// This will center the main window if there's no stored position for it.
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil){
		[[self window] center];
	}

	// Set the splitters' autosave names.
	[splitView setPositionAutosaveName:@"SourceSplitter"];
	[splitView setPositionAutosaveName:@"ListSplitter"];

	// Place the source list view in the left panel.
	[sourceView setFrameSize:[sourceViewPlaceholder frame].size];
	[sourceViewPlaceholder addSubview:sourceView];

	// Place the content view in the right panel.
	[contentView setFrameSize:[contentViewPlaceholder frame].size];
	[contentViewPlaceholder addSubview:contentView];
	
	// Set up the toolbar on the main window
	//NSToolbar *toolbar;
	theToolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[theToolbar setDelegate:self];
    
	// Make the toolbar configurable
	[theToolbar setAllowsUserCustomization:YES];
	[theToolbar setAutosavesConfiguration:YES];
    
	// Attach the toolbar to the window
	[[self window] setToolbar:theToolbar];
	
	// Configure the outline view
	//[GBOutlineView setRoundedSelections:YES];
	[GBOutlineView setRowHeight:(ROW_HEIGHT)];
	//[GBOutlineView setIndentationPerLevel:32.0];
	//[GBOutlineView setRowHeight:18.0];
    //[GBOutlineView setIntercellSpacing:NSMakeSize(0.0, 0.0)];

	//[self setCurrentView:[channelController viewForChild:nil]];
	
	// Register for notifications
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector: @selector(applicationWillFinishLaunching:) name:NSApplicationWillFinishLaunchingNotification object:nil];
	[nc addObserver:self selector: @selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
}

// The application will finish launching. Load contents from disk
-(void)applicationWillFinishLaunching:(NSNotification *)notification{
	
	// If the user was using a previous version of hdhomerunner we need to upgrade their preferences
	if([self resetUserDefaultsRequired]){
	
		// Reset the user defaults
		[self resetUserDefaults];
	}
	
	// Load the user defaults
	[self loadUserDefaults];
}

#pragma mark -
#pragma mark  User Defaults
#pragma mark -

- (void)loadUserDefaults{

	// The keys to load from disk
	NSArray	*keys = [NSArray arrayWithObjects:	DEVICES_NAME,
												CHANNELS_NAME,
												GROUPS_NAME,
												nil];
	
	// Key enumerator
	NSEnumerator *key_enumerator = [keys objectEnumerator];
	
	// A key in the enumerator
	NSString *key;
	
	// Loop over the keys
	while(key = [key_enumerator nextObject]){
	
		//NSLog(@"class = %@", [[[NSUserDefaults standardUserDefaults] objectForKey:key] class]);
		NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		
		if([key isEqualToString:DEVICES_NAME]){
			
			// Configure the first object with the Devices from disk
			// I am using this method as opposed to creating a new object because the
			// Controller is already initialized with the proper window NIB.
			// initWithDictionary does not handle the windowNibName
			[[contents objectAtIndex:0] configureWithDictionary:dict];
			
		} else if([key isEqualToString:CHANNELS_NAME]){
			
			// Configure the first object with the Devices from disk
			// I am using this method as opposed to creating a new object because the
			// Controller is already initialized with the proper window NIB.
			// initWithDictionary does not handle the windowNibName
			[[contents objectAtIndex:1] configureWithDictionary:dict];
			
		} else if([key isEqualToString:GROUPS_NAME]){
		
		}
	}
}

// Reset the user defaults
- (void)resetUserDefaults{

	// Run the alert sheet notifying the user
	NSBeginAlertSheet(@"Preference Reset Required", @"OK", @"Cancel",
		nil, [self window], self, NULL,
		@selector(endAlertSheet:returnCode:contextInfo:),
		NULL,
		@"A previous version of hdhomerunner preferences have been detected. In order to maintain forward compatibilty these preferences need to be deleted and all existing preferences will be lost. Is this okay?");
}

- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the user agreed to reset the preferences
	if (returnCode == NSAlertDefaultReturn) {
		NSLog(@"Clicked OK");
		// Perform the reset
		[NSUserDefaults resetStandardUserDefaults];
		
		// The standard user defaults used to write preferences to disk
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		
		// Write the changes to disk
		[standardUserDefaults synchronize];
	}
	else if (returnCode == NSAlertAlternateReturn) {
	
		// Don't do anything. The user cancelled the action
		NSLog(@"Clicked Cancel");
	}
}


// Check whether the user is upgrading from a previous version and is required to be compatible with the latest version
- (BOOL)resetUserDefaultsRequired{
	
	// Assume the defaults don't need to be reset
	BOOL result = NO;
	
	// If the tuners key is in the defaults then we are using hdhomerunner version 0.5x - 0.7x
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"tuners"]){
		result = YES;
		
		//NSLog(@"defaults = %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
	}
	
	return result;
}

#pragma mark - Accessor methods

// Get the contents
- (NSMutableArray *)contents{
	return contents;
}

// Set the contents
- (void)setContents:(NSArray *)newContents{
// If the new contents is not the same as the existing children
	if(![[self contents] isEqualToArray:newContents]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"contents"];
		[contents setArray:newContents];
		[self didChangeValueForKey:@"contents"];
	}
}

#pragma mark - Toolbar Delegate methods

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

#pragma mark - Toolbar actions

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
#pragma mark  NSOutlineView datasource methods
#pragma mark -

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item{
	//NSLog(@"outlineView: child:%i ofItem:%@", index, item);

	// If the parent (item) is not nil then return the children of the parent at the specified index
	if(item){
		return [[item children] objectAtIndex:index];
		
	} else {
		// Else return the parent at the specified index
		return [contents objectAtIndex:index];
	}
	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
	//NSLog(@"outlineView: isItemExpandable:%@", [item class]);
	
	BOOL result = NO;
	
	// If the item is not null
	if(item){
	
		result = [item isExpandable];
	}
	
	
	return result;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
	//NSLog(@"outlineView: numberOfChildrenofItem:%@", item);
	
	// Default number of Children is the number of items in the content object
	int result = [contents count];
	
	// If the item is not null and therefore not the content object
	if(item){
	
		// Set result to be the number of children that the specified parent has
		result = [item numberOfChildren];
	}
	
	return result;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
	//NSLog(@"outlineView: objectValueForTableColumn:%i byItem:%@", [tableColumn identifier], item);

	// The object to return
	id result;
	
	// If the column requesting data is the name column
	if([[tableColumn identifier] isEqualToString:COLUMNID_NAME]){
		
		// Attributes dictionary
		NSDictionary *attributes;
		
		// If the item is in the main list
		if([contents containsObject:item]){
		
			// Set the font to bold
			attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Lucida Grande Bold" size:FONT_HEIGHT], NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		} else {
		
			// Else if the item is a child set it to non bold
			attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Lucida Grande" size:FONT_HEIGHT], NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		}
		
	
		// Set the NSAttributedString to return
		result = [[[NSAttributedString alloc] initWithString:[item title] attributes:attributes] autorelease];
	
	} else {
		
		// Else we should return the icon of the item
		result =  [[item icon] copy];
	}
		
	/*// The object to return
	id result;
	
	// If the column requesting data is the name column
	//if([[tableColumn identifier] isEqualToString:COLUMNID_NAME]){
	if (![contents containsObject:item]) {
		NSLog(@"title = %@", [item title]);
		
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Chicago" size:FONT_HEIGHT], NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
	
		NSAttributedString *string = [[[NSAttributedString alloc] initWithString:[item title] attributes:attributes] autorelease];
		NSImage *image = [[[NSImage alloc] initWithData:[[item icon] TIFFRepresentation]] autorelease];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize( ROW_HEIGHT, ROW_HEIGHT )];
		
		//result = [NSDictionary dictionaryWithObjectsAndKeys:image, @"Image", string, @"String", nil];
		result = [item title];
	} else {
		
		// Else we should return the icon of the item
		//result =  [[item icon] copy];
		result = [item title];
	}*/
	
	return result;
}

// Make the edits to the item
- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
	NSLog(@"set object value");
}

#pragma mark -
#pragma mark  NSOutlineView delegate methods
#pragma mark -

// Should the outlineview select the item?
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
	// Don't allow the main parents displayed be selected
	//return (![contents containsObject:item]);
	return (![item isExpandable]);
}

// Decide whether to allow the selection to change 
- (BOOL)selectionShouldChangeInOutlineView:(NSOutlineView *)outlineView{
	
	// Assume that the user entered a null value
	BOOL result = YES;
	
	//NSLog(@"selectionShouldChange");
	
	/*if ([[fieldEditor string] length] == 0)
	{
		// don't allow empty names
		return NO;
	}
	else
	{
		return YES;
	}*/
	
	return result;
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item{
	// Don't allow the main parents displayed to be edited or the imagecell
	return !([contents containsObject:item]);
}


// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item{	 
	/*if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are displaying the single and only column
		if ([cell isKindOfClass:[ImageAndTextCell class]])
		{
			item = [item representedObject];
			if (item)
			{
				if ([item isLeaf])
				{
					// does it have a URL string?
					NSString *urlStr = [item urlString];
					if (urlStr)
					{
						if ([item isLeaf])
						{
							NSImage *iconImage;
							if ([[item urlString] hasPrefix:HTTP_PREFIX])
								iconImage = urlImage;
							else
								iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
						else
						{
							NSImage* iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
					}
					else
					{
						// it's a separator, don't bother with the icon
					}
				}
				else
				{
					// check if it's a special folder (DEVICES or PLACES), we don't want it to have an icon
					if ([self isSpecialGroup:item])
					{
						[item setNodeIcon:nil];
					}
					else
					{
						// it's a folder, use the folderImage as its icon
						[item setNodeIcon:folderImage];
					}
				}
			}
			
			// set the cell's image
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}*/
}

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
/*- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}*/

- (void)changeCurrentView:(NSView *)newView{
	
	// If the view is not null
	if(newView){
	
		// Remove any subview that is present
		//[self removeSubview];
	
		// Add the view as a subview to the current view
		[currentView addSubview:newView];
		
		// Apply the changes immediately
		[currentView displayIfNeeded];
		
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
	NSArray *subViews = [currentView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[currentView displayIfNeeded];	// we want the removed views to disappear right away
}

// -------------------------------------------------------------------------------
//	changeItemView:
// ------------------------------------------------------------------------------
/*- (void)changeItemView
{
	NSArray		*selection = [treeController selectedObjects];	
	BaseNode	*node = [selection objectAtIndex:0];
	NSString	*urlStr = [node urlString];
	
	if (urlStr)
	{
		NSURL *targetURL = [NSURL fileURLWithPath:urlStr];
		
		if ([urlStr hasPrefix:HTTP_PREFIX])
		{
			// the url is a web-based url
			if (currentView != webView)
			{
				// change to web view
				[self removeSubview];
				currentView = nil;
				[placeHolderView addSubview:webView];
				currentView = webView;
			}
			
			// this will tell our WebUIDelegate not to retarget first responder since some web pages force
			// forus to their text fields - we want to keep our outline view in focus.
			retargetWebView = YES;	
			
			[webView setMainFrameURL:nil];		// reset the webview to an empty frame
			[webView setMainFrameURL:urlStr];	// re-target to the new url
		}
		else
		{
			// the url is file-system based (folder or file)
			if (currentView != [fileViewController view] || currentView != [iconViewController view])
			{
				// add a spinning progress gear in case populating the icon view takes too long
				NSRect bounds = [placeHolderView bounds];
				CGFloat x = (bounds.size.width-32)/2;
				CGFloat y = (bounds.size.height-32)/2;
				NSProgressIndicator* busyGear = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(x, y, 32, 32)];
				[busyGear setStyle:NSProgressIndicatorSpinningStyle];
				[busyGear startAnimation:self];
				[placeHolderView addSubview:busyGear];
				[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away

				// detect if the url is a directory
				Boolean isDirectory;
				FSRef ref;
				FSPathMakeRef((const UInt8 *)[urlStr fileSystemRepresentation], &ref, &isDirectory);
				
				if (isDirectory)
				{
					// avoid a flicker effect by not removing the icon view if it is already embedded
					if (!(currentView == [iconViewController view]))
					{
						// remove the old subview
						[self removeSubview];
						currentView = nil;
					}
					
					// change to icon view to display folder contents
					[placeHolderView addSubview:[iconViewController view]];
					currentView = [iconViewController view];
					
					// its a directory - show its contents using NSCollectionView
					iconViewController.url = targetURL;
				}
				else
				{
					// its a file, just show the item info

					// remove the old subview
					[self removeSubview];
					currentView = nil;
				
					// change to file view
					[placeHolderView addSubview:[fileViewController view]];
					currentView = [fileViewController view];
					
					// update the file's info
					fileViewController.url = targetURL;
				}
				
				[busyGear removeFromSuperview];
			}
		}
		
		NSRect newBounds;
		newBounds.origin.x = 0;
		newBounds.origin.y = 0;
		newBounds.size.width = [[currentView superview] frame].size.width;
		newBounds.size.height = [[currentView superview] frame].size.height;
		[currentView setFrame:[[currentView superview] frame]];
		
		// make sure our added subview is placed and resizes correctly
		[currentView setFrameOrigin:NSMakePoint(0,0)];
		[currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
	else
	{
		// there's no url associated with this node
		// so a container was selected - no view to display
		[self removeSubview];
		currentView = nil;
	}
}*/

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
	NSLog(@"selection did change notification %@", [[GBOutlineView itemAtRow:[GBOutlineView selectedRow]] class]);

	id selectedObject = [GBOutlineView itemAtRow:[GBOutlineView selectedRow]];
	
	//[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[selectedObject url]]];
	
	// We are going to loop over the contents and find out who the selected item belongs to
	NSEnumerator *enumerator = [contents objectEnumerator];
	
	// The parent in contents
	id parent;
	
	while(parent = [enumerator nextObject]){
		
		// If the selected item is in children
		if([[parent children] containsObject:selectedObject]){
			
			// We assume that we found the view somewhere,
			// that the selected object is unique to all parents,
			// and that all children do not have children themselves
			// else we may never find the selected object if it is a nested child.
			[self changeCurrentView:[parent viewForChild:selectedObject]];
		}
	}
	
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

#pragma mark -
#pragma mark  Import/Export Channels
#pragma mark -

// Take action based on importing channel menuitem being selected
-(IBAction)importChannels:(id)sender{
	// The panel to open
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	// The array of file types to filter 
	NSArray *fileTypes;

	// Only allow single files to be selected
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:NO];
	
	// If the sender is importhdhrcontrol
	if(sender == importhdhrcontrol){

		// Only allow single files to be selected
		[openPanel setAllowsMultipleSelection:NO];
		[openPanel setCanChooseDirectories:NO];
	
		// Set the file types to filter on to only plist
		fileTypes = [NSArray arrayWithObjects:@"plist", nil];
		
		// Set the title of the panel
		[openPanel setTitle:@"Import HDHRControl Channel File"];
	}
	
	// Open the panel
	[openPanel beginSheetForDirectory:nil
                           file:nil
                          types:fileTypes
                 modalForWindow:[self window]
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:sender];
	

}

-(IBAction)exportChannels:(id)sender{

	NSSavePanel *savePanel = [NSSavePanel savePanel];
	
	// Allow the user to create directories
	[savePanel setCanCreateDirectories:YES];

	// If the sender is to exporthdhrcontrol file
	if(sender == exporthdhrcontrol){
	
		// Set the file type of the file being saved
		[savePanel setRequiredFileType:@"plist"];
		
		// Set the title of the panel
		[savePanel setTitle:@"Export HDHRControl Channel File"];
	}
	
	// Open the panel
	[savePanel beginSheetForDirectory:nil
                           file:nil
                 modalForWindow:[self window]
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:sender];
}

-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the OK button was selected (as opposed to Cancel)
	if(returnCode == NSOKButton){
		
		// If the sender was importhdhrcontrol
		if(contextInfo = importhdhrcontrol){
			
			// Init an array of objects from the specified file
			NSArray *anArray = [NSArray arrayWithContentsOfFile:[panel filename]];
			
			// Enumerator of the channels to import
			NSEnumerator *newchannel_enumerator = [anArray objectEnumerator];
			
			// Object to use during iteration
			NSDictionary *new_channel;
			
			// Loop over all imported channels
			while ((new_channel = [newchannel_enumerator nextObject])) {
				
				// All of the values in the new_object dictionary
				NSArray *values =	[NSArray arrayWithObjects:[new_channel objectForKey:@"Description"], 
									[new_channel objectForKey:@"Channel"],
									[new_channel objectForKey:@"Program"], nil];
				
				// The keys for new_object dictionary
				NSArray *keys = [NSArray arrayWithObjects:	@"description",
															@"number",
															@"program", nil];
				
				// A new dictionary based on the translation from HDHRControl keys to hdhomerunner keys																						
				NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
				
				// Create a channel with the dictionary
				GBChannel *tmp = [[GBChannel alloc] initWithDictionary:dict];
				
				// Add the channel to the GBChannelController as a child
				[channelController addChildToParent:tmp];
				
				// Reload the data in the OutlineView
				[GBOutlineView reloadData];
			}
		} else if(contextInfo = exporthdhrcontrol){
			// If the sender was exporthdhrcontrol
			
		}
	}
}

#pragma mark -
#pragma mark  Autoscan Channels
#pragma mark -

- (IBAction)autoscanChannels:(id)sender{

	// Open the sheet
	[NSApp beginSheet:_autoscanSheet modalForWindow:[self window]
        modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];

	// Build our channels on a separate thread,
	// This is an expensive process and should not tie up the GUI
	/*[NSThread detachNewThreadSelector:	@selector(autoscan:)	// method to detach in a new thread
										toTarget:self						// we are the target
										withObject:nil];*/
}

// Handle the event where the sheet should be closed
- (IBAction)closeSheet:(id)sender{
	[NSApp endSheet:_autoscanSheet];
}

// Clean up the sheet based on the OK or Cancel buttons being selected
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// Close the sheet
	[_autoscanSheet orderOut:self];
}

// Autoscan the tuners for any channels
- (void)autoscan:(id)inObject{
	
	// Do this in a seperate thread to prevent the GUI from blocking
	// Initialize an autorelease pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	/*buildingOutlineView = YES;		// indicate to ourselves we are building the default tree at startup
		
	[myOutlineView setHidden:YES];	// hide the outline view - don't show it as we are building the contents
	
	[self addDevicesSection];		// add the "Devices" outline section
	[self addPlacesSection];		// add the "Places" outline section
	[self populateOutline];			// add the disk-based outline content
	
	buildingOutlineView = NO;		// we're done building our default tree
	
	// remove the current selection
	NSArray *selection = [treeController selectionIndexPaths];
	[treeController removeSelectionIndexPaths:selection];
	
	[myOutlineView setHidden:NO];*/	// we are done populating the outline view content, show it again
	

	
	[pool release];
}

#pragma mark -
#pragma mark  Cleanup
#pragma mark -

// The application will terminate. Save contents to disk
-(void)applicationWillTerminate:(NSNotification *)notification{
	
	// The standard user defaults used to write preferences to disk
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	// Temporary array to hold objects that will be written to disk
	//NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
	
	// Enumerator to loop over
	NSEnumerator *enumerator = [contents objectEnumerator];
	
	// Object in the enumerator
	id object;
	
	// Loop over contents
	while(object = [enumerator nextObject]){
	
		// Add the dictionary representation of the object to the user defaults and use the object's title
		// (which is how it appears in the outlineview) for the key
		[standardUserDefaults setObject:[object dictionaryRepresentation] forKey:[object title]];
	}
	
	// Write the changes to disk
	[standardUserDefaults synchronize];
}

// Cleanup after ourselves
- (void)dealloc{
	[contents release];
	[toolbar release];
	
	[super dealloc];
}


@end
