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
//  GBController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <WebKit/WebKit.h>

#import "GBOutlineViewController.h"

#import "GBTunerViewController.h"
#import "GBTuner.h"

#import "GBChannelViewController.h"
#import "GBChannel.h"

#import "GBRecordingViewController.h"
#import "GBRecording.h"

#import "GBAboutBox.h"

#import "GBPreferences.h"

#import "hdhomerun.h"

#import "DBListSplitView.h"
#import "DBSourceSplitView.h"

@interface GBController : NSObject < SubviewTableViewControllerDataSourceProtocol > {


	// Main window elements
	IBOutlet		NSWindow				*window;
	IBOutlet		DBSourceSplitView		*sourceSplitView;
	IBOutlet		DBListSplitView			*contentSplitView;
	
	// The webview showing the channel's homepage
	IBOutlet		WebView					*webView;
	IBOutlet		NSSegmentedControl		*segmentedControl;
	
	// The outline view showing the tuners
	IBOutlet		NSOutlineView			*tunerOutlineView;
	IBOutlet		NSTableColumn			*tunerTableColumn;
	
	// Tuner view controller and tuner array
					GBOutlineViewController	*tunerOutlineViewController;
					NSMutableArray			*tunerControllers;
					
	// The outline view showing the channels
	IBOutlet		NSOutlineView			*channelOutlineView;
	IBOutlet		NSTableColumn			*channelTableColumn;
	
	
	// Tuner view controller and tuner array
					GBOutlineViewController	*channelOutlineViewController;
					NSMutableArray			*channelControllers;
					
	// The toolbar items
					NSToolbar				*theToolbar;
					NSMutableDictionary		*toolbarItems;
		
	// The script to launch and control VLC
					NSAppleScript			*vlc;
					
	// The menu item associated with importing HDHomeRunControl ChannelMaps
	IBOutlet		NSMenuItem				*importhdhrcontrol;				
	
	// The menu item associated with exporting HDHomeRunControl ChannelMaps
	IBOutlet		NSMenuItem				*exporthdhrcontrol;
	
	// Control items to add, remove, and refresh the channels
	IBOutlet		NSSegmentedControl		*channelSegmentedControl;
	
	// The menu to choose the channel scan mode
					NSMenu					*channelScanMenu;
	IBOutlet		NSMenuItem				*channelScanMenuItem;
	
	// The currently selected tuner
					GBTuner					*selectedTuner;
					
	// The tuner's menu items
					NSMenuItem				*tunerPlay;
					NSMenuItem				*tunerScan;
					
	// Recording view controller and recording array
					GBOutlineViewController	*recordingOutlineViewController;
					NSMutableArray			*recordingControllers;
	
	// The outline view showing the channels
	IBOutlet		NSOutlineView			*recordingOutlineView;
	IBOutlet		NSTableColumn			*recordingTableColumn;
}

// Accessor Methods
- (NSMutableArray *)tunerControllers;
- (NSMutableArray *)channelControllers;
- (NSMutableArray *)recordingControllers;

// Add a controller to the array
- (void)addViewController:(GBViewController *)controller toArray:(NSMutableArray *)array;

// Remove a controller from the array
- (void)removeViewController:(GBViewController *)controller fromArray:(NSMutableArray *)array;

// Add a tuner controller
- (void)addTunerController:(GBTunerViewController *)controller;

// Remove a tuner controller
- (void)removeTunerController:(GBTunerViewController *)controller;

// Construct a new tuner controller for the tuner and add it to the collection
- (void)addTuner:(GBTuner *)tuner;

// Remove the tuner from the array
- (void)removeTuner:(GBTuner *)tuner;

// Discover any tuners on the network
- (NSArray *)discoverTuners;

// If the selected row in the table is greater than -1 return the tuner at that index. Otherwise return nil.
- (GBTuner *)selectedTuner;

// Set the selected tuner
- (void)setSelectedTuner:(GBTuner *)aTuner;

// Add a channel controller
- (void)addChannelController:(GBChannelViewController *)controller;

// Remove a channel controller
- (void)removeChannelController:(GBChannelViewController *)controller;

// Construct a new channel controller for the channel and add it to the collection
- (void)addChannel:(GBChannel *)channel;

// Remove the channel from the array
- (void)removeChannel:(GBChannel *)channel;

// Return the selected channel in the table
- (GBChannel *)selectedChannel;

// Return the channel at the index
- (GBChannel *)channelAtIndex:(NSUInteger)index;

// Toolbar delegate methods
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;

// Toolbar actions
- (void)launchVLC;
- (void)playChannel:(GBChannel *)channel;
- (IBAction)play:(id)sender;
- (IBAction)fullscreen:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)getInfo:(id)sender;
- (IBAction)refreshDevices:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)record:(id)sender;

// Webview controls
- (void)updateWebSegmentControls;
- (void)updateChannelScanMode:(id)sender;
- (IBAction)changeWebSite:(id)sender;

// Take action based on importing channel menuitem being selected
-(IBAction)importChannels:(id)sender;

// Export a channel map
-(IBAction)exportChannels:(id)sender;

// The callback for the sheet
-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// Channel scanning actions
- (IBAction)refresh:(id)sender;
- (IBAction)modifyChannels:(id)sender;
- (void)updateChannelSegmentControls;
- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo;
- (IBAction)showAboutBox:(id)sender;

// A menuitem for a channel
- (NSMenuItem *)menuItemForChannel:(GBChannel *)channel;

// Add the item to the play menu of the tuner
- (void)addPlayMenuItem:(NSMenuItem *)item toTunerViewController:(GBTunerViewController *)controller;

// Remove the item to the play menu of the tuner
- (void)removePlayMenuItem:(NSMenuItem *)item toTunerViewController:(GBTunerViewController *)controller;

// Add a menu item to the selected tuner controller
- (void)addChannelToPlayMenu:(GBChannel *)channel;

// Remove a menu item to the selected tuner controller
- (void)removeChannelToPlayMenu:(GBChannel *)channel;

// Register as an observer of aTuner
- (void)registerAsObserverForTuner:(GBTuner *)aTuner;

// Unregister as an observer of aTuner
- (void)unRegisterAsObserverForTuner:(GBTuner *)aTuner;

// Register as an observer of a channel
- (void)registerAsObserverForChannel:(GBChannel *)aChannel;

// Unregister as an observer of a channel
- (void)unRegisterAsObserverForChannel:(GBChannel *)aChannel;

// Recording support

// Add a recording controller
- (void)addRecordingController:(GBRecordingViewController *)controller;

// Remove a recording controller
- (void)removeRecordingController:(GBRecordingViewController *)controller;

// Construct a new recording controller for the recording and add it to the collection
- (void)addRecording:(GBRecording *)recording;

// Remove the recording from the array
- (void)removeRecording:(GBRecording *)recording;

// Return the selected recording in the table. Nil if it doesn't exist
- (GBRecording *)selectedRecording;

// Set the recordings to the given array
- (void)setRecordings:(NSArray *)recordings;

// Return the recording at the specified index
- (GBRecording *)recordingAtIndex:(NSUInteger)index;

// Modify the recordings
- (IBAction)modifyRecordings:(id)sender;
@end
