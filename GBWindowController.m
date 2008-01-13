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

// Source: http://developer.apple.com/qa/qa2006/qa1487.html
// License: Public Domain
@interface NSAttributedString (Hyperlink)
  +(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);

    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];

    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];

    // next make the text appear with an underline
    [attrString addAttribute:
            NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];

    [attrString endEditing];

    return [attrString autorelease];
}
@end

@implementation GBWindowController

- (id)initWithWindow:(NSWindow *)window{
	
	if(self = [super initWithWindow:window]){
	
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"Window"];
	
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

- (void)updateView{
	
	// Get the URL for the channel
	/*NSURL *aURL = [selectedChannel url];
	NSLog(@"updating view to url = %@", [aURL absoluteString]);
	// If the url is null then set the url to the a default 
	if(!aURL){
		
		// Get the path for the default.html resource
		NSString *path = [NSBundle pathForResource:@"default" ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
		
		// Set aURL to the default url
		aURL = nil;
		aURL = [NSURL URLWithString:path];
		
		
	} else {
	
		// If the url exists...
		// Special care is required for the _url field
		
		// Embedding Hyperlinks in NSTextField and NSTextView
		// Source: http://developer.apple.com/qa/qa2006/qa1487.html
		// Added: 01/03/2007 
	
		 // Both are needed, otherwise hyperlink won't accept mousedown
		[_url setAllowsEditingTextAttributes: YES];
		[_url setSelectable: YES];

		// Create the hyperlink string
		NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
		[string appendAttributedString: [NSAttributedString hyperlinkFromString:[aURL absoluteString] withURL:aURL]];

		// Set the attributed string to the NSTextField
		[_url setAttributedStringValue: string];
	}
	
	// Set the webview to load the appropriate URL
	[[_web mainFrame] loadRequest:[NSURLRequest requestWithURL:aURL]]; 
	
	// Set the image view to the channel's icon
	[_icon setImage:[selectedChannel icon]];
		
	// The textfields to show the relevant info
	[_title setStringValue:[selectedChannel title]];
	[_program setIntValue:[[selectedChannel program] intValue]];
	[_channel setIntValue:[[selectedChannel number] intValue]];*/
	
	// Then update the table
	[channelListOutlineView reloadData];
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
	// Fix host if the string is already completed HTTP complete
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
		[self updateView];
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
	NSLog(@"GBWindowController selection did change");
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
	
	if(theItem){
	
		// Vary the results based on the tablecolumn requesting data
		NSString *ident = [tablecolumn identifier];
		
		// Declare the string to return
		NSString *string;
		
		if([ident isEqualToString:@"description"]){
			
			// Set the string to the channel's description
			string = [theItem description];
			
		} else if([ident isEqualToString:@"url"]){
		
			// Set the string to the channel's url
			//string = [theItem url];
			string = @"website";
			
		} else if([ident isEqualToString:@"channel"]){
		
			// Set the string to the channel number
			string = [[theItem channelNumber] stringValue];
			
		} else if([ident isEqualToString:@"program"]){
		
			// Set the string to the program number
			string = [[theItem program] stringValue];
			
		}
		// The font to use for the title
		/*NSFont *title_font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];
	
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
		[image setSize:NSMakeSize( row_height, row_height )];*/
		
		//return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"Image", string, @"String", nil];
		return string;

	}
	
	return item;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tc byItem:(id)item
{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
}

#pragma mark -
#pragma mark  Interface Actions
#pragma mark -

// Add a channel manually
- (IBAction)add:(id)sender{

}

// Remove the selected channel
- (IBAction)remove:(id)sender{

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
	NSLog(@"GBWindowController refresh button clicked with state = %i and scan mode %@", [sender state], [_channelscan_mode titleOfSelectedItem]);
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
