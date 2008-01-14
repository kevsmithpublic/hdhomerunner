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
	
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"Window"];
	
	// Set the splitview to remember it's position
	[tunerSplitView setPositionAutosaveName:@"tunerSplitView"];
	
	// Set up the channel scan selection
	[_channelscan_mode removeAllItems];
	[_channelscan_mode addItemsWithTitles:[NSArray arrayWithObjects:SCAN_ALL_CHANNELS, 
																	SCAN_BCAST_CHANNELS,
																	SCAN_CABLE_CHANNELS, nil]];
	
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

- (void)changeCurrentView:(NSView *)newView{
	
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

- (void)setRepresentedTuner:(GBTuner *)aTuner{
	
	// If the new tuner is not equal to the existing tuner
	if(![tuner isEqual:aTuner]){
		
		// Set the new tuner to aTuner
		[tuner autorelease];
		tuner = nil;
		tuner = [aTuner retain];
		
		// Update the view
		[self reloadAllChannelData];
	}
	
	// Print debug info
	//NSLog(@"GBWindowController tuner = %@", tuner);
}

- (GBTuner *)representedTuner{
	
	return tuner;
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
	
		// Set the webview to the content view and resize it
		[self changeCurrentView:_web];
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
