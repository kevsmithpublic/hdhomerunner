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
//  GBPreferenceController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 6/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBPreferenceController.h"


@implementation GBPreferenceController
-(id)init{
	if(self = [super init]){
		[self initWithWindowNibName:@"PrefWindow"];
	}
	
	return self;
}
-(void)awakeFromNib{
	// Set up the preference window's toolbar
	[self setupToolbar];
	[self setView:_generalview];
}

- (void)setupToolbar{
	//NSLog(@"Setting up toolbar");
	
	_update = [[NSToolbarItem alloc] initWithItemIdentifier:@"Update"];
	[_update setAction:@selector(goTo:)];
	[_update setTarget:self];
	
	_donate = [[NSToolbarItem alloc] initWithItemIdentifier:@"Donate"];
	[_donate setAction:@selector(goTo:)];
	[_donate setTarget:self];
	
	_general = [[NSToolbarItem alloc] initWithItemIdentifier:@"General"];
	[_general setAction:@selector(goTo:)];
	[_general setTarget:self];
	
	NSToolbar *toolbar;
	toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbah"];
	[toolbar setDelegate:self];
    
	// Make the toolbar configurable
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setAutosavesConfiguration:NO];
    
	// Attach the toolbar to the window
	[[self window] setToolbar:toolbar];
    
	// toolbar is retained by the window
	[toolbar release];
}

-(IBAction)goTo:(id)sender{
	//NSLog(@"class = %@", [sender className]);
	if([[sender className] isEqualToString:@"NSToolbarItem"]){
		if([[sender itemIdentifier] isEqual:[_donate itemIdentifier]]){
			NSLog(@"Going to pane %@", [sender itemIdentifier]);
			[self setView:_donateview];
		} else if([[sender itemIdentifier] isEqual:[_update itemIdentifier]]){
			NSLog(@"Going to pane %@", [sender itemIdentifier]);
			[self setView:_updateview];
		} else if([[sender itemIdentifier] isEqual:[_general itemIdentifier]]){
			NSLog(@"Going to pane %@", [sender itemIdentifier]);
			[self setView:_generalview];
		}
	}
	
	if([[sender className] isEqualToString:@"NSButton"]){
		if(sender == _donatelink){
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=donation%40barchard%2enet&item_name=hdhomerunner&no_shipping=1&cn=Optional%20Feedback%3a&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
		}
	}
}

-(void)setView:(NSView *)newView{
	if(newView){	
		NSSize currentViewSize = [[[self window] contentView] bounds].size;
		NSSize currentWindowSize = [[self window] frame].size;
		NSSize newViewSize = [newView bounds].size;
		
		NSPoint currentWindowOrigin = [[self window] frame].origin;
		
		float x = currentWindowOrigin.x;//[[self window] frame].origin.x;
		float y = currentWindowOrigin.y + currentViewSize.height - newViewSize.height;//[[self window] frame].origin.y;
	
		float w = newViewSize.width;
		float h = currentWindowSize.height - currentViewSize.height + newViewSize.height;//[newView bounds].size.height;
	
		[[self window] setContentView:[[[NSView alloc] initWithFrame:NSZeroRect] autorelease]];
		[[self window] setFrame:NSMakeRect(x, y, w, h) display:YES animate:YES];
	
		//[[self window] setTitle:[[_view window] title]];
		[[self window] setContentView:newView];
	}
}

-(int)DHCP_state{
	return DHCP_state;
}

-(void)setDHCP_state:(int)newState{
	NSLog(@"setting dhcp state");
	
	if(newState){
							
		DHCP_state = newState;
	}
}

/*- (NSToolbarItem *)toolbar:(NSToolbar *)tb
    itemForItemIdentifier:(NSString *)tbit
    willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *tbi;
    
    // I'm setting up all the items identically.
    // Obviously,  you would not.
    
    tbi = [[NSToolbarItem alloc]initWithItemIdentifier:tbit];
    [tbi setAction:@selector(go:)];
    [tbi setTarget:self];
    
    // This is the label that will appear in the toolbar
    [tbi setLabel:tbit];
    
    // This is the label that will appear in the config panel
    [tbi setPaletteLabel:tbit];
    //[tbi setImage:image];

    [tbi autorelease];
    return tbi;
}*/
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
    itemForItemIdentifier:(NSString *)itemIdentifier
    willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
	
    [item setAction:@selector(goTo:)];
    [item setTarget:self];
    
    // This is the label that will appear in the toolbar
    [item setLabel:itemIdentifier];
    
    // This is the label that will appear in the config panel
    //[tbi setPaletteLabel:itemIdentifier];
    //[tbi setImage:image];
	
    return [item autorelease];
}

/*- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:@"Tool 0", @"Tool 1",NSToolbarSeparatorItemIdentifier, @"Tool 4", nil];
}*/
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects:[_general itemIdentifier], [_update itemIdentifier], [_donate itemIdentifier], NSToolbarFlexibleSpaceItemIdentifier, nil];
}

/*- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    NSString *tbit;
    int i;
    
    NSMutableArray *ma = [NSMutableArray array];
    
    // Fill the array with strings
    for (i=0; i <10; i++){
        tbit = [NSString stringWithFormat:@"Tool %d", i];
        [ma addObject:tbit];
    }
    
    // Put in a couple of standard tool bar items
    [ma addObject:NSToolbarSeparatorItemIdentifier];
    [ma addObject:NSToolbarShowColorsItemIdentifier];
    return ma;
}*/
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
				     NSToolbarSpaceItemIdentifier,
				     NSToolbarFlexibleSpaceItemIdentifier,
				     NSToolbarCustomizeToolbarItemIdentifier, nil];
}

// You can also disable toolbar items
/*- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    // Here I am disabling Tool 4
    if ([[theItem itemIdentifier] isEqual:@"Tool 4"]) {
        return NO;
    } else {
        return YES;
    }
}*/

-(void)dealloc{

	[super dealloc];
}
@end
