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
//  GBTuner.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBTuner.h"

#define	MAX_TUNER_NUMBER				1
#define DEFAULT_UPDATE_TIMER_INTERVAL	1

@implementation GBTuner
- (id)init{
	if(self = [super init]){
		//NSLog(@"init tuner");
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		NSImage *icon = [NSImage imageNamed:@"Network Utility"];
		[self setIcon:icon];
		
		[self setIsExpandable:NO];
		
		hdhr = nil;
		
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_UPDATE_TIMER_INTERVAL target:self selector:@selector(update:) userInfo:nil repeats:YES];
	}
	
	return self;
}

- (id)initWithDescription:(NSString *)description identification:(NSString *)anID ip:(NSString *)anIP andNumber:(NSNumber *)aNumber{
	// Call the default init to set up variables
	if(self = [self init]){
	
	}

	return self;
}

- (id)initWithIdentification:(NSNumber *)dev_id andTuner:(NSNumber *)tuner_number{
		// Call the default init to set up variables
		if(self = [self init]){
		
			// If the tuner_number is not less than the MAX_TUNER_NUMBER + 1 and greater than or equal to 0, then default to tuner_number 0
			// Doing it this way will allow room to grow. If SiliconDust releases a HDHomeRun with more than 2 tuners the code can easily be 
			// be updated by changing MAX_TUNER_NUMBER
			if(!(([tuner_number compare:[NSNumber numberWithInt:(MAX_TUNER_NUMBER + 1)]] == NSOrderedAscending) && 
				([tuner_number compare:[NSNumber numberWithInt:0]] == (NSOrderedDescending || NSOrderedSame)))){
			
				// Set tuner_number to 0
				tuner_number = [NSNumber numberWithInt:0];
			}
		
			// If the device id (dev_id) is not nil
			if([dev_id compare:nil] != NSOrderedSame){
				[self setIdentification:dev_id];
				[self setDescription:[dev_id stringValue]];
				[self setNumber:tuner_number];
			}
		}

		
		/*if((dev_id != nil)){
			
			
			NSLog(@"creating device with id: %x tuner: %d", dev_id, tuner);
			hdhr = [self deviceWithID:[properties valueForKey:@"identification"] andNumber:[properties valueForKey:@"number"]];
		}*/
		
		return self;
}

// Get properties
- (NSDictionary *)properties{
	return properties;
}

// Set properties
- (void)setProperties:(NSDictionary *)newProperties{
	// Update the properties and remain key value coding compliant
	[self willChangeValueForKey:@"properties"];
	[properties setDictionary:newProperties];
	[self didChangeValueForKey:@"properties"];
}

// Get identification number
- (NSNumber *)identification{
	return [properties objectForKey:@"identification"];
}

// Set identification number
- (void)setIdentification:(NSNumber *)newID{
	// If the new id is not the same as the existing ID
	if([[self identification] compare:newID] != NSOrderedSame){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"identification"];
		[properties setObject:newID forKey:@"identification"];
		[self didChangeValueForKey:@"identification"];
	}
}

// Get the hdhr device
- (struct hdhomerun_device_t *)hdhr{
	return hdhr;//[properties objectForKey:@"hdhr"];
}

// Set the hdhr device
- (void)setHdhr:(struct	hdhomerun_device_t *)aHdhr{
	// If aHdhr is not nil 
	if(aHdhr){
	
		// If hdhr already exists we should properly destroy the device instance
		if([self hdhr]){
		
			// Destroy the device (hdhomerun_device.h)
			hdhomerun_device_destroy([self hdhr]);
		}
		
		// Set the hdhr key to aHdhr and remain key value coding compliant
		[self willChangeValueForKey:@"hdhr"];
		hdhr = aHdhr;
		//[properties setObject:aHdhr forKey:@"hdhr"];
		[self didChangeValueForKey:@"hdhr"];
	}
}

// Get the description
- (NSString *)description{
	return [properties objectForKey:@"description"];
}

// Set the description
- (void)setDescription:(NSString *)aDescription{
	// If the new description is not the same as the existing description
	if([[self description] compare:aDescription] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"description"];
		[properties setObject:aDescription forKey:@"description"];
		[self didChangeValueForKey:@"description"];
	}
}

// Get the IP address
- (NSString *)ip{
	// Temporary variable to hold the return values from the function
	unsigned int tmp_int;
	NSString *tmp;
	
	// Return the ip of the device (hdhomerun_device.h)
	if((tmp_int = hdhomerun_device_get_device_ip([self hdhr])) > 0){
		
		// Set the return value stored in tmp_int to tmp
		tmp = [NSString stringWithFormat:@"%u.%u.%u.%u", (tmp_int >> 24) & 0xFF, (tmp_int >> 16) & 0xFF,
				(tmp_int >> 8) & 0xFF, (tmp_int >> 0) & 0xFF];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [NSString stringWithString:[properties objectForKey:@"ip"]];
	}
	
	return tmp;
}

// Set the IP address
- (void)setIp:(NSString *)aIp{
	// If the new ip is not the same as the existing ip
	if([[self ip] compare:aIp] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"ip"];
		[properties setObject:aIp forKey:@"ip"];
		[self didChangeValueForKey:@"ip"];
	}
}

// Get the firmware version number
- (NSNumber *)firmwareVersion{
	return [properties objectForKey:@"version"];
}

// Set the firmware version number
- (void)setFirmwareVersion:(NSNumber *)newVersion{
	// If the new version is not the same as the existing version
	if([[self firmwareVersion] compare:newVersion] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"version"];
		[properties setObject:newVersion forKey:@"version"];
		[self didChangeValueForKey:@"version"];
	}
}

// Get the lock
- (NSString *)lock{
	return [properties objectForKey:@"lock"];
}

// Set the lock
- (void)setLock:(NSString *)aLock{
	// If the new description is not the same as the existing description
	if([[self lock] compare:aLock] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"lock"];
		[properties setObject:aLock forKey:@"lock"];
		[self didChangeValueForKey:@"lock"];
	}
}

// Get the target address
- (NSString *)target{
	// Temporary variable to hold the return values from the function
	char *tmp_str;
	NSString *tmp;
	
	// Return the channel from the device (hdhomerun_device.h)
	if(hdhomerun_device_get_tuner_target([self hdhr], &tmp_str) > 0){
		
		// Set the return value stored in tmp_str to tmp
		// previously used: [NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding]
		tmp = [NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding];
		//tmp = [NSString stringWithFormat:@"%u.%u.%u.%u", (tmp_str >> 24) & 0xFF, (tmp_str >> 16) & 0xFF,
		//		(tmp_str >> 8) & 0xFF, (tmp_str >> 0) & 0xFF];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [NSString stringWithString:[properties objectForKey:@"target"]];
	}
	
	return tmp;
}

// Set the target address
- (void)setTarget:(NSString *)aTarget{
	// If the new target is not the same as the existing target
	if([[self target] compare:aTarget] != NSOrderedSame){
	
		// Copy the target into a C-String. This works better and gets rid of a compiler warning
		char ip_cstr[64];
		strcpy(ip_cstr, [aTarget UTF8String]);
	
		// If the device accepts the set target request (response > 0)
		if(hdhomerun_device_set_tuner_target([self hdhr], ip_cstr) > 0){
		
			// Update the properties to reflect the change and remain key value coding compliant
			[self willChangeValueForKey:@"target"];
			[properties setObject:aTarget forKey:@"target"];
			[self didChangeValueForKey:@"target"];
		}
	}
}

// Get the tuner number
- (NSNumber *)number{
	return [properties objectForKey:@"number"];
}

// Set the tuner number
- (void)setNumber:(NSNumber *)aNumber{
	// If the new number is not the same as the existing number
	if([[self number] compare:aNumber] != NSOrderedSame){
	
		// If the tuner number is between 0 and the MAX_TUNER_NUMBER + 1
		if((([aNumber compare:[NSNumber numberWithInt:(MAX_TUNER_NUMBER + 1)]] == NSOrderedAscending) && 
			([aNumber compare:[NSNumber numberWithInt:0]] == (NSOrderedDescending || NSOrderedSame)))){
			
			// Update the properties to reflect the change and remain key value coding compliant
			[self willChangeValueForKey:@"number"];
			[properties setObject:aNumber forKey:@"number"];
			[self didChangeValueForKey:@"number"];
		}
	}
}

// Get the signal strength
- (NSNumber *)signalStrength{
	return [properties objectForKey:@"strength"];
}

// Set the firmware version number
- (void)setSignalStrength:(NSNumber *)newStrength{
	// If the new strength is not the same as the existing strength
	if([[self signalStrength] compare:newStrength] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"strength"];
		[properties setObject:newStrength forKey:@"strength"];
		[self didChangeValueForKey:@"strength"];
	}
}

// Get the signal to noise ratio
- (NSNumber *)signalToNoiseRatio{
	return [properties objectForKey:@"snr"];
}

// Set the firmware version number
- (void)setSignalToNoiseRatio:(NSNumber *)newSnr{
	// If the new snr is not the same as the existing snr
	if([[self signalToNoiseRatio] compare:newSnr] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"snr"];
		[properties setObject:newSnr forKey:@"snr"];
		[self didChangeValueForKey:@"snr"];
	}
}

// Get the symbol error quality
- (NSNumber *)symbolErrorQuality{
	return [properties objectForKey:@"seq"];
}

// Set the firmware version number
- (void)setSymbolErrorQuality:(NSNumber *)newSeq{
	// If the new seq is not the same as the existing seq
	if([[self symbolErrorQuality] compare:newSeq] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"seq"];
		[properties setObject:newSeq forKey:@"seq"];
		[self didChangeValueForKey:@"seq"];
	}
}

// Get the bitrate
- (NSNumber *)bitrate{
	return [properties objectForKey:@"bitrate"];
}

// Set the bitrate
- (void)setBitrate:(NSNumber *)newBitrate{
	// If the new bitrate is not the same as the existing bitrate
	if([[self bitrate] compare:newBitrate] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"bitrate"];
		[properties setObject:newBitrate forKey:@"bitrate"];
		[self didChangeValueForKey:@"bitrate"];
	}
}

// Get the current channel
-(NSNumber *)channel{
	// Temporary variable to hold the return values from the function
	char *tmp_str;
	NSString *tmp;
	
	// Return the channel from the device (hdhomerun_device.h)
	if(hdhomerun_device_get_tuner_channel([self hdhr], &tmp_str) > 0){
		
		// Set the return value stored in tmp_str to tmp
		// previously used: [NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding]
		tmp = [NSString stringWithUTF8String:tmp_str];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [NSString stringWithString:[properties objectForKey:@"channel"]];
	}
	
	return [NSNumber numberWithInt:[tmp intValue]];
}

// Set the channel
- (void)setChannel:(NSNumber *)newChannel{
	// If the new channel is not the same as the existing channel
	if([[self channel] compare:newChannel] != NSOrderedSame){
	
		// Apply the changes to the device (hdhomerun_device.h) 
		// If the changes were received by the hdhr (response greater than 0),
		if(hdhomerun_device_set_tuner_channel([self hdhr], [[newChannel stringValue] UTF8String]) > 0){
		
			// Update the properties to reflect the change and remain key value coding compliant
			[self willChangeValueForKey:@"channel"];
			[properties setObject:newChannel forKey:@"channel"];
			[self didChangeValueForKey:@"channel"];
		}
	}
}

// Get the program
- (NSNumber *)program{
	// Temporary variable to hold the return values from the function
	char *tmp_str;
	NSString *tmp;
	
	// Return the channel from the device (hdhomerun_device.h)
	if(hdhomerun_device_get_tuner_program([self hdhr], &tmp_str) > 0){
		
		// Set the return value stored in tmp_str to tmp
		// previously used: [NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding]
		tmp = [NSString stringWithUTF8String:tmp_str];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [NSString stringWithString:[properties objectForKey:@"program"]];
	}
	
	return [NSNumber numberWithInt:[tmp intValue]];
}

// Set the program
- (void)setProgram:(NSNumber *)aProgram{
	// If the new program is not the same as the existing channel
	if([[self program] compare:aProgram] != NSOrderedSame){
	
		// Apply the changes to the device (hdhomerun_device.h) 
		// If the changes were received by the hdhr (response greater than 0),
		if(hdhomerun_device_set_tuner_channel([self hdhr], [[aProgram stringValue] UTF8String]) > 0){
		
			// Update the properties to reflect the change and remain key value coding compliant
			[self willChangeValueForKey:@"program"];
			[properties setObject:aProgram forKey:@"program"];
			[self didChangeValueForKey:@"program"];
		}
	}
}

// Start the update timer
- (void)startUpdateTimer{
	// If the timer is not valid
	if(![updateTimer isValid]){
	
		// Fire (start) the timer
		[updateTimer fire];
	}
}

// Stop the update timer
- (void)stopUpdateTimer{
	// If the timer is valid
	if([updateTimer isValid]){
	
		// Invalidate (stop) the timer
		[updateTimer invalidate];
	}
}

// Get the update interval (in seconds)
- (NSTimeInterval)updateInterval{
	return [updateTimer timeInterval];
}

// Set the update timer interval
- (void)setUpdateInterval:(NSTimeInterval)newTime{
	
	// If the newTime interval is greater than 0 and not equal to the existing update interval
	if((newTime > 0) && (newTime != [self updateInterval])){
	
		// Set timer_active to YES if updateTimer is currently firing in the runloop
		bool timer_active = [updateTimer isValid];
		
		// If the timer is currently active
		if(timer_active){
		
			// Stop the timer
			[self stopUpdateTimer];
		}
		
		// Set up the new timer
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:newTime target:self selector:@selector(update:) userInfo:nil repeats:YES];
		
		// If the timer was active
		if(timer_active){
		
			// Restart the timer
			[self startUpdateTimer];
		}
	}
}

// The update selector is called whenever a timer is fired.
// We will use this method to update all the properties of the tuner to the current state
- (void)update:(NSTimer*)theTimer{

}

#pragma mark - GBParent Protocol Methods

- (id)initChild{
	if(self = [self init]){
		[self setIsChild:YES];
	}
	
	return self;
}

- (BOOL)isChild{
	return [[properties objectForKey:@"isChild"] boolValue];
}

- (void)setIsChild:(BOOL)flag{
	if(flag != [self isChild]){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"isChild"];
		[properties setObject:[NSNumber numberWithBool:flag] forKey:@"isChild"];
		[self didChangeValueForKey:@"isChild"];
	}
}

- (NSMutableArray *)children{
	return nil;
}

- (void)setChildren:(NSArray *)newContents{

}

- (int)numberOfChildren{
	return 0;
}

- (NSImage *)icon{
	return [properties objectForKey:@"icon"];
}

- (void)setIcon:(NSImage *)newImage{
	// If the new icon is not the same as the existing icon
	if([[self icon] isEqual:newImage] != NSOrderedSame){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"icon"];
		[properties setObject:newImage forKey:@"icon"];
		[self didChangeValueForKey:@"icon"];
	}
}

- (NSString *)title{
	return [self description];
}

- (void)setTitle:(NSString *)newTitle{
	[self setDescription:newTitle];
}

- (NSComparisonResult)compare:(<GBParent> *)aParent{
	return NSOrderedSame;
}

// Return YES if the tuner is equal to the given aParent
- (BOOL)isEqual:(GBTuner <GBParent> *)aParent{
	return ([[self description] isEqualToString:[aParent description]] &&
			[[self title] isEqualToString:[aParent title]] &&
			[[self identification] isEqualToNumber:[aParent identification]] && 
			[[self number] isEqualToNumber:[aParent number]]);
}

// Get isExpandable
- (BOOL)isExpandable{
	return [[properties objectForKey:@"isExpandable"] boolValue];
}

// Set isExpandable
- (void)setIsExpandable:(BOOL)newState{
	if([self isExpandable] != newState){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"isExpandable"];
		[properties setObject:[NSNumber numberWithBool:newState] forKey:@"isExpandable"];
		[self didChangeValueForKey:@"isExpandable"];
	}
}

#pragma mark - Archiving And Copying Support

- (id)initWithDictionary:(NSDictionary*)dictionary{
	
	// Call the default init
	if(self = [self init]){
	
		// Set the properties to the dictionary
		[self setProperties:dictionary];		
	}
	
	// If the title is null we should set it to be the same as the description (if it isn't null)
	/*if(![self title]){
	
		// Make sure the description isn't null
		if([self description]){
		
			// Set the title
			[self setTitle:[self description]];
			
		} else {
			
			// Else the title and description are null and should be something.. more friendly
			[self setTitle:@"Untitled"];
			[self setDescription:@"Untitled"];
		}
	}*/

	return self;
}

- (NSDictionary*)dictionaryRepresentation{
	return properties;
}

#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder*)coder{
	// Initialize
	if(self = [self init]){
	
		// Make sure the archive has a key for Controller
		if([coder containsValueForKey:@"Tuner"]){
			
			// Initialize with the archived dictionary
			[self initWithDictionary:[coder decodeObjectForKey:@"Tuner"]];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder{

	// Encode the object into the coder
	[coder encodeObject:properties forKey:@"Tuner"];
}

#pragma mark - NSCopying Protocol

// Copy with zone as specified in the NSCopying protocol
- (id)copyWithZone:(NSZone*)zone{

	// Initiate a newNode with the specified zone
	GBTuner *newNode = [[[self class] allocWithZone:zone] init];
	
	// Set new node to be a copy of self's properties
	[newNode setProperties:[self properties]];
	
	return newNode;
}

// Set the nil value for an empty title and description
- (void)setNilValueForKey:(NSString*)key{

	// If the empty key is the title or description
	if ([key isEqualToString:@"title"] || [key isEqualToString:@"description"]){
		
		// Set the key to a default value. In this case "Untitled"
		[properties setObject:@"Untitled" forKey:key];
	} else{
	
		// Else call the super's setNilValueForKey
		[super setNilValueForKey:key];
	}
}

#pragma mark - Channel Scanning Support

// Build a channel list for the channel count
- (NSNumber *)numberOfAvailableChannels{
	
	// The total number of channels
	int count = 0;
	
	// The channel number
	//int channel = 0;
	
	//
	//NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
	
	// This is an expensive process and should not up other processes
	[NSThread detachNewThreadSelector:	@selector(executeChannelScan:)	// method to detach in a new thread
										toTarget:self					// we are the target
										withObject:[NSNumber numberWithInt:HDHOMERUN_CHANNELSCAN_MODE_CHANNELLIST]];
	
	// Tell the device to execute a channel scan
	//channelscan_execute_all(hdhr, HDHOMERUN_CHANNELSCAN_MODE_CHANNELLIST, &channelscanCallback, &count, &channel, nil, nil, nil); 
	
	return [NSNumber numberWithInt:count];
}

- (void)executeChannelScan:(NSNumber *)mode{
	
	// Set up the autorelease pool for the thread
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int result = 0;
	
	// The total number of channels scanned
	int count = 0;
	
	// The channel number to scan
	int channel = 0;
	
	// The program number to scan
	int program = 0;
	
	// The channel data to return
	NSMutableArray	*data;
	
	// Tell the device to execute a channel scan
	result = channelscan_execute_all(hdhr, [mode intValue], &channelscanCallback, &count, &channel, &program, data);

	// release the pool
	[pool release];
}

// Return an array of available channels that the tuner is able to lock
- (NSArray *)availableChannels{
	return nil;
}

int channelscanCallback(va_list ap, const char *type, const char *str){
	return 0;
}

#pragma mark - Clean up

// Clean up
- (void)dealloc{
	hdhomerun_device_destroy([self hdhr]);

	[properties release];
	
	[self stopUpdateTimer];
	[updateTimer release];

	[super dealloc];
}
@end
