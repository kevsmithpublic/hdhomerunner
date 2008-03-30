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
//  GBController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "hdhomerun.h"
#import "ThreadWorker.h"
#import "DIController.h"

#import "GBPreferenceController.h";
#import "GBTuner.h";
#import "GBChannel.h";

@interface GBController : NSObject {
		NSMutableArray							*tuners;						// The array of tuners found on the network
		NSMutableArray							*channels;						// The array of channels
		NSMutableArray							*threads;						// An array of threads
		NSMutableArray							*autoscan;						// An array to hold the autoscan results
				
		IBOutlet	NSMenuItem					*importhdhrcontrol;				// The menu item associated with importing HDHomeRunControl ChannelMaps
		IBOutlet	NSMenuItem					*exporthdhrcontrol;				// The menu item associated with exporting HDHomeRunControl ChannelMaps
		IBOutlet	NSMenuItem					*importxml;						// The menu item associated with importing a XML ChannelMap
		IBOutlet	NSMenuItem					*exportxml;						// The menu item associated with exporting a XML ChannelMap
		
		IBOutlet	NSWindow					*_mainWindow;					// The main window
		IBOutlet	NSWindow					*_upgradeWindow;				// The upgrade window
		IBOutlet	NSWindow					*_autoscanSheet;				// The autoscan window
		
		IBOutlet	NSProgressIndicator			*progress_indicator;			// The progress indicator on the main window
		IBOutlet	NSProgressIndicator			*upgrade_progress_indicator;	// The progress indicator on the upgrade window
		IBOutlet	NSTextField					*upgrade_status_field;			// The upgrade status field on the upgrade window
		IBOutlet	NSProgressIndicator			*autoscan_total_level;			// The progress on scanning a given tuner
		
		IBOutlet	NSArrayController			*_tunercontroller;				// The array controller which manages the tuners
		IBOutlet	NSArrayController			*_channelcontroller;			// The array controller which manages the channels
		IBOutlet	NSArrayController			*_autoscancontroller;			// The array controller which manages the results from the autoscan
		
		IBOutlet	NSTableView					*_tunerview;					// The tableview that displays available tuners
		IBOutlet	NSTableView					*_channelview;					// The tableview that displays available channels
		IBOutlet	NSTableView					*_autoscanview;					// The tableview that displays channels discovered by the autoscan feature
		
					BOOL						fullscreen;						// The value that specifies whether VLC should be launched in fullscreen
					BOOL						autoupdate;						// The value that specifies if tuners should be autoupdated.
					
					NSAppleScript				*vlc;							// The script to launch and control VLC
					
					NSURL						*firmware;						// The location of the most up-to-date firmware
					
					NSNumber					*lineuplocation;				// The location to retrieve channel data for
}
-(NSArray *)tuners;
-(void)setTuners:(NSArray *)newTuners;

-(void)addTuner:(GBTuner *)newTuner;

-(NSArray *)channels;
-(void)setChannels:(NSArray *)newChannels;

-(BOOL)fullscreen;
-(void)setFullscreen:(BOOL)newState;

-(void)addChannel:(GBChannel *)newChannel;

-(NSNumber *)lineuplocation;
-(void)setLineuplocation:(NSNumber *)newLocation;

-(IBAction)importChannels:(id)sender;
-(IBAction)exportChannels:(id)sender;
-(IBAction)discover:(id)sender;
-(IBAction)playChannel:(id)sender;

-(BOOL)autoupdate;
-(void)setAutoupdate:(BOOL)newState;

-(void)update;

-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

-(void)tunerWillChangeChannel:(NSNotification *)notification;

-(IBAction)scanChannels:(id)sender;
-(void)autoscanDidFinish:(NSNotification *)notification;

-(void)setAutoscan:(NSArray *)newArray;
-(NSArray *)autoscan;

- (IBAction)doneConfiguring:(id)sender;
@end
