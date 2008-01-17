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
//  GBWindowController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>
#import <Carbon/Carbon.h>

#import "GBTuner.h"
#import "DBListSplitView.h"
#import "DBSourceSplitView.h"

// Declare classes
@class DSGeneralOutlineView;

@interface GBWindowController : NSWindowController {

		// Main window elements
		IBOutlet		DBListSplitView			*tunerSplitView;
		//IBOutlet		NSWindow				*window;
		IBOutlet		NSView					*sourceListViewPlaceholder;
		IBOutlet		NSView					*currentViewPlaceholder;
		IBOutlet		DBSourceSplitView		*splitView;
		
		// The menu item associated with importing HDHomeRunControl ChannelMaps
		IBOutlet		NSMenuItem				*importhdhrcontrol;				
	
		// The menu item associated with exporting HDHomeRunControl ChannelMaps
		IBOutlet		NSMenuItem				*exporthdhrcontrol;
		
		// Source List View
		IBOutlet		NSView					*sourceListView;

		// The tuner to get the data from
						GBTuner					*tuner;	
		
		// The view
		IBOutlet		NSView					*_view;

		// The webview to show the channel's URL
		IBOutlet		WebView					*_web;
		
		// The outline view
		IBOutlet		DSGeneralOutlineView	*channelListOutlineView;
		
		// The content view
		IBOutlet		NSView					*contentViewPlaceHolder;
		
		// Control items
		IBOutlet		NSButton				*_add;
		IBOutlet		NSButton				*_remove;
		IBOutlet		NSButton				*_refresh_channels;
		
		// Option items
		IBOutlet		NSPopUpButton			*_channelscan_mode;
		
		// The toolbar items
						NSToolbar				*theToolbar;
						NSMutableDictionary		*toolbarItems;
		
		// The script to launch and control VLC
					NSAppleScript				*vlc;

}
- (NSView *)view;
- (void)updateWebView:(GBChannel *)aChannel;

- (void)reloadAllChannelData;
- (void)reloadChannelData:(GBChannel *)aChannel;

- (void)changeContentView:(NSView *)newView;
- (void)changeCurrentView:(NSView *)newView;
- (void)removeSubview;
- (void)channelsChanged:(NSNotification *)notification;

- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)refresh:(id)sender;

- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString;
- (void)setTuner:(GBTuner *)aTuner;
- (GBTuner *)tuner;

// File Panel to import/export Channels
-(IBAction)importChannels:(id)sender;
-(IBAction)exportChannels:(id)sender;
-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// Toolbar delegate methods
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;

// Toolbar actions
- (IBAction)play:(id)sender;
- (IBAction)fullscreen:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)getInfo:(id)sender;
- (IBAction)refreshDevices:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)record:(id)sender;

@end
