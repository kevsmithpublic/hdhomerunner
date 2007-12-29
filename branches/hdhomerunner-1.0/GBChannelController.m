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

- (NSView *)view{
	return mainView;
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

#pragma mark - Clean up

// Clean up
- (void)dealloc{

	[super dealloc];
}

@end
