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
//  GBChannelController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannelController.h"

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

@implementation GBChannelController

// Override the designated initializer to make sure that these variables get initialized
- (id)initWithWindow:(NSWindow *)window{
	if(self = [super initWithWindow:window]){
		[self setDescription:@"CHANNELS"];								// Set the description of the collection
		[self setTitle:@"CHANNELS"];									// Set the title of the collection
		[self setIsExpandable:YES];										// Set this is an expandable collection
		[self setChildren:[NSMutableArray arrayWithCapacity:0]];		// Set the collection to initially be empty
	
		//NSImage *icon = [NSImage imageNamed:@"Folder"];					// Set the icon to appear next to the title in the nsoutlineview
		//[self setIcon:icon];
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"Channel Window"];
	
}

// Configure the Controller to the specified dictionary
- (void)configureWithDictionary:(NSDictionary *)dictionary{
	
	// If dictionary is not null...
	if(dictionary){
	
		// Set the properties dictionary to dictionary
		//[properties setDictionary:dictionary];
		[self setProperties:dictionary];
		
		// If there are children associated with the properities then convert the children
		// from dictionary objects into normal children
		if([[properties allKeys] containsObject:@"children"]){
		
			// Set the dictionary collection of children to dictChildren
			NSArray *dictChildren = [dictionary objectForKey:@"children"];
			
			// Initialize newChildren to be the array for the new children
			NSMutableArray	*newChildren = [NSMutableArray array];
			
			// The enumerator to loop over
			NSEnumerator	*enumerator = [dictChildren objectEnumerator];
			
			// Assign each object in the enumeration to object.
			id object;

			while ((object = [enumerator nextObject])){
			
				// Take each dictionary object and create and init a new child
				id newChild = [[GBChannel alloc] initWithDictionary:object];
				
				// Add the new child to the newChildren array
				[newChildren addObject:newChild];
				
				// Release the newChild because newChildren will retain it
				[newChild release];
			}
			
			// Set the children to newChildren
			[self setChildren:newChildren];
		}
	}
}

- (NSView *)viewForChild:(GBChannel *)aChannel{

	[selectedChannel autorelease];
	//selectedChannel = nil;
	selectedChannel = [aChannel retain];

	// Get the URL for the channel
	NSURL *aURL = [aChannel url];
	
	// If the url is null then set the url to the a default 
	if(aURL == nil){
		
		// Get the path for the default.html resource
		NSString *path = [NSBundle pathForResource:@"default" ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
		
		// Set aURL to the default url
		aURL = nil;
		aURL = [NSURL URLWithString:path];
		
		// Set the attributed string to the NSTextField
		[_url setStringValue:@""];
		
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
	[_icon setImage:[aChannel icon]];
		
	// The textfields to show the relevant info
	[_title setStringValue:[aChannel title]];
	[_program setIntValue:[[aChannel program] intValue]];
	[_channel setIntValue:[[aChannel number] intValue]];
	
	// Finally return the view
	return _view;
}

- (void)updateView{

	// Get the URL for the channel
	NSURL *aURL = [selectedChannel url];
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
	[_channel setIntValue:[[selectedChannel number] intValue]];
}


- (IBAction)editChannel:(id)sender{

	// If the item is selected
	if([sender state]){
	
		// Set the bezel styles of the text fields to be editable
		[_title setBezelStyle:NSTextFieldRoundedBezel];
		[_url setBezelStyle:NSTextFieldRoundedBezel];
	
		// Set the fields to show the bezel
		[_title setBezeled:YES];
		[_url setBezeled:YES];
		
		// Set the fields to be editable
		[_title setEditable:YES];
		[_url setEditable:YES];
		
		[_title setSelectable:YES];
		[_url setSelectable:YES];
				
	} else{
	
		// Set the fields to be not editable
		[_title setEditable:NO];
		[_url setEditable:NO];
		
		[_title setSelectable:NO];
	
		// Return the items to the original state
		[_title setBezeled:NO];
		[_url setBezeled:NO];
		
		// Apply the changes
		[selectedChannel setTitle:[_title stringValue]];
		
		// Get a properly formatted URL		
		NSString *formattedURL = [self autoCompletedHTTPStringFromString:[_url stringValue]];
		[selectedChannel setURL:[NSURL URLWithString:formattedURL]];
		
		[self updateView];
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


#pragma mark - WebView delegate

// -------------------------------------------------------------------------------
//	webView:makeFirstResponder
//
//	We want to keep the outline view in focus as the user clicks various URLs.
//
//	So this workaround applies to an unwanted side affect to some web pages that might have
//	JavaScript code thatt focus their text fields as we target the web view with a particular URL.
//
// -------------------------------------------------------------------------------
/*- (void)webView:(WebView *)sender makeFirstResponder:(NSResponder *)responder
{
	if (retargetWebView)
	{
		// we are targeting the webview ourselves as a result of the user clicking
		// a url in our outlineview: don't do anything, but reset our target check flag
		//
		retargetWebView = NO;
	}
	else
	{
		// continue the responder chain
		[[self window] makeFirstResponder:sender];
	}
}*/

#pragma mark -
#pragma mark  Clean up
#pragma mark -

// Clean up
- (void)dealloc{

	[super dealloc];
}

@end
