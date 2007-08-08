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

#import "GBPreferenceController.h";
#import "GBTuner.h";
#import "GBChannel.h";
//@class GBTuner;
//@class GBChannel;

@interface GBController : NSObject {
		NSMutableArray							*tuners;
		NSMutableArray							*channels;
				
		IBOutlet	NSMenuItem					*importhdhrcontrol;
		IBOutlet	NSMenuItem					*exporthdhrcontrol;
		IBOutlet	NSMenuItem					*importxml;
		IBOutlet	NSMenuItem					*exportxml;
		
		IBOutlet	NSWindow					*_mainWindow;
		
		IBOutlet	NSProgressIndicator			*progress_indicator;
		
		IBOutlet	NSArrayController			*_tunercontroller;
		IBOutlet	NSArrayController			*_channelcontroller;
		//IBOutlet	NSObjectController			*_preferencecontroller;
		
		IBOutlet	NSTableView					*_tunerview;
		IBOutlet	NSTableView					*_channelview;
		
					BOOL						fullscreen;
					BOOL						autoupdate;
					
					NSAppleScript				*vlc;
					
					NSData						*firmware;
}
-(NSArray *)tuners;
-(void)setTuners:(NSArray *)newTuners;

-(void)addTuner:(GBTuner *)newTuner;

-(NSArray *)channels;
-(void)setChannels:(NSArray *)newChannels;

-(BOOL)fullscreen;
-(void)setFullscreen:(BOOL)newState;

-(void)addChannel:(GBChannel *)newChannel;

-(IBAction)importChannels:(id)sender;
-(IBAction)exportChannels:(id)sender;
-(IBAction)discover:(id)sender;
-(IBAction)playChannel:(id)sender;

-(BOOL)autoupdate;
-(void)setAutoupdate:(BOOL)newState;

-(void)update;

-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

-(void)tunerWillChangeChannel:(NSNotification *)notification;
@end
