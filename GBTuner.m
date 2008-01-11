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

		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		//NSImage *icon = [NSImage imageNamed:@"Network Utility"];
		//[self setIcon:icon];
				
		hdhr = nil;
		cancel_thread = NO;
		
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_UPDATE_TIMER_INTERVAL target:self selector:@selector(update:) userInfo:nil repeats:YES];
	}
	
	return self;
}

// Initialize a tuner with a device id and tuner number
- (id)initWithIdentificationNumber:(NSNumber *)dev_id andTunerNumber:(NSNumber *)tuner_number{
		
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
		
			// Make sure the device id (dev_id) is not nil
			if([dev_id unsignedIntValue]){
				
				// Then set the identification number to the device id
				[self setIdentificationNumber:dev_id];
				
				// Set the title to use the same value as the identification
				[self setTitle:[NSString stringWithFormat:@"%x", [dev_id unsignedIntValue]]];
				
				// Set the caption too
				[self setCaption:@"Idle"];
				
				// Set the tuner number
				[self setNumber:tuner_number];
				
				// Create the actual device
				hdhr = [self deviceWithIdentificationNumber:dev_id andTunerNumber:tuner_number];
				
				// Set the status
				//NSLog(@"number of channels = %@", [self numberOfPossibleChannels]);
				//NSLog(@"mode = %i", CHANNEL_MAP_US_ALL);
				
				[self scanForChannels:[NSNumber numberWithInt:CHANNEL_MAP_US_ALL]];
			}
		}

		
		return self;
}


// Return an hdhomerun device created with the device id and tuner number
- (struct hdhomerun_device_t	*)deviceWithIdentificationNumber:(NSNumber *)id_number andTunerNumber:(NSNumber *)tuner_number{
	
	// Initialize the return value to nil
	struct hdhomerun_device_t	*val = nil;

	// Make sure the identification and tuner numbers are not nil and the tuner number is in the appropriate range
	if(id_number && 
				([tuner_number compare:[NSNumber numberWithInt:(MAX_TUNER_NUMBER + 1)]] == NSOrderedAscending) && 
				(([tuner_number compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) ||
				([tuner_number compare:[NSNumber numberWithInt:0]] == NSOrderedSame))
				){
		
		// The formatted string to send to the device
		NSString *dev_str = [NSString stringWithFormat:@"%x-%i", [id_number unsignedIntValue], [tuner_number intValue]];
		
		// The actual c string to send to the device
		char tmp[64];
		
		// Copy the characters into the c string. Compiler complains if you don't first copy the characters into
		// a string rather than sending the UTF8String directly
		strcpy(tmp, [dev_str UTF8String]);
		
		// Print the formatted string
		//NSLog(@"tmp = %s", tmp);
		
		val = hdhomerun_device_create_from_str(tmp);
	}
	
	return val;
}

#pragma mark -
#pragma mark  Accessor Methods
#pragma mark -

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
- (NSNumber *)identificationNumber{
	return [properties objectForKey:@"identificationNumber"];
}

// Set identification number
- (void)setIdentificationNumber:(NSNumber *)newID{
	// If the new id is not the same as the existing ID
	if([[self identificationNumber] compare:newID] != NSOrderedSame){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"identificationNumber"];
		[properties setObject:newID forKey:@"identificationNumber"];
		[self didChangeValueForKey:@"identificationNumber"];
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
- (NSString *)location{
	return [properties objectForKey:@"location"];
}

// Set the description
- (void)setLocation:(NSString *)aLocation{

	// If the new description is not the same as the existing description
	if([[self location] compare:aLocation] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"location"];
		[properties setObject:aLocation forKey:@"location"];
		[self didChangeValueForKey:@"location"];
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
		
		// Post a notification that the icon to the tuner changed
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"GBTunerDataChanged" object:self];
	}
}

- (NSString *)title{
	return [properties objectForKey:@"title"];
}

- (void)setTitle:(NSString *)newTitle{
	
	// If the new name is not the same as the existing description
	if(![[self title] isEqualToString:newTitle] && ![newTitle isEqualToString:@""]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"title"];
		[properties setObject:newTitle forKey:@"title"];
		[self didChangeValueForKey:@"title"];
		
		// Post a notification that the title to the tuner changed
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"GBTunerDataChanged" object:self];
	}
}

// Get the caption
- (NSString *)caption{
	return [properties objectForKey:@"caption"];
}

// Set the caption
- (void)setCaption:(NSString *)newCaption{
	
	// If the new caption is not the same as the existing description
	if(![[self caption] isEqualToString:newCaption] && ![newCaption isEqualToString:@""]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"caption"];
		[properties setObject:newCaption forKey:@"caption"];
		[self didChangeValueForKey:@"caption"];
		
		// Post a notification that the caption to the tuner changed
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GBTunerDataChanged" object:self];
	}
}

// Get the channels
- (NSArray *)channels{
	return [properties objectForKey:@"channels"];
}

// Set the channels
- (void)setChannels:(NSArray *)newChannels{
	
	// If new array is not null of the same as the existing array
	if(newChannels && ![[self channels] isEqualToArray:newChannels]){
		// Notify we are about to change
		[self willChangeValueForKey:@"channels"];
		
		// Make the changes
		[properties setObject:newChannels forKey:@"channels"];
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"channels"];
	}
}

- (BOOL)cancelThread{
	return cancel_thread;
}

- (void)setCancelThread:(BOOL)cancel{
	
	cancel_thread = cancel;
}

#pragma mark -
#pragma mark  Comparison Results
#pragma mark -

- (NSComparisonResult)compare:(GBTuner *)aTuner{
	
	// The result to be returned
	int result = NSOrderedSame;
	
	if(![self isEqual:aTuner]){
	
	}
	
	return result;
}

// Return YES if the tuner is equal to the given aParent
- (BOOL)isEqual:(GBTuner *)aTuner{
	
	// Assume the tuners are different
	BOOL result = NO;
	
	// Make sure these attributes are not null
	if([self identificationNumber] && [aTuner identificationNumber]
		&& [self number] && [aTuner number]){
		
		// Set the result to the comparison between similar attributes
		result = ([[self identificationNumber] isEqualToNumber:[aTuner identificationNumber]] 
			&& [[self number] isEqualToNumber:[aTuner number]]);
		
	}
	
	// Print debug information
	//NSLog(@"is equal? %i", result);

	return result;
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

#pragma mark -
#pragma mark  Channel Scanning Support
#pragma mark -

// Add a channel to the collection
- (void)addChannel:(GBChannel *)aChannel{
	
	// If the channel isn't already in the collection
	if(![[self channels] containsObject:aChannel]){
		
		// Then add it
		
		// Notify we are about to change
		[self willChangeValueForKey:@"channels"];
		
		// Make the changes
		[[properties objectForKey:@"channels"] addObject:aChannel];
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"channels"];
		
		// Post a notification that the channels to the tuner changed
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GBTunerChannelAdded" object:self];
	}
}

// Remove a channel from the collection
- (void)removeChannel:(GBChannel *)aChannel{
		
	// Notify we are about to change
	[self willChangeValueForKey:@"channels"];
		
	// Make the changes
	[[properties objectForKey:@"channels"] removeObject:aChannel];
		
	// Notify everyone of the change
	[self didChangeValueForKey:@"channels"];
	
	// Post a notification that the channels to the tuner changed
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GBTunerChannelRemoved" object:self];
}

// Build a channel list for the channel count
- (NSNumber *)numberOfPossibleChannels:(NSNumber *)mode{
	
	// The total number of channels
	int count = 0;
	
	// Tell the device to execute a channel scan
	count = hdhomerun_channel_list_frequency_count([mode intValue]); 
	
	return [NSNumber numberWithInt:count];
}

- (void)scanForChannels:(NSNumber *)mode{

	// Start the process in a new thread
	[NSThread detachNewThreadSelector:@selector(processChannels:)
							toTarget:self
							withObject:mode];

	// Set the caption
	[self setCaption:@"Scanning Channels..."];
}

// Process channels in a new thread
-(void)processChannels:(NSNumber *)mode{

	// Be a good thread and set up our own autorelease pool
	NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
	
	int result = 0;
	
	// The total number of channels scanned
	int count = 0;
	
	// The channel number to scan
	int channel = 0;
	
	// Total number of channels to scan
	int total = [[self numberOfPossibleChannels:mode] intValue];
	
	// The channel data to return
	NSMutableArray	*data;
	
	// Tell the device to execute a channel scan
	result = channelscan_execute_all(hdhr, [mode intValue], &channelscanCallback, &count, &total, &channel, data, self);
	
	// Set the caption back to "Idle" but do this only on the main thread
	[self performSelectorOnMainThread:@selector(setCaption:)
                                withObject:@"Idle"
                             waitUntilDone:false];
							 
	// (Re)set the will cancel BOOL
	cancel_thread = NO;
	
	// Release the autorelease pool as it isn't needed anymore
	[myAutoreleasePool release];
}

// Return an array of available channels that the tuner is able to lock
- (NSArray *)availableChannels{
	return [properties objectForKey:@"channels"];
}

int channelscanCallback(va_list ap, const char *type, const char *str){
	
	// The number of channels to scan
	int *_count;
	
	// The channel scanned
	int *_channel;
	
	// Total number of channels to scan
	int *_total;
	
	// The program scanned
	//int _program;
	
	// The channels collected to return
	NSMutableArray *_data;
	
	// Same as self
	GBTuner *myself;
	
	// Get the variables from the variable argument list
	// These values must be retrieved in the same order they were put on
	
	// The first was the count
	_count = va_arg(ap, int *);
	
	// Total number of available channels
	_total = va_arg(ap, int*);
	
	// Next was the channel number
	_channel = va_arg(ap, int *);
	
	// Finally the collection of channels from the scan
	_data = va_arg(ap, NSMutableArray *);
	
	// So I can make calls to myself
	myself = va_arg(ap, GBTuner *);
	
	//progress = va_arg(ap, NSProgressIndicator *);
	
	//data = va_arg(ap, NSMutableDictionary *);
	//tw = va_arg(ap, ThreadWorker *);
	
	if(strcmp(type, "SCANNING") == 0){
		//NSLog(@"SCANNING with type %s and string %s", type, str); 
		
		// Increase the count
		(*_count)++;
		
		// Calculate the percent complete
		float percent;
		if (*_total == 0)  percent = NAN;
		else  percent = 100.0f * ((float)*_count) / ((float)*_total);
				
		// Print the count
		//NSLog(@"count = %i total = %i percent = %i", (*_count), (*_total), (int)percent);
		
		// Only update every 10th attempt but be sure to include the first attempt
		if((((*_count)%10) == 0) || ((*_count) == 1)){
		
			// Update the status (but do it on the main thread)
			[myself performSelectorOnMainThread:@selector(setCaption:)
									withObject:[NSString stringWithFormat:@"Scanning Channels... %i%%", (int)percent]
									waitUntilDone:false];
		}
		
		// Parse the string (str) for the channel information
		
		// Create a substring of string with the last occurrance of each of the char
		char *first_index = strrchr(str, ':');
		char *last_index = strrchr(str,')');
		
		// Substract the two strings to get the index difference (which is the channel number)
		int i = first_index-str;
		int j = last_index-str;
		
		// Create a new string with this range
		NSString *newchannel_str = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(i+1, j-i-1)];
		
		// Set the channel to the int value of the string
		(*_channel) = [newchannel_str intValue];
		
		// Print debug info
		//NSLog(@"first index = %i last index = %i", first_index-str, last_index-str);
		//NSLog(@"index i = %i index j = %i", i, j);
		//NSLog(@"newchannel_str = %i", [newchannel_str intValue]);
		
	} else if(strcmp(type, "LOCK") == 0){
	
		// Print debug info
		//NSLog(@"LOCK with type %s and string %s", type, str);
		
	} else if(strcmp(type, "PROGRAM") == 0){
		
		// Print debug info
		NSLog(@"Program with type: %s and string: %s", type, str);
		
		// If the program string is not 'none' then continue
		if(strcmp(str, "none") != 0){
		
			// Get the substring that begins with
			char *first_index = strrchr(str, '.');
		
			// Get the index
			int i = (first_index-str);
			int j = strcspn(str,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
			
			NSLog(@"i = %c j = %c", str[i], str[j]);
			
			NSString *program = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(0, i-1)];
			NSString *description = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(j, strlen(str) - j)];
				
			// Print debug info
			NSLog(@"Entire string = %s substring = %s first int = %i last int = %i", str, first_index, i, j);
			NSLog(@"Channel = %i Program = %@ Description = %@", (*_channel), program, description);
		
		}
		
		/*if((first_index != NULL) && (j>0)){//(last_index != NULL)){
			NSString *ns_str = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(0, i-1)];
			NSString *desc_str = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(j, strlen(str) - j)];
		
			NSMutableDictionary *properties;
			properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
			[properties setValue:desc_str forKey:@"description"];
			[properties setObject:[[NSNumber alloc] initWithInt:(*chan)] forKey:@"channel"];
			[properties setObject:[[NSNumber alloc] initWithInt:[ns_str intValue]] forKey:@"program"];
		
			//NSLog(@"properties = %@", properties);
			
			//GBChannel *newChannel = [[GBChannel alloc] initWithDictionary:properties];
			[data addObject:properties];
			//[data addObject:newChannel];
		}*/
	}
	
	// Return 0 if the thread should be cancelled so the scan can stop
	return ![myself cancelThread];
}

#pragma mark -
#pragma mark   Clean up
#pragma mark -

// Clean up
- (void)dealloc{
	hdhomerun_device_destroy([self hdhr]);

	[properties release];
	
	[self stopUpdateTimer];
	[updateTimer release];

	[super dealloc];
}
@end