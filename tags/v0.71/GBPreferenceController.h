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
//  GBPreferenceController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 6/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <Security/Security.h>
//#import <SecurityFoundation/SFAuthorization.h>


@interface GBPreferenceController : NSWindowController {
	IBOutlet	NSView				*_updateview;			// The update view
				NSToolbarItem		*_update;				// The update view's toolbar item
				
	IBOutlet	NSView				*_donateview;			// The donate view
	IBOutlet	NSButton			*_donatelink;			// The button to redirect to Paypal's donate page
				NSToolbarItem		*_donate;				// The donate view's toolbar item
				
	IBOutlet	NSView				*_generalview;			// The general view
				NSToolbarItem		*_general;				// The general view toolbar item
				
				int					DHCP_state;
}
-(int)DHCP_state;
-(void)setDHCP_state:(int)newState;

-(void)setupToolbar;
-(IBAction)goTo:(id)sender;
-(void)setView:(NSView *)newView;

// Toolbar delegate methods
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
@end
