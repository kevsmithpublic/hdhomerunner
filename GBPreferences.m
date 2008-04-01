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
//  GBPreferences.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBPreferences.h"

#define RECORDING_KEY_PATH				@"Recording Path"


@implementation GBPreferences

static GBPreferences *sharedInstance = nil;

// Initialize
- (id)init{

	// If an instance of the class already exists
	if(sharedInstance){

		// dealloc it
		[self dealloc];
	} else {
	
		// Call the super class's init
		sharedInstance = [super init];
		
		// Mutable dictionary of the toolbar items
		toolbarItems = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		// Initialize the toolbaritem
		NSToolbarItem *_general = [[NSToolbarItem alloc] initWithItemIdentifier:@"General"];
		[_general setAction:@selector(switchView:)];
		[_general setTarget:self];
		[_general setPaletteLabel:@"General"];
		[_general setLabel:@"General"];
		[_general setToolTip:@"General"];
		//[_general setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_general forKey:@"General"];
		
		// Initialize the toolbaritem
		NSToolbarItem *_update = [[NSToolbarItem alloc] initWithItemIdentifier:@"Update"];
		[_update setAction:@selector(switchView:)];
		[_update setTarget:self];
		[_update setPaletteLabel:@"Update"];
		[_update setLabel:@"Update"];
		[_update setToolTip:@"Update"];
		//[_update setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_update forKey:@"Update"];
		
		// Initialize the toolbaritem
		NSToolbarItem *_donate = [[NSToolbarItem alloc] initWithItemIdentifier:@"Donate"];
		[_donate setAction:@selector(switchView:)];
		[_donate setTarget:self];
		[_donate setPaletteLabel:@"Donate"];
		[_donate setLabel:@"Donate"];
		[_donate setToolTip:@"Donate"];
		//[_donate setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_donate forKey:@"Donate"];
		
		// Initialize the toolbaritem
		NSToolbarItem *_record = [[NSToolbarItem alloc] initWithItemIdentifier:@"Record"];
		[_record setAction:@selector(switchView:)];
		[_record setTarget:self];
		[_record setPaletteLabel:@"Record"];
		[_record setLabel:@"Record"];
		[_record setToolTip:@"Record"];
		//[_record setImage:[NSImage imageNamed:@"Record"]];
		
		// Add the toolbar item to the dictionary
		[toolbarItems setObject:_record forKey:@"Record"];
			
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed:@"Preferences" owner:sharedInstance]){
			
			// Release
			[sharedInstance release];
			
			// Point to nil
			sharedInstance = nil;
		}
	}

	return sharedInstance;
}

// Awake from NIB
- (void)awakeFromNib{
	
	// Set up the toolbar on the main window
	NSToolbar *theToolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[theToolbar setDelegate:self];
    
	// Make the toolbar configurable
	[theToolbar setAllowsUserCustomization:NO];
	[theToolbar setAutosavesConfiguration:NO];
	
	// Attach the toolbar to the window
	[window setToolbar:theToolbar];
    
	// toolbar is retained by the window
	[theToolbar release];	
}

// Only allow one instance of GBAboutBox to be displayed
+ (GBPreferences *)sharedInstance{
    return sharedInstance ? sharedInstance : [[self alloc] init];
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
									@"General",
									@"Record",
									@"Update",
									@"Donate",
									nil];
}

#pragma mark -
#pragma mark   IBActions
#pragma mark -

- (IBAction)showPanel:(id)sender{
	
	// Show the window at front
    [window makeKeyAndOrderFront:nil];
}

- (IBAction)switchView:(id)sender{
	
	// The view to switch to
	NSView *new_view;
	
	// Determine which view to change to depending on the sender
	if([[sender label] isEqualToString:@"General"]){
	
		new_view = generalView;
	} else if([[sender label] isEqualToString:@"Update"]){
	
		new_view = updateView;
	} else if([[sender label] isEqualToString:@"Donate"]){
	
		new_view = donateView;
	} else if([[sender label] isEqualToString:@"Record"]){
	
		new_view = recordView;
	}

	// Get the current view's size
	NSSize currentViewSize = [[window contentView] bounds].size;
	NSSize currentWindowSize = [window frame].size;
	
	// Get the new view's size
	NSSize newViewSize = [new_view bounds].size;
	
	// Get the window's origin
	NSPoint currentWindowOrigin = [window frame].origin;
	
	// Keep the same x position but resize the y position
	float x = currentWindowOrigin.x;
	float y = currentWindowOrigin.y + currentViewSize.height - newViewSize.height;

	// Resize the width and height
	float w = newViewSize.width;
	float h = currentWindowSize.height - currentViewSize.height + newViewSize.height;

	// Set the content to blank
	[window setContentView:[[[NSView alloc] initWithFrame:NSZeroRect] autorelease]];
	
	// Animate the resize
	[window setFrame:NSMakeRect(x, y, w, h) display:YES animate:YES];

	// Set the title to make the label of the sender
	[window setTitle:[sender label]];
	
	// Finally set the content of the window to the new view
	[window setContentView:new_view];
}

// Open the paypal donate link
- (IBAction)donate:(id)sender{
	
	// Tell NSWorkspace to open the paypal link in the default browser
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=donation%40barchard%2enet&item_name=hdhomerunner&no_shipping=1&cn=Optional%20Feedback%3a&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
}

// Choose a new default recording path
- (IBAction)chooseRecordingPath:(id)sender{

	// The panel to open
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	// The User Defaults
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	// The path to open the panel at
	NSString *path = [standardUserDefaults stringForKey:RECORDING_KEY_PATH];

	// Only folders to be selected
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanChooseFiles:NO];
	
	// Set the title of the panel
	[openPanel setTitle:@"Choose Default Recording Folder"];
	
	// Open the panel
	[openPanel beginSheetForDirectory:path
                           file:nil
                          types:nil
                 modalForWindow:window
                  modalDelegate:self
                 didEndSelector:@selector(folderPanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:sender];
}

-(void)folderPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the OK button was selected (as opposed to Cancel)
	if(returnCode == NSOKButton){
			
		// The User Defaults
		/*NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		
		// Set the path chosen to the Recording Path
		[standardUserDefaults setObject:[panel filename] forKey:RECORDING_KEY_PATH];
		
		// Save the changes
		[standardUserDefaults synchronize];*/
		
		NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
	
		[[defaults values] setValue:[panel filename] forKey:RECORDING_KEY_PATH];
	}
}

// Reset the Recording Preferences to their default value
- (IBAction)resetRecordingPreferences:(id)sender{
	// The standard user defaults
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
	
	NSLog(@"defaults = %@", [[defaults defaults] objectForKey:RECORDING_KEY_PATH]);

}


// Clean up
- (void)dealloc{
	
	[toolbarItems release];
	
	[generalView release];
	[updateView release];
	[donateView release];
	
	[window release];

	[super dealloc];
}
@end
