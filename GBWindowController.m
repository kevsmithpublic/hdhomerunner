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
//  Created by Gregory Barchard on 1/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBWindowController.h"

#define	SCAN_ALL_CHANNELS				@"Scan All Channels"
#define SCAN_CABLE_CHANNELS				@"Scan Cable Channels Only"
#define SCAN_BCAST_CHANNELS				@"Scan Broadcast Channels Only"

// GUI Definitions
#define CHANNEL_FONT_HEIGHT				10.0
#define CHANNEL_FONT					@"Lucida Grande"

@implementation GBWindowController

- (id)initWithWindow:(NSWindow *)window{
	
	if(self = [super initWithWindow:window]){
	
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
		[_play setAction:@selector(play:)];
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
		
		// Initialize the toolbaritem
		NSToolbarItem *_fullscreen = [[NSToolbarItem alloc] initWithItemIdentifier:@"Fullscreen"];
		[_fullscreen setAction:@selector(fullscreen:)];
		[_fullscreen setTarget:self];
		[_fullscreen setPaletteLabel:@"Full Screen"];
		[_fullscreen setLabel:@"Full Screen"];
		[_fullscreen setToolTip:@"Set VLC to launch in full screen mode"];
		//[_fullscreen setImage:[NSImage imageNamed:@"General Preferences"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_fullscreen forKey:@"Fullscreen"];
		
		// Release the toolbar item
		[_fullscreen release];
		
		// vlc handles VLC controls
		NSString *path = [[NSBundle mainBundle] pathForResource:@"launchVLC" ofType:@"scpt"];
		vlc = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
	
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"Window"];
	
	// This will center the main window if there's no stored position for it.
	// The frame name (set up in IB) to MainWindow
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil){
		
		// Center the window
		[[self window] center];
	}
	
	// Set the splitView's autosave name.
	[splitView setPositionAutosaveName:@"MainWindowSplitView"];
	
	// Set the splitview to remember it's position
	[tunerSplitView setPositionAutosaveName:@"tunerSplitView"];
	
	// Set the source list view into the main window
	[sourceListView setFrameSize:[sourceListViewPlaceholder frame].size];
	[sourceListViewPlaceholder addSubview:sourceListView];
	
	// Set up the channel scan selection
	[_channelscan_mode removeAllItems];
	[_channelscan_mode addItemsWithTitles:[NSArray arrayWithObjects:SCAN_ALL_CHANNELS, 
																	SCAN_BCAST_CHANNELS,
																	SCAN_CABLE_CHANNELS, nil]];
																	
	// Set up the toolbar on the main window
	theToolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[theToolbar setDelegate:self];
    
	// Make the toolbar configurable
	[theToolbar setAllowsUserCustomization:YES];
	[theToolbar setAutosavesConfiguration:YES];
	
	// Attach the toolbar to the window
	[[self window] setToolbar:theToolbar];
	
	// Add ourselves as an observer of the GBChannelAdded notification.
	// If the notification is posted by the currently represented tuner then
	// update the view
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter							addObserver: self
												selector: @selector(channelsChanged:)
													name: @"GBTunerChannelAdded" 
												  object: nil];	
	
	[notificationCenter							addObserver: self
												selector: @selector(outlineViewSelectionDidChange:)
													name: @"NSOutlineViewSelectionDidChangeNotification" 
												  object: channelListOutlineView];
	
	[self changeCurrentView:_view];
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

- (NSView *)view{
	return _view;
}

//- (void)updateView{
- (void)updateWebView:(GBChannel *)aChannel{
		
	// Get the URL for the channel
	NSURL *aURL = [aChannel url];
	
	// Print debug info
	// NOTE:
	// For webview to properly load the URL it must begin with http://
	// http://somesite.com is OK, but somesite.com is NOT
	//NSLog(@"GBWindowController updating web view to url = %@", [aURL absoluteString]);
	
	// If the url is null then set the url to the a default 
	if(aURL == nil){
		
		// Get the path for the default.html resource
		NSString *path = [NSBundle pathForResource:@"default" ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
		
		// Set aURL to the default url
		aURL = nil;
		aURL = [NSURL URLWithString:path];
		
	}

	// Set the webview to load the appropriate URL
	[[_web mainFrame] loadRequest:[NSURLRequest requestWithURL:aURL]]; 
	
}


- (void)reloadAllChannelData{	

	// Then update the table
	[channelListOutlineView reloadData];
}

// Reload the table data for the object posting the notification
- (void)reloadChannelData:(GBChannel *)aChannel{
	
	// Print debug info
	//NSLog(@"GBWindowController reloading data for channel %@",aChannel);
	
	// Get the row of the item that posted the notification
	int row = [channelListOutlineView rowForItem:aChannel];
	
	// Make sure the row is greater than -1
	if(row > -1){
		
		// Tell the outline view to update only the row that posted the notification
		// This is more efficient than calling reloadData since we are only updating the single
		// cell rather than the entire table.
		[channelListOutlineView setNeedsDisplayInRect:[channelListOutlineView rectOfRow:row]];
	} else {
		
		// The channel wasn't found in the table so refresh the entire table
		[self reloadAllChannelData];
	}
}

- (void)changeContentView:(NSView *)newView{
	
	// If the view is not null
	if(newView){
	
		// Remove any subview that is present
		//[self removeSubview];
	
		// Add the view as a subview to the current view
		[contentViewPlaceHolder addSubview:newView];
		
		// Apply the changes immediately
		[contentViewPlaceHolder displayIfNeeded];
		
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

- (void)channelsChanged:(NSNotification *)notification{
	
	// Print debug info
	//NSLog(@"GBWindowController notification received from object = %@", [notification object]);
	
	
	// If the tuner posting the notification is the same as the tuner we represent
	if([tuner isEqual:[notification object]]){
		
		// Print debug info
		//NSLog(@"GBWindowController updating table");
		
		// Then update the table
		[channelListOutlineView reloadData];
	}
}

// Taken from URLFormatter.h
/* given a string that may be a http URL, try to massage it into an RFC-compliant http URL string */
- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString
{	
	NSArray* stringParts = [urlString componentsSeparatedByString:@"/"];
	NSString* host = [stringParts objectAtIndex:0];
	
	// Added 01/05/07 by GB
	// Fix host if the string is already completely HTTP complete
	if([host isEqualToString:@"http:"]){
		host = [stringParts objectAtIndex:2];
	}
    
	if ([host rangeOfString:@"."].location == NSNotFound)
	{ 
		host = [NSString stringWithFormat:@"www.%@.com", host];
		urlString = [host stringByAppendingString:@"/"];
		
		NSArray* pathStrings = [stringParts subarrayWithRange:NSMakeRange(1, [stringParts count] - 1)];
		NSString* filePath = @"";
		if ([pathStrings count])
			filePath = [pathStrings componentsJoinedByString:@"/"];

		urlString = [urlString stringByAppendingString:filePath];
	}
	
	// see if the newly reconstructed string is a well formed URL

	// Added 01/05/07 by GB
	// Only append the HTTP if it isn't already there
	if([urlString rangeOfString:@"http://"].location == NSNotFound){
	
		urlString = [@"http://" stringByAppendingString:urlString];
	}

	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	return [[NSURL URLWithString:urlString] absoluteString];
}

- (void)setTuner:(GBTuner *)aTuner{
	
	// If the new tuner is not equal to the existing tuner
	if(![tuner isEqual:aTuner]){
		
		// Notify we are about to change
		[self willChangeValueForKey:@"tuner"];
		
		// Set the new tuner to aTuner
		[tuner autorelease];
		tuner = nil;
		tuner = [aTuner retain];
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"tuner"];
		
		// Update the view
		[self reloadAllChannelData];
	}
	
	// Print debug info
	//NSLog(@"GBWindowController tuner = %@", tuner);
}

- (GBTuner *)tuner{
	
	return tuner;
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

	// create the first (and in this case only) parameter
	// note we can't pass an NSString (or any other object
	// for that matter) to AppleScript directly,
	// must convert to NSAppleEventDescriptor first
	NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithBoolean:NO];
	
	// create and populate the list of parameters
	// note that the array starts at index 1
	NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
	[parameters insertDescriptor:firstParameter atIndex:1];
	
	// create the AppleEvent target
	ProcessSerialNumber psn = { 0, kCurrentProcess };
	NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
															  bytes:&psn
															  length:sizeof(ProcessSerialNumber)];
	// create an NSAppleEventDescriptor with the method name
	// note that the name must be lowercase (even if it is uppercase in AppleScript)
	NSAppleEventDescriptor *handler = [NSAppleEventDescriptor descriptorWithString:[@"launchvlc" lowercaseString]];
	
	// last but not least, create the event for an AppleScript subroutine
	// set the method name and the list of parameters
	NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
															 eventID:kASSubroutineEvent
															 targetDescriptor:target
															 returnID:kAutoGenerateReturnID
															 transactionID:kAnyTransactionID];
	[event setParamDescriptor:handler forKeyword:keyASSubroutineName];
	[event setParamDescriptor:parameters forKeyword:keyDirectObject];
	NSDictionary *errors = [NSDictionary dictionary];
	
	// at last, call the event in AppleScript
	if(![vlc executeAppleEvent:event error:&errors]){
		NSLog(@"errored %@", [errors description]);
	}
	
	// Tell the selected tuner to play
	[tuner play];
}

// Set VLC to launch in full screen mode
- (IBAction)fullscreen:(id)sender{
	NSLog(@"fullscreen toolbar item selected");
	
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
															@"channelNumber",
															@"program", nil];
				
				// A new dictionary based on the translation from HDHRControl keys to hdhomerunner keys																						
				NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
				
				// Create a channel with the dictionary
				GBChannel *tmp = [[GBChannel alloc] initWithDictionary:dict];
				
				// Add the channel to the GBChannelController as a child
				[tuner addChannel:tmp];
				
				// Reload the data in the OutlineView
				[self reloadChannelData:tmp];
			}
		} else if(contextInfo = exporthdhrcontrol){
			// If the sender was exporthdhrcontrol
			
			// The channels to export
			NSArray *channels = [tuner channels];
			
			// The enumerator to loop over
			NSEnumerator *enumerator = [channels objectEnumerator];
			
			// Temporary array to hold translated channels in
			NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
			
			// A single object in the array
			GBChannel *object;
 
			while ((object = [enumerator nextObject])) {
			
				// The dictionary to translate GBChannel terms to HHDHRControl keys
				NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:	[object channelNumber], @"Channel",
																						[object description], @"Description",
																						[object program], @"Program", nil];
				
				// Add the dictionary to the array
				[array addObject:dictionary];
			}
			
			// Write the array to disc
			[array writeToFile:[panel filename] atomically:YES];
		}
	}
}

#pragma mark -
#pragma mark  Outlineview Datasource Methods
#pragma mark -

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
	
	// Print debug info
	//NSLog(@"GBWindowController selection did change");
	
	// If the selected item is a channel, the view should show the channel's website
	if([[channelListOutlineView itemAtRow:[channelListOutlineView selectedRow]] isKindOfClass:[GBChannel class]]){
	
		GBChannel *aChannel = [channelListOutlineView itemAtRow:[channelListOutlineView selectedRow]];
		
		// Set the webview to load the page before adding it as a subview
		[self updateWebView:aChannel];
		
		// Set the tuner's channel number
		[tuner setGBChannel:aChannel];
	
		// Set the webview to the content view and resize it
		[self changeContentView:_web];
	}
}

// Return the child of the item at the index
- (id)outlineView:(NSOutlineView *)outlineview child:(int)index ofItem:(id)item{
	
	// NOTE: ? is the ternary operator. It is equivelant to if(){ } else{ }
	// DISCUSSION: http://en.wikipedia.org/wiki/Ternary_operation
	
	// If the item is not null return the objectAtIndex of item
	// Else if item is null return the objectAtIndex of tuners
	
	// Print debug info
	//NSLog(@"GBWindowController index = %i item = %@", index, item);

	return [(item ? item : [tuner channels]) objectAtIndex:index];
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
	int result = [[tuner  numberOfAvailableChannels] intValue];
	
	// If item is not null
	if(item){
	
		// Set the result to the number of channels of the item
		//result = [item numberOfChannels];
		result = 0;
	}
	
	// Print debugging info
	//NSLog(@"GBWindowController item = %@ result = %i", item, result);
	
	return result;
}

// The value for the table column
- (id)outlineView:(NSOutlineView *)outlineview objectValueForTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{

	//NSLog(@"GBWindowController item = %@ identifier = %@", item, [tablecolumn identifier]);
	
	// Assign the tuner to item
	GBChannel *theItem = item;
	
	// Declare the string to return
	NSMutableAttributedString *string;
	
	// The font to use for the title
	NSFont *font = [NSFont fontWithName:CHANNEL_FONT size:CHANNEL_FONT_HEIGHT];

	// Attributes to use
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
	
	if(theItem){
	
		// Vary the results based on the tablecolumn requesting data
		NSString *ident = [tablecolumn identifier];
		
		// Check which column is requesting data
		if([ident isEqualToString:@"description"]){
			
			// Set the string to the channel's description
			//string = [theItem description];
			string = [[[NSMutableAttributedString alloc] initWithString:[theItem description] attributes:attributes] autorelease];
			
		} else if([ident isEqualToString:@"url"]){
		
			// Set the string to the channel's url
			// Get the URL for the channel
			NSURL *aURL = [theItem url];
			
			// If the url is null then set the url to the a default 
			if(aURL == nil){
				
				// Set the attributed string to the blank
				string = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes] autorelease];
				
			} else {
			
				// Set the string to normal
				string = [[[NSMutableAttributedString alloc] initWithString:[aURL absoluteString] attributes:attributes] autorelease];
			}
			
		} else if([ident isEqualToString:@"channel"]){
		
			// Set the string to the channel number
			string = [[[NSMutableAttributedString alloc] initWithString:[[theItem channelNumber] stringValue] attributes:attributes] autorelease];
			
		} else if([ident isEqualToString:@"program"]){
		
			// Set the string to the program number
			string = [[[NSMutableAttributedString alloc] initWithString:[[theItem program] stringValue] attributes:attributes] autorelease];
			
		}
	} else {
	
		// Else the string should be empty
		string = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes] autorelease];

	}
	
	return string;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{	
	// Print debug info
	//NSLog(@"GBWindowController setObjectValue for item = %@ to = %@ of class = %@ in = %@", item, aValue, [aValue class], [tablecolumn identifier]);
	
	// Cast item to GBChannel
	GBChannel *theItem = item;
	NSString *value = [NSString stringWithString:aValue];
	
	// Don't bother trying to edit values if either item or aValue are null
	if(theItem && ![value isEqualToString:@""]){
	
		// Vary the results based on the tablecolumn requesting data
		NSString *ident = [tablecolumn identifier];
		
		// Check which column is requesting data
		if([ident isEqualToString:@"description"]){
			
			// Set the description to the string
			[theItem setDescription:value];
			
		} else if([ident isEqualToString:@"url"]){
		
			// Set the url to the string
			[theItem setURL:[NSURL URLWithString:[self autoCompletedHTTPStringFromString:value]]];
			
			// Make the web view update to reflect the changes
			[self updateWebView:theItem];
			
		} else if([ident isEqualToString:@"channel"]){
		
			// Set the channel number to the string 
			[theItem setChannelNumber:[NSNumber numberWithInt:[value intValue]]];
			
		} else if([ident isEqualToString:@"program"]){
		
			// Set the program number to the string
			[theItem setProgram:[NSNumber numberWithInt:[value intValue]]];
		}
	}
}

#pragma mark -
#pragma mark  Interface Actions
#pragma mark -

// Add a channel manually
- (IBAction)add:(id)sender{
	
	// Create a new channel
	GBChannel *newChannel = [[GBChannel alloc] initWithChannelNumber:[NSNumber numberWithInt:0] program:[NSNumber numberWithInt:0] andDescription:@"New Channel"];
	
	// Add the channel to the tuner
	[tuner addChannel:newChannel];
	
	// Update the channel list
	[self reloadChannelData:newChannel];
}

// Remove the selected channel
- (IBAction)remove:(id)sender{
	
	// Set the currently selected channel to aChannel
	GBChannel *aChannel = [channelListOutlineView itemAtRow:[channelListOutlineView selectedRow]];

	// Only run the alert if the channel isn't null
	if(aChannel != nil){
		
		// Run the alert sheet notifying the user
		NSBeginAlertSheet(@"Delete the selected channel?", @"OK", @"Cancel",
			nil, [NSApp mainWindow], self, NULL,
			@selector(endAlertSheet:returnCode:contextInfo:),
			NULL,
			[NSString stringWithFormat:@"Are you sure you want to delete \"%@\"? This action CAN NOT be undone.", [aChannel description]]);
	}
}

- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the user agreed to reset the preferences
	if (returnCode == NSAlertDefaultReturn) {
		//NSLog(@"Clicked OK");
		
		// Set the currently selected channel to aChannel
		GBChannel *aChannel = [channelListOutlineView itemAtRow:[channelListOutlineView selectedRow]];
	
		// Have the tuner remove the channel
		[tuner removeChannel:aChannel];
	
		// Update the channel list. All channel data has to be freshed when removing a channel.
		// I am calling this directly rather than thru reloadChannelData to be slightly faster with the
		// refresh.
		[self reloadAllChannelData];
		
	} else if (returnCode == NSAlertAlternateReturn) {
	
		// Don't do anything. The user cancelled the action
		//NSLog(@"Clicked Cancel");
	}
}

// Automatically refresh the channel list
- (IBAction)refresh:(id)sender{

	// If refresh was clicked
	if([sender state]){
		
		// The mode for scanning channels
		int mode;
	
		// Set the scan mode appropriately
		if([[_channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_ALL_CHANNELS]){
		
			// Set the mode to the appropriate value
			mode = CHANNEL_MAP_US_ALL;
		
		} else if([[_channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_CABLE_CHANNELS]){
			
			// Set the mode to the appropriate value
			mode = (CHANNEL_MAP_US_CABLE | CHANNEL_MAP_US_HRC | CHANNEL_MAP_US_IRC);
			
		} else if([[_channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_BCAST_CHANNELS]){
			
			// Set the mode to the appropriate value
			mode = CHANNEL_MAP_US_BCAST;
			
		}
		
		// Then tell the tuner to scan
		[tuner scanForChannels:[NSNumber numberWithInt:mode]];
	
	} else {
		
		// Else cancel was called and we should tell the tuner to cancel the scan
		[tuner setCancelThread:YES];
	}
	
	// Print debug info
	//NSLog(@"GBWindowController refresh button clicked with state = %i and scan mode %@", [sender state], [_channelscan_mode titleOfSelectedItem]);
}

#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{

	// Remove ourselves from any notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[tuner release];
	
	[super dealloc];
}
@end
