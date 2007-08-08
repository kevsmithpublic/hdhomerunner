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
//  GBController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBController.h"

#define HDHOMERUN_VERSION @"20070716"

@implementation GBController
-(id)init{
	if(self = [super init]){
		
		tuners = [[NSMutableArray alloc] initWithCapacity:0];
		channels = [[NSMutableArray alloc] initWithCapacity:0];
		
		fullscreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"fullscreen"];
		autoupdate = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoupdate"];
		
		// vlc handles VLC controls
		NSString *path = [[NSBundle mainBundle] pathForResource:@"launchVLC" ofType:@"scpt"];
		vlc = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
		
		NSString *fwpath = [[NSBundle mainBundle] pathForResource:[@"hdhomerun_firmware_" stringByAppendingString:HDHOMERUN_VERSION] ofType:@"bin"];
		firmware = [[NSData alloc] initWithContentsOfFile:fwpath];
	}
	
	return self;
}

-(void)awakeFromNib{
	NSArray *tmp = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"tuners"]];
	
	NSEnumerator *enumerator = [tmp objectEnumerator];
	
	
	id object;
	
	while(object = [enumerator nextObject]){
		[self addTuner:[[GBTuner alloc] initWithDictionary:object]];
	}
		
	tmp = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"channels"]];
	
	enumerator = [tmp objectEnumerator];
		
	while(object = [enumerator nextObject]){
		[self addChannel:[[GBChannel alloc] initWithDictionary:object]];
	}

	// Discover any new devices
	[self discover:nil];
	
	[self update];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];		
	[nc addObserver:self selector: @selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
	[nc addObserver:self selector: @selector(tunerWillChangeChannel:) name:@"GBTunerWillChangeChannel" object:nil];
}

-(NSArray *)findDevices{
	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	struct hdhomerun_discover_device_t result_list[128];
	
	// Temporary Array to hold the objects
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	// Query the network for devices. Return the number of devices into count and populate the devices into the result list.
	//int count = hdhomerun_discover_find_devices_custom(IP_WILD_CARD, HDHOMERUN_DEVICE_TYPE_TUNER, HDHOMERUN_DEVICE_ID_WILDCARD, result_list, 128);
	int count = hdhomerun_discover_find_devices(HDHOMERUN_DEVICE_TYPE_TUNER, result_list, 128);
	
	// Print the number of devices found.
	NSLog(@"found %d devices", count);
	
	// Loop over all the devices. Create a hddevice with each device we find.
	int i;
	for(i = 0; i < count; i++){
		unsigned int dev_id = result_list[i].device_id;

		[tmp addObject:[[GBTuner alloc] initWithIdentification:dev_id andTuner:0]];
		[tmp addObject:[[GBTuner alloc] initWithIdentification:dev_id andTuner:1]];
	}
	
	return tmp;
}

-(IBAction)discover:(id)sender{
	// Set the IP Wild Card to 0 to autodetect devices with any IP Address
	//unsigned int IP_WILD_CARD = 0;
	NSLog(@"discover");
	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	//struct hdhomerun_discover_device_t result_list[128];
	
	// Start the progress indicator
	[progress_indicator startAnimation:nil];
	
	// Load preferences from disk
	
	// Add new tuners
	NSEnumerator *newdevice_enumerator = [[self findDevices] objectEnumerator];
	
	id new_object;
	id existing_object;
	
	BOOL result;
 
	// While there are discovered tuners
	while ((new_object = [newdevice_enumerator nextObject])) {
		// Assume the new tuner is not already in the tuner array
		result = NO;

		NSEnumerator *existingdevice_enumerator = [tuners objectEnumerator];
		
		// Loop over all the existing tuners
		while(existing_object = [existingdevice_enumerator nextObject]){
			// Compare to see if any of the existing tuners match the new tuners
			if([existing_object isEqual:new_object]){
				// If there is a match set result to YES
				result = YES;
				
				// Enable existing tuner
				[existing_object setStatus:@"Idle"];
			}
		}
		
		// If there isn't a match then add the new tuner to the table
		if(!result){
			[self addTuner:new_object];
		}
	}
	
	[progress_indicator stopAnimation:nil];
}

-(void)update{
	if(autoupdate){
		NSLog(@"update");
		
		NSEnumerator	*enumerator = [tuners objectEnumerator];
		
		GBTuner			*obj;
		
		// Loop over all the existing tuners
		while(obj = [enumerator nextObject]){
			// Compare to see if any of the existing tuners match the new tuners
			if([[[obj properties] valueForKey:@"number"] isEqual:@"0"]){
				// If there is a match set result to YES
				if([[[obj properties] valueForKey:@"version"] compare:HDHOMERUN_VERSION] == NSOrderedAscending){
					NSLog(@"ok upgrade tuner 0");
				}
			}
		}
	}
}

-(NSArray *)tuners{
	return tuners;
}

-(void)setTuners:(NSArray *)newTuners{	
	if(newTuners && ![tuners isEqual:newTuners]){
		[self willChangeValueForKey:@"tuners"];
	
		[tuners autorelease];
		tuners = [newTuners mutableCopy];
	
		[self didChangeValueForKey:@"tuners"];
	}
}

-(void)addTuner:(GBTuner *)newTuner{
	if(newTuner){
		[self willChangeValueForKey:@"tuners"];
		[tuners addObject:newTuner];
		[self didChangeValueForKey:@"tuners"];
	}
}

-(void)addChannel:(GBChannel *)newChannel{
	if(newChannel){
		[self willChangeValueForKey:@"channels"];
		[channels addObject:newChannel];
		[self didChangeValueForKey:@"channels"];
	}
}

-(NSArray *)channels{
	return channels;
}

-(void)setChannels:(NSArray *)newChannels{
	if(newChannels && ![channels isEqual:newChannels]){
		[self willChangeValueForKey:@"channels"];
	
		[channels autorelease];
		channels = [newChannels mutableCopy];
	
		[self didChangeValueForKey:@"channels"];
	}
}

-(BOOL)fullscreen{
	return fullscreen;
}

-(void)setFullscreen:(BOOL)newState{
	if(newState != fullscreen){
		[self willChangeValueForKey:@"fullscreen"];
	
		fullscreen = newState;
	
		[self didChangeValueForKey:@"fullscreen"];
	}
}

-(BOOL)autoupdate{
	return autoupdate;
}

-(void)setAutoupdate:(BOOL)newState{
	if(newState != autoupdate){
		[self willChangeValueForKey:@"autoupdate"];
	
		autoupdate = newState;
	
		[self didChangeValueForKey:@"autoupdate"];
	}
}

-(IBAction)importChannels:(id)sender{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *fileTypes;

	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:NO];
		
	if(sender == importhdhrcontrol){
	
		fileTypes = [NSArray arrayWithObjects:@"plist",nil];
		[openPanel setTitle:@"Import HDHRControl Channel File"];
	} else if(sender == importxml){
	
		fileTypes = [NSArray arrayWithObjects:@"xml",nil];
		[openPanel setTitle:@"Import XML Channel File"];
	}
	
	[openPanel beginSheetForDirectory:nil
                           file:nil
                          types:fileTypes
                 modalForWindow:_mainWindow
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:nil];
	

}

-(IBAction)exportChannels:(id)sender{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	
	[savePanel setCanCreateDirectories:YES];
	
	if(sender == exporthdhrcontrol){
	
		[savePanel setRequiredFileType:@"plist"];
		[savePanel setTitle:@"Export HDHRControl Channel File"];
	} else if(sender == exportxml){
	
		[savePanel setRequiredFileType:@"xml"];
		[savePanel setTitle:@"Export XML Channel File"];
	}
	
	[savePanel beginSheetForDirectory:nil
                           file:nil
                 modalForWindow:_mainWindow
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:nil];
}

-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	if (returnCode == NSOKButton){
		if([[panel title] isEqualToString:@"Import HDHRControl Channel File"]){
		
			NSArray *anArray = [NSArray arrayWithContentsOfFile:[panel filename]];
			
			// Add new channels
			NSEnumerator *newchannel_enumerator = [anArray objectEnumerator];
	
			id new_object;
			id existing_object;
	
			BOOL result;
 
			// While there are discovered tuners
			while ((new_object = [newchannel_enumerator nextObject])) {
				// Assume the new tuner is not already in the tuner array
				result = NO;
				
				NSArray *values =	[NSArray arrayWithObjects:[new_object objectForKey:@"Description"], 
									[new_object objectForKey:@"Channel"],
									[new_object objectForKey:@"Program"], nil];
									 
				NSArray *keys = [NSArray arrayWithObjects:	@"description",
															@"channel",
															@"program", nil];
															
				NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
				
				GBChannel *tmp = [[GBChannel alloc] initWithDictionary:dict];

				NSEnumerator *existingchannel_enumerator = [channels objectEnumerator];
		
				// Loop over all the existing tuners
				while(existing_object = [existingchannel_enumerator nextObject]){
					// Compare to see if any of the existing tuners match the new tuners
					if([existing_object isEqual:tmp]){
						// If there is a match set result to YES
						result = YES;
					}
				}
		
				// If there isn't a match then add the new tuner to the table
				if(!result){
					[self addChannel:tmp];
				}
			}
	
		
			//NSLog(@"ended import");
		} else if([[panel title] isEqualToString:@"Export HDHRControl Channel File"]){
			
			//NSArray *anArray = [channels copy];
			NSEnumerator *enumerator = [channels objectEnumerator];
			NSMutableArray *channelArray = [NSMutableArray arrayWithCapacity:0];
			
			GBChannel *object;
 
			while ((object = [enumerator nextObject])) {
				NSDictionary *channelDictionary = [NSDictionary dictionaryWithObjectsAndKeys:	[[object properties] objectForKey:@"channel"], @"Channel",
																								[[object properties] valueForKey:@"description"], @"Description",
																								[[object properties] objectForKey:@"program"], @"Program", nil];
				
				[channelArray addObject:channelDictionary];
			}
			
			[channelArray writeToFile:[panel filename] atomically:YES];
		
			//NSLog(@"ended export");
		}
	}
}

-(void)tunerWillChangeChannel:(NSNotification *)notification{
	NSLog(@"tuner will change channel");
	//[_tunercontroller setSelectionIndexes:[_tunerview selectedRowIndexes]];
	//[_channelcontroller setSelectionIndexes:[_channelview selectedRowIndexes]];
	NSLog(@"huh = %@", [_channelview selectedRowIndexes]);
	[[[_tunercontroller selectedObjects] objectAtIndex:0] setChannel:[[_channelcontroller selectedObjects] objectAtIndex:0]];
}

-(IBAction)playChannel:(id)sender{
		// create the first (and in this case only) parameter
         // note we can't pass an NSString (or any other object
         // for that matter) to AppleScript directly,
         // must convert to NSAppleEventDescriptor first
         NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithBoolean:fullscreen];
         // create and populate the list of parameters
         // note that the array starts at index 1
         NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
         [parameters insertDescriptor:firstParameter atIndex:1];
         // create the AppleEvent target
         ProcessSerialNumber psn = { 0, kCurrentProcess };
         NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                  bytes:&psn
                                                                  length:sizeof(ProcessSerialNumber)];
         // create an NSAppleEventDescriptor with the method name
         // note that the name must be lowercase (even if it is uppercase in AppleScript)
         NSAppleEventDescriptor *handler = [NSAppleEventDescriptor descriptorWithString:[@"launchvlc" lowercaseString]];
         // last but not least, create the event for an AppleScript subroutine
         // set the method name and the list of parameters
         NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                 eventID:kASSubroutineEvent
                                                                 targetDescriptor:target
                                                                 returnID:kAutoGenerateReturnID
                                                                 transactionID:kAnyTransactionID];
         [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
         [event setParamDescriptor:parameters forKeyword:keyDirectObject];
		 NSDictionary *errors = [NSDictionary dictionary];
	
	// at last, call the event in AppleScript
	if(![vlc executeAppleEvent:event error:&errors]){
		NSLog(@"errored %@", [errors description]);
	}
	
	[[[_tunercontroller selectedObjects] objectAtIndex:0] setChannel:[[_channelcontroller selectedObjects] objectAtIndex:0]];
	[[[_tunercontroller selectedObjects] objectAtIndex:0] playChannel];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
	//NSLog(@"will terminate");
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
	
	NSEnumerator *enumerator = [tuners objectEnumerator];
	
	
	id object;
	
	while(object = [enumerator nextObject]){
		[tmp addObject:[object properties]];
	}
	
	[standardUserDefaults setObject:tmp forKey:@"tuners"];
	
	[tmp removeAllObjects];
	
	enumerator = [channels objectEnumerator];
		
	while(object = [enumerator nextObject]){
		[tmp addObject:[object properties]];
	}
	
	[standardUserDefaults setObject:tmp forKey:@"channels"];
	[standardUserDefaults setBool:fullscreen forKey:@"fullscreen"];
	
	[standardUserDefaults synchronize];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver: self];

	[tuners release];
	[channels release];

	[super dealloc];
}
@end
