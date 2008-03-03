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
//  GBController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBController.h"

// The number of tuners per hdhomerun device
#define TUNERS_PER_DEVICE	2

// Drop down menu options for scanning channel modes
#define	SCAN_ALL_CHANNELS				@"Scan All Channels"
#define SCAN_CABLE_CHANNELS				@"Scan Cable Channels Only"
#define SCAN_BCAST_CHANNELS				@"Scan Broadcast Channels Only"

@implementation GBController

- (id)init{

	// Initialize the instance variables
	if(self = [super init]){
		
		// Initialize the tuners to be empty
		tunerControllers = [[NSMutableArray alloc] init];
		
		// Initialize the channels to be empty
		channelControllers = [[NSMutableArray alloc] init];
		
		// Mutable dictionary of the toolbar items
		toolbarItems = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		// Set the selected tuner to nil
		[self setSelectedTuner:nil];
		
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
		
		// Set up the channel scan selection menu
		channelScanMenu = [[NSMenu alloc] initWithTitle:@"channelscan"];
		[channelScanMenu setAutoenablesItems:NO];
	
		// Initialize the menu item
		NSMenuItem *all_channels = [[NSMenuItem alloc] initWithTitle:SCAN_ALL_CHANNELS action:@selector(updateChannelScanMode:) keyEquivalent:@""];
		[all_channels setTarget:self];
		[all_channels setState:NSOnState];
		[all_channels setEnabled:YES];
		[all_channels setToolTip:@"Scan for broadcast and cable channels"];
		
		// Add the menu item to the menu
		[channelScanMenu addItem:all_channels];
		
		// Release the menu item
		[all_channels release];
		
		// Initialize the menu item
		NSMenuItem *broadcast_channels = [[NSMenuItem alloc] initWithTitle:SCAN_BCAST_CHANNELS action:@selector(updateChannelScanMode:) keyEquivalent:@""];
		[broadcast_channels setTarget:self];
		[broadcast_channels setState:NSOffState];
		[broadcast_channels setEnabled:YES];
		[broadcast_channels setToolTip:@"Scan for broadcast channels only"];
		
		// Add the menu item to the menu
		[channelScanMenu addItem:broadcast_channels];
		
		// Release the menu item
		[broadcast_channels release];
		
		// Initialize the menu item
		NSMenuItem *cable_channels = [[NSMenuItem alloc] initWithTitle:SCAN_CABLE_CHANNELS action:@selector(updateChannelScanMode:) keyEquivalent:@""];
		[cable_channels setTarget:self];
		[cable_channels setState:NSOffState];
		[cable_channels setEnabled:YES];		
		[cable_channels setToolTip:@"Scan for cable channels only"];
		
		// Add the menu item to the menu
		[channelScanMenu addItem:cable_channels];
		
		// Release the menu item
		[cable_channels release];
		
		// vlc handles VLC controls
		NSString *path = [[NSBundle mainBundle] pathForResource:@"launchVLC" ofType:@"scpt"];
		vlc = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
	}
	
	return self;
}

#pragma mark -
#pragma mark  Awake from nib
#pragma mark -

// Method is called as the Nib is loaded
- (void)awakeFromNib{

	// This will center the main window if there's no stored position for it.
	// The frame name (set up in IB) to MainWindow
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil){
		
		// Center the window
		[window center];
	}
	
	// Set the splitView's autosave name.
	[sourceSplitView setPositionAutosaveName:@"SourceSplitView"];
	[contentSplitView setPositionAutosaveName:@"ContentSplitView"];

	// Create the outlineview controller and set the delegate to self
    tunerOutlineViewController = [[GBOutlineViewController controllerWithViewColumn:tunerTableColumn] retain];
    [tunerOutlineViewController setDelegate: self];
	
	// Create the outlineview controller and set the delegate to self
    channelOutlineViewController = [[GBOutlineViewController controllerWithViewColumn:channelTableColumn] retain];
    [channelOutlineViewController setDelegate: self];
	
	// Locate all the tuners on the network
	NSArray *available_tuners = [self discoverTuners];
	
	// Any tuner not in the preferences but available should be added
	NSEnumerator	*tuner_enumerator = [available_tuners objectEnumerator];
	
	// The tuner
	GBTuner			*tuner;
	
	// Loop over the available tuners and try to add it to tuners
	while(tuner = [tuner_enumerator nextObject]){
	
		// Add the tuner to the array. addTuners: will check if the tuner is already
		// inside tuners so we don't have to check for that here.
		[self addTuner:tuner];
	}
	
	// Set up the toolbar on the main window
	theToolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[theToolbar setDelegate:self];
    
	// Make the toolbar configurable
	[theToolbar setAllowsUserCustomization:YES];
	[theToolbar setAutosavesConfiguration:YES];
	
	// Attach the toolbar to the window
	[window setToolbar:theToolbar];

	// Attach the menu to the second index of the channel's segmented control
	[channelSegmentedControl setMenu:channelScanMenu forSegment:2];
																	
	// Update the segmented controls
	[self updateWebSegmentControls];
	[self updateChannelSegmentControls];
}

#pragma mark -
#pragma mark  Accessor Methods
#pragma mark -

- (NSMutableArray *)tunerControllers{
    if (tunerControllers == nil){
        tunerControllers = [[NSMutableArray alloc] init];
    }
    
    return tunerControllers;
}

- (NSMutableArray *)channelControllers{
    if (channelControllers == nil){
        channelControllers = [[NSMutableArray alloc] init];
    }
    
    return channelControllers;
}


#pragma mark -
#pragma mark  Add/Remove Tuners
#pragma mark -

// Add a controller to the array
- (void)addViewController:(GBViewController *)controller toArray:(NSMutableArray *)array{
	
	// Make sure both elements are not nil
	if((controller != nil) && (array != nil)){
	
		// If the array doesn't contain the controller already
		if(![array containsObject:controller]){
			
			// Add the controller to the array
			[array addObject:controller];
		}
	}
}

// Remove a controller from the array
- (void)removeViewController:(GBViewController *)controller fromArray:(NSMutableArray *)array{
	
	// Make sure both elements are not nil
	if((controller != nil) && (array != nil)){
	
		// If the array contains the controller already
		if([array containsObject:controller]){

			// Remove the controller to the array
			[array removeObject:controller];
		}
	}
}

// Add a tuner controller
- (void)addTunerController:(GBTunerViewController *)controller{
	
	// Add the controller to tuner array
	[self addViewController:controller toArray:[self tunerControllers]];
	
	// Reload the outline view
	[tunerOutlineViewController reloadTableView];
}

// Remove a tuner controller
- (void)removeTunerController:(GBTunerViewController *)controller{
	
	// Remove the controller to tuner array
	[self removeViewController:controller fromArray:[self tunerControllers]];
	
	// Reload the outline view
	[tunerOutlineViewController reloadTableView];
}

// Construct a new tuner controller for the tuner and add it to the collection
- (void)addTuner:(GBTuner *)tuner{

	// Make sure the tuner is not nil
	if(tuner != nil){
		
		// Initialize the controller
		GBTunerViewController *controller = [GBTunerViewController controller];
		
		// Set the data object to control
		[controller setTuner:tuner];
		
		// Add the controller
		[self addTunerController:controller];
	}
}

// Remove the tuner from the array
- (void)removeTuner:(GBTuner *)tuner{
	
	// Make sure the tuner is not nil
	if(tuner != nil){
		
		// Initialize the controller
		GBTunerViewController *controller = [GBTunerViewController controller];
		
		// Set the data object to control
		[controller setTuner:tuner];
		
		// Add the controller
		[self removeTunerController:controller];		
	}
}

// If the selected row in the table is greater than -1 return the tuner at that index. Otherwise return nil.
- (GBTuner *)selectedTuner{
	return selectedTuner;
	//return ([tunerOutlineView selectedRow] > -1 ? [[tunerOutlineView itemAtRow:[tunerOutlineView selectedRow]] tuner] : nil); 
}

// Set the selected tuner
- (void)setSelectedTuner:(GBTuner *)aTuner{

	// Key value coding
	[self willChangeValueForKey:@"selectedTuner"];
	
	// Autorelease the current tuner
	[selectedTuner autorelease];
	
	// Set the tuner to nil
	selectedTuner = nil;
	
	// Assign the selectedTuner to aTuner and retain it
	selectedTuner = [aTuner retain];
	
	// Key value coding
	[self didChangeValueForKey:@"selectedTuner"];
}

#pragma mark -
#pragma mark  Add/Remove Channels
#pragma mark -

// Add a channel controller
- (void)addChannelController:(GBChannelViewController *)controller{
	
	// Add the controller to channel array
	[self addViewController:controller toArray:[self channelControllers]];
	
	// Reload the outline view
	[channelOutlineViewController reloadTableView];
	
	// Update the segmented controls
	[self updateChannelSegmentControls];
}

// Remove a channel controller
- (void)removeChannelController:(GBChannelViewController *)controller{
	
	// Remove the controller from the channel array
	[self removeViewController:controller fromArray:[self channelControllers]];

	// Reload the outline view
	[channelOutlineViewController reloadTableView];
	
	// Update the segmented controls
	[self updateChannelSegmentControls];
}

// Construct a new channel controller for the channel and add it to the collection
- (void)addChannel:(GBChannel *)channel{

	// Make sure the channel is not nil
	if(channel != nil){
		
		// Initialize the controller
		GBChannelViewController *controller = [GBChannelViewController controller];
		
		// Set the data object to control
		[controller setChannel:channel];
		
		// Add the channel to the tuner
		//[[self selectedTuner] addGBChannel:channel];
		[self addChannelToPlayMenu:channel];
		
		// Add the controller
		[self addChannelController:controller];
		
		// Update the segmented controls
		[self updateChannelSegmentControls];
	}
}

// Remove the channel from the array
- (void)removeChannel:(GBChannel *)channel{
	
	// Make sure the channel is not nil
	if(channel != nil){
			
		// Initialize the controller
		GBChannelViewController *controller = [GBChannelViewController controller];
		
		// Set the data object to control
		[controller setChannel:channel];
	
		// Remove the channel from the tuner
		//[[self selectedTuner] removeGBChannel:channel];
		[self removeChannelToPlayMenu:channel];
		
		// Remove the controller
		[self removeChannelController:controller];
	}
}

// Return the selected channel in the table. Nil if it doesn't exist
- (GBChannel *)selectedChannel{

	return ([channelOutlineView selectedRow] > -1 ? [[channelOutlineView itemAtRow:[channelOutlineView selectedRow]] channel] : nil);
}

// Return the channel at the specified index
- (GBChannel *)channelAtIndex:(NSUInteger)index{
	
	// If the index is less than 0 or greater than or equal to the count
	if((index < 0) || (index >= [[self channelControllers] count])){
	
		// Then set the index to 0 since the index was out of bounds
		index = 0;
	}
	
	// Return the object at the index
	return (GBChannel *)[[[self channelControllers] objectAtIndex:index] channel];
}

- (void)setChannels:(NSArray *)channels{
	
	// Remove all existing channels
	[[self channelControllers] removeAllObjects];
	
	// The enumerator to loop over
	NSEnumerator	*enumerator = [channels objectEnumerator];
	
	// An item in the enumerator
	GBChannel	*channel;
	
	// Loop over all the channels
	while (channel = [enumerator nextObject]){
		
		// Add each channel to the array
		[self addChannel:channel];
	}
	
	// We MUST reload the table view FIRST then update the controls
	// Else the selectedChannel will think the wrong item is selected.
	
	// Reload the outline view
	[channelOutlineViewController reloadTableView];
	
	// Update the segmented controls
	[self updateChannelSegmentControls];
}

#pragma mark -
#pragma mark  Discover Tuners
#pragma mark -

// Discover any tuners on the network
- (NSArray *)discoverTuners{
	
	// A temporary array to hold tuners that we find on the network
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
	
	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	struct hdhomerun_discover_device_t result_list[128];
	
	// Query the network for devices. Return the number of devices into count and populate the devices into the result list.
	uint32_t IP_WILD_CARD = 0;
	int count = hdhomerun_discover_find_devices_custom(IP_WILD_CARD, HDHOMERUN_DEVICE_TYPE_TUNER, HDHOMERUN_DEVICE_ID_WILDCARD, result_list, 128);
	
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
		}
	}
	
	// Return the collection of tuners
	return tmp;
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
                 modalForWindow:window
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
                 modalForWindow:window
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
				
				// Add the channel to the tuner
				[[self selectedTuner] addGBChannel:tmp];
			}
		} else if(contextInfo = exporthdhrcontrol){
			// If the sender was exporthdhrcontrol
			
			// The channels to export
			NSArray *channels = [[self selectedTuner] channels];
			
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
#pragma mark  Data source protocol
#pragma mark -

// Methods from SubviewTableViewControllerDataSourceProtocol
- (NSView *) outlineView:(NSOutlineView *) outlineview viewForItem:(id) item{
    
	// The view to return
	NSView *result;
	
	// Set the result to appropriate view
	if(outlineview == tunerOutlineView){
		
		// Set the result to the tuner's view
		result = [item view];
	} else if(outlineview == channelOutlineView){
	
		result = [item view];
	}
	
	return result;
}

#pragma mark -
#pragma mark  WebKit Delegate Methods
#pragma mark -

// When the webview is done loading set up the segmented control buttons
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
	
	// Update the controls
	[self updateWebSegmentControls];
}

// Update the segmented controls 
- (void)updateWebSegmentControls{
	
	// Set the forward/back buttons
	[segmentedControl setEnabled:[webView canGoBack] forSegment:0];
	[segmentedControl setEnabled:[webView canGoForward] forSegment:2];
	
	// Set the Reload/Stop button based on if the webview is loading
	if([webView isLoading]){
		
		// If the webview is loading set the image to cancel
		[segmentedControl setImage:[NSImage imageNamed:@"NSStopProgressTemplate"] forSegment:1];
	} else {
	
		// Else set the control for reloading
		[segmentedControl setImage:[NSImage imageNamed:@"NSRefreshTemplate"]  forSegment:1];
	}
}

- (IBAction)changeWebSite:(id)sender{
	
	// The portion of the segmented control that is selected
	NSUInteger selectedSegment = [sender selectedSegment];
    NSUInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
    
	// Tell the webview what to do
	if(clickedSegmentTag == 0){
	
		// If back was selected tell the webview to go back
		[webView goBack];
	} else if(clickedSegmentTag == 1){
		
		// If reload was seletected
		if(![webView isLoading]){
		
			// Then reload the view
			[[webView mainFrame] reload];
		} else {
			
			// Else stop the webview from loading
			[[webView mainFrame] stopLoading];
		}
	} else if(clickedSegmentTag == 2){
		
		// If forward was selected tell the webview to go forward
		[webView goForward];		
	}
	
	// Update the controls
	[self updateWebSegmentControls];
}

#pragma mark -
#pragma mark  Delegate Methods
#pragma mark -

// Reload the channels when the tuner selection changes
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
	
	// The outlineview posting the notification
	NSOutlineView *outlineview = [notification object];

	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){

		// If the currently selected tuner is not nil
		if([self selectedTuner]){
		
			// Unregister from receiving notifications from the tuner
			[self unRegisterAsObserverForTuner:[self selectedTuner]];
		}
		
		// Set the selected tuner to the new tuner
		[self setSelectedTuner:([tunerOutlineView selectedRow] > -1 ? [[tunerOutlineView itemAtRow:[tunerOutlineView selectedRow]] tuner] : nil)];
		
		// If the newly selected tuner is not nil
		if([self selectedTuner]){
			
			// Register as an observer for the tuner
			[self registerAsObserverForTuner:[self selectedTuner]];
		}
		
		// Set the channel controllers from the tuner's channels
		[self setChannels:[[self selectedTuner] channels]];
	} else if(outlineview == channelOutlineView){
		
		// Load the channel's URL
		
		// The channel to load
		NSURL *aURL = [[self selectedChannel] url];
		
		// NOTE:
		// For webview to properly load the URL it must begin with http://
		// http://somesite.com is OK, but somesite.com is NOT
		
		// If the url is null then set the url to the a default 
		if(aURL == nil){
			
			// Get the path for the default.html resource
			NSString *path = [NSBundle pathForResource:@"default" ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
			
			// Set aURL to the default url
			aURL = nil;
			aURL = [NSURL URLWithString:path];
			
		}

		// Set the webview to load the appropriate URL
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:aURL]];
		
		// Update the controls
		[self updateWebSegmentControls];
	}
}

// If the column is resizing tell each of the subviews to redraw themselves
/*- (void) outlineViewColumnDidResize:(NSNotification *) notification{

	// The outlineview posting the notification
	NSOutlineView *outlineview = [notification object];

	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){
		
		// The enumerator to loop over
		NSEnumerator *enumerator = [tunerControllers objectEnumerator];
		
		// Each object in the enumerator
		GBTunerViewController *object;
		
		// Loop over all the views
		while ((object = [enumerator nextObject])) {
			
			// Redraw the subview
			[object redrawSubviews];
		}
	}
}*/

// Toggle subviews based on the outlineview expanding or collapsing
- (void)outlineViewItemWillCollapse:(NSNotification *)notification{

	// The tuner that is collapsing
	GBTunerViewController *controller = [[notification userInfo] objectForKey:@"NSObject"];
	
	// Hide the subviews so they will no longer be displayed
	[controller hideSubviews];
}

// Toggle subviews based on the outlineview expanding or collapsing
- (void)outlineViewItemWillExpand:(NSNotification *)notification{

	// The tuner that is expanding
	GBTunerViewController *controller = [[notification userInfo] objectForKey:@"NSObject"];

	// Unhide all the subviews so they are shown in the outlineview
	[controller unhideSubviews];
}

// Specify whether the user should be able to select a particular item
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldSelectItem:(id)item{
	
	// Only allow tuner and channel views to be selected. Subviews should not be selectable
	return ([item isKindOfClass:[GBTunerViewController class]] || [item isKindOfClass:[GBChannelViewController class]]);
}

// Return the child of the item at the index
- (id)outlineView:(NSOutlineView *)outlineview child:(int)index ofItem:(id)item{

	// The view to return
	id result = nil;
	
	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){
		
		// If the item is nil 
		if(item == nil){
			
			// Return the View Controller at the specified index
			result = [[self tunerControllers] objectAtIndex:index];
		} else if([item isKindOfClass:[GBTunerViewController class]]){
			
			// If requesting the children of the view controller
			result = [[item subviews] objectAtIndex:index];
		}
	} else if(outlineview == channelOutlineView){
		
		// If the item is nil 
		if(![item isKindOfClass:[GBChannelViewController class]]){
			
			// Return the View Controller at the specified index
			result = [[self channelControllers] objectAtIndex:index];
		}
	}
	
	return result;
	
}

// Return YES if the item is expandable
- (BOOL)outlineView:(NSOutlineView *)outlineview isItemExpandable:(id)item{
	
	// The view to return
	BOOL result = NO;
	
	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){
		
		// If the item is a tuner then YES it is expandable
		result =  [item isKindOfClass:[GBTunerViewController class]];
	}
	
	return result;
}

// Return the number of children of the item
- (NSUInteger)outlineView:(NSOutlineView *)outlineview numberOfChildrenOfItem:(id)item{
	
	// The view to return
	NSUInteger result = 0;
	
	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){
		
		// If the item is nil return the total number of tuners 
		if(item == nil){
			
			// Set the result to the tuner's view
			result = [[self tunerControllers] count];
		} else if([item isKindOfClass:[GBTunerViewController class]]){
			
			// There is 1 subview to display with all the tuner info in it
			result = 1;
		}
	} else if(outlineview == channelOutlineView){
	
		// If the item is nil then return the number of channels
		if(item == nil){
		
			// The number of channels
			result = [[self channelControllers] count];
		}
	}
	
	return result;
}

// The value for the table column
- (id)outlineView:(NSOutlineView *)outlineview objectValueForTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{

	NSLog(@"GBWindowController item = %@ identifier = %@", item, [tablecolumn identifier]);
	
	// The view to return
	id result = nil;
	
	// Set the result to appropriate value
	if(outlineview == tunerOutlineView){
		

	}
	
	return result;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{	
	// Print debug info
	//NSLog(@"GBWindowController setObjectValue for item = %@ to = %@ of class = %@ in = %@", item, aValue, [aValue class], [tablecolumn identifier]);
	

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
#pragma mark   Manage menu items
#pragma mark -

// A menu item version for the channel
- (NSMenuItem *)menuItemForChannel:(GBChannel *)channel{
	
	// The menu item to return
	NSMenuItem *menuItem = nil;
	
	// If channel is not nil
	if(channel){
	
		// Create a new menu item
		menuItem = [[NSMenuItem alloc] initWithTitle:[channel description]  action:@selector(playItem:)  keyEquivalent:@""];
		
		// Create the menu item's image
		NSImage *image = [channel icon];
		
		// Resize the image
		[image setSize: NSMakeSize(16, 16)];
		
		// Set the menu item's image
		[menuItem setImage:image];
		
		// Set the menu item's target
		[menuItem setTarget:self];
		
		// Set the menu item's represented object
		[menuItem setRepresentedObject:channel];
		
		// Bind the image to the channels icon
		[menuItem bind:@"image" toObject:channel withKeyPath:@"smallIcon" options:nil];
		
		// Bind the title to the channel's description
		[menuItem bind:@"title" toObject:channel withKeyPath:@"description" options:nil];
	}
	
	return menuItem;
}

// Add the item to the play menu of the tuner
- (void)addPlayMenuItem:(NSMenuItem *)item toTunerViewController:(GBTunerViewController *)controller{

	[controller addPlayMenuItem:item];
}

// Remove the item to the play menu of the tuner
- (void)removePlayMenuItem:(NSMenuItem *)item toTunerViewController:(GBTunerViewController *)controller{

	[controller removePlayMenuItem:item];
}

// Add a menu item to the selected tuner controller
- (void)addChannelToPlayMenu:(GBChannel *)channel{
	
	// If channel exists
	if(channel){
	
		// The menu item to add
		NSMenuItem *menuItem = [self menuItemForChannel:channel];
		
		// The tunerview controller to add to
		GBTunerViewController *controller = ([tunerOutlineView selectedRow] > -1 ? [tunerOutlineView itemAtRow:[tunerOutlineView selectedRow]] : nil);
		
		// Add the channel to the controller
		[self addPlayMenuItem:menuItem toTunerViewController:controller];
	}
}

// Remove a menu item to the selected tuner controller
- (void)removeChannelToPlayMenu:(GBChannel *)channel{
	
	// If channel exists
	if(channel){
	
		// The menu item to add
		NSMenuItem *menuItem = [self menuItemForChannel:channel];
		
		// The tunerview controller to add to
		GBTunerViewController *controller = ([tunerOutlineView selectedRow] > -1 ? [tunerOutlineView itemAtRow:[tunerOutlineView selectedRow]] : nil);
		
		// Add the channel to the controller
		[self removePlayMenuItem:menuItem toTunerViewController:controller];
	}
}

#pragma mark -
#pragma mark   Toolbar actions
#pragma mark -

- (void)launchVLC{

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
}

- (void)playChannel:(GBChannel *)channel{

	// If the channel is not nil
	if(channel){
		
		// Launch VLC
		[self launchVLC];
		
		// Set the channel on the tuner
		[[self selectedTuner] setGBChannel:channel];
	
		// Tell the selected tuner to play
		[[self selectedTuner] play];
	}
}

// Play menu action
- (IBAction)playItem:(id)sender{
	
	// Play the channel represented by the sender
	[self playChannel:[sender representedObject]];
}

// Play ToobarItem action
// Play the currently selected channel when the user clicks this item
- (IBAction)play:(id)sender{
	NSLog(@"play toolbar item selected");
	
	// Set the channel of the tuner
	[self playChannel:[self selectedChannel]];
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
	
	[[GBPreferences sharedInstance] showPanel:sender];
}

// Record action
// Record the current channel when the user clicks this item
- (IBAction)record:(id)sender{
	NSLog(@"record toolbar item selected");
}

#pragma mark -
#pragma mark  Interface Actions
#pragma mark -

// Update the segmented controls 
- (void)updateChannelSegmentControls{
	
	// Set the enabled status of the buttons
	[channelSegmentedControl setEnabled:([self selectedTuner] ? YES : NO) forSegment:0];
	[channelSegmentedControl setEnabled:([self selectedChannel] ? YES : NO) forSegment:1];
	[channelSegmentedControl setEnabled:([self selectedTuner] ? YES : NO) forSegment:2];
	
	// The image to set the refresh control to
	NSImage *image;
	
	// If the selected tuner is scanning for channels
	if([[self selectedTuner] isScanningChannels]){
	
		// Then set the image displayed on the 2nd segment to a cancel icon
		image = [NSImage imageNamed:@"NSStopProgressTemplate"];
	} else {
		
		// Set the image displayed to a refresh icon
		image = [NSImage imageNamed:@"NSRefreshTemplate"];
	}
	
	// Set the image
	[channelSegmentedControl setImage:image forSegment:2];
}

// Update the selected menu option for channel scanning
- (void)updateChannelScanMode:(id)sender{

	// The array of menu items
	NSArray *array = [channelScanMenu itemArray];
	
	// The enumerator
	NSEnumerator	*enumerator = [array objectEnumerator];
	
	// The item in the array
	NSMenuItem		*item;
	
	// Loop over the objects
	while(item = [enumerator nextObject]){
	
		// Set the status as off
		[item setState:NSOffState];
	}
	
	// Set the sender to the one state
	[sender setState:NSOnState];
}

- (IBAction)modifyChannels:(id)sender{
	
	// The portion of the segmented control that is selected
	NSUInteger selectedSegment = [sender selectedSegment];
    NSUInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
    
	// Tell the tuner what to do
	if(clickedSegmentTag == 0){
	
		// If add button was selected then add a channel
		
		// Only add a channel if the tuner is not null
		if([self selectedTuner] != nil){
		
			// Create a new channel
			GBChannel *newChannel = [[GBChannel alloc] initWithChannelNumber:[NSNumber numberWithInt:0] program:[NSNumber numberWithInt:0] andDescription:@"New Channel"];
			
			// Add the channel to the tuner
			[[self selectedTuner] addGBChannel:newChannel];
		}
	} else if(clickedSegmentTag == 1){
		
		// If the remove channel was selected
			// Set the currently selected channel to aChannel
		GBChannel *aChannel = [self selectedChannel];

		// Only run the alert if the channel isn't null
		if(aChannel != nil){
			
			// Run the alert sheet notifying the user
			NSBeginAlertSheet(@"Delete the selected channel?", @"OK", @"Cancel",
				nil, [NSApp mainWindow], self, NULL,
				@selector(endAlertSheet:returnCode:contextInfo:),
				NULL,
				[NSString stringWithString:@"Are you sure you want to delete the selected Channels? This action CAN NOT be undone."]);
		}	
	} else if(clickedSegmentTag == 2){
	
		// If the selected tuner is scanning
		if([[self selectedTuner] isScanningChannels]){
			
			// Then cancel it
			[[self selectedTuner] setCancelThread:YES];
		} else {
			
			// Start the scan
		
			// If channel refresh was selected then find which mode is highlighted
			
			// The mode for scanning channels
			NSUInteger mode;
			
			// The array of menu items
			NSArray *array = [channelScanMenu itemArray];
			
			// The enumerator
			NSEnumerator	*enumerator = [array objectEnumerator];
			
			// The item in the array
			NSMenuItem		*item;
			
			// Loop over the objects
			while(item = [enumerator nextObject]){
			
				// If the item is in the on state
				if([item state] == NSOnState){
					
					// Set the mode according to the menu item's title
					// Set the scan mode appropriately
					if([[item title] isEqualToString:SCAN_ALL_CHANNELS]){
					
						// Set the mode to the appropriate value
						mode = CHANNEL_MAP_US_ALL;
					
					} else if([[item title] isEqualToString:SCAN_CABLE_CHANNELS]){
						
						// Set the mode to the appropriate value
						mode = (CHANNEL_MAP_US_CABLE | CHANNEL_MAP_US_HRC | CHANNEL_MAP_US_IRC);
						
					} else if([[item title] isEqualToString:SCAN_BCAST_CHANNELS]){
						
						// Set the mode to the appropriate value
						mode = CHANNEL_MAP_US_BCAST;
						
					}
				}
			}
			
			// Execute the channel scan
			[[self selectedTuner] scanForChannels:[NSNumber numberWithInt:mode]];
		}
	}
	
	// Update the controls
	[self updateChannelSegmentControls];
}

// Confirm that the deletion should take place
- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the user agreed to reset the preferences
	if (returnCode == NSAlertDefaultReturn) {
		//NSLog(@"Clicked OK");
		
		// Get all the selected rows
		NSIndexSet *selectedRows = [channelOutlineView selectedRowIndexes];
		NSUInteger index = [selectedRows lastIndex];
		
		// While there is still an index to remove
        while (index != NSNotFound){

			// Get the channel at the index
            GBChannel *aChannel = [self channelAtIndex:index];
			
			// Have the tuner remove the channel
			[[self selectedTuner] removeGBChannel:aChannel];
			
			// Update the index
            index = [selectedRows indexLessThanIndex: index];
        }
	} else if (returnCode == NSAlertAlternateReturn) {
	
		// Don't do anything. The user cancelled the action
		//NSLog(@"Clicked Cancel");
	}
}

// Automatically refresh the channel list
- (IBAction)refresh:(id)sender{

	// If refresh was clicked
	/*if([sender state]){
		
		// The mode for scanning channels
		NSUInteger mode;
	
		// Set the scan mode appropriately
		if([[channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_ALL_CHANNELS]){
		
			// Set the mode to the appropriate value
			mode = CHANNEL_MAP_US_ALL;
		
		} else if([[channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_CABLE_CHANNELS]){
			
			// Set the mode to the appropriate value
			mode = (CHANNEL_MAP_US_CABLE | CHANNEL_MAP_US_HRC | CHANNEL_MAP_US_IRC);
			
		} else if([[channelscan_mode titleOfSelectedItem] isEqualToString:SCAN_BCAST_CHANNELS]){
			
			// Set the mode to the appropriate value
			mode = CHANNEL_MAP_US_BCAST;
			
		}
		
		// Then tell the tuner to scan
		[[self selectedTuner] scanForChannels:[NSNumber numberWithInt:mode]];
	
	} else {
		
		// Else cancel was called and we should tell the tuner to cancel the scan
		[[self selectedTuner] setCancelThread:YES];
	}*/
	
	// Print debug info
	//NSLog(@"GBWindowController refresh button clicked with state = %i and scan mode %@", [sender state], [_channelscan_mode titleOfSelectedItem]);
}

// Show the About Box
- (IBAction)showAboutBox:(id)sender{
    [[GBAboutBox sharedInstance] showPanel:sender];
}

#pragma mark -
#pragma mark  Key Value Observing
#pragma mark -

// Register for Key Value Coding of the tuner
// When the signal strength changes we should update the view
- (void)registerAsObserverForTuner:(GBTuner *)aTuner{
	
	[aTuner addObserver:self
			forKeyPath:@"channels"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
			
	[aTuner addObserver:self
			forKeyPath:@"isScanningChannels"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
}

- (void)unRegisterAsObserverForTuner:(GBTuner *)aTuner{

    [aTuner removeObserver:self forKeyPath:@"channels"];
	[aTuner removeObserver:self forKeyPath:@"isScanningChannels"];
}

- (void)registerAsObserverForChannel:(GBChannel *)aChannel{
	
	[aChannel addObserver:self
			forKeyPath:@"url"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
}

- (void)unRegisterAsObserverForChannel:(GBChannel *)aChannel{

    [aChannel removeObserver:self forKeyPath:@"url"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
						ofObject:(id)object
                        change:(NSDictionary *)change
						context:(void *)context {
	

	// If the channels changed
	if ([keyPath isEqual:@"channels"]) {
				
		// The current set of channels to sync to
		NSArray *channelArray = [[self selectedTuner] channels];
		
		// A copy of the channels in the list
		NSArray *channelViewArray = [[self channelControllers] copy];
		
		// The enumerator to loop over
		NSEnumerator *enumerator = [channelArray objectEnumerator];
		
		// A channel in the enumerator
		GBChannel *channel;
		
		// Loop over all the channels first
		while(channel = [enumerator nextObject]){
		
			// Add any channels that might happen to not be in our list
			[self addChannel:channel];
		}
		
		// Reassign the enumerator
		enumerator = [channelViewArray objectEnumerator];
		
		// Loop over all the channels in our list
		while(channel = [[enumerator nextObject] channel]){
		
			// If the same channel doesn't appear in the channels
			// we are syncing to
			if(![channelArray containsObject:channel]){
				
				// Then remove the channel from our list
				[self removeChannel:channel];
			}
		}
		
	} else if ([keyPath isEqual:@"isScanningChannels"]) {
	
		// Update the controls
		[self updateChannelSegmentControls];
	}
}

#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{
	
	[tunerOutlineViewController release];
	[tunerControllers release];

	[channelOutlineViewController release];
	[channelControllers release];
	
	[vlc release];
	[importhdhrcontrol release];
	[exporthdhrcontrol release];
	[channelSegmentedControl release];
	[channelScanMenu release];
	
	[super dealloc];
}
@end
