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
#define MAX_NUMBER_OF_RETRIES			12
#define SLEEP_TIME						10000


@implementation GBTuner
- (id)init{
	if(self = [super init]){

		// The properties of the tuner
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		// The channels the receiver can use
		channels = [[NSMutableArray alloc] initWithCapacity:0];
		
		//NSImage *icon = [NSImage imageNamed:@"Network Utility"];
		//[self setIcon:icon];
				
		hdhr = nil;
		cancel_thread = NO;
		is_scanning_channels = NO;
		
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
				
				//[self scanForChannels:[NSNumber numberWithInt:CHANNEL_MAP_US_ALL]];
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
	if(![[self identificationNumber] isEqual:newID]){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"identificationNumber"];
		[properties setObject:newID forKey:@"identificationNumber"];
		[self didChangeValueForKey:@"identificationNumber"];
	}
}

// Get the hdhr device
- (struct hdhomerun_device_t *)hdhr{
	return hdhr;
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
	return [properties objectForKey:@"firmwareVersion"];
}

// Set the firmware version number
- (void)setFirmwareVersion:(NSNumber *)newVersion{
	// If the new version is not the same as the existing version
	if(![[self firmwareVersion] isEqual:newVersion]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"firmwareVersion"];
		[properties setObject:newVersion forKey:@"firmwareVersion"];
		[self didChangeValueForKey:@"firmwareVersion"];
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
		//tmp = [NSString stringWithFormat:@"%u.%u.%u.%u", (tmp_str >> 24) & 0xFF, (tmp_str >> 16) & 0xFF, (tmp_str >> 8) & 0xFF, (tmp_str >> 0) & 0xFF];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [NSString stringWithString:[properties objectForKey:@"target"]];
	}
	
	return tmp;
}

// Set the target address
- (void)setTarget:(NSString *)aTarget{

	// If the new target is not the same as the existing target
	if(![[self target] isEqual:aTarget]){
	
		// Retry the device a few times to make sure the changes are applied
		int retries = 0;
	
		while(retries < MAX_NUMBER_OF_RETRIES){
	
			// Copy the target into a C-String. This works better and gets rid of a compiler warning
			char ip_cstr[64];
			strcpy(ip_cstr, [aTarget UTF8String]);
			
			// Print debug info
			NSLog(@"Trying to set tuner target to: %s", ip_cstr);
		
			// If the device accepts the set target request (response > 0)
			if(hdhomerun_device_set_tuner_target([self hdhr], ip_cstr) == 1){
			
				// Update the properties to reflect the change and remain key value coding compliant
				[self willChangeValueForKey:@"target"];
				[properties setObject:aTarget forKey:@"target"];
				[self didChangeValueForKey:@"target"];
				
				// Changes were made successfully so quit
				retries = MAX_NUMBER_OF_RETRIES;
				
				// Print debug info
				NSLog(@"Target set to: %@", aTarget);
			}
			
			// Sleep momentarily
			usleep(SLEEP_TIME);
			
			// Increment the retry count
			retries++;
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
	if(![[self number] isEqual:aNumber]){
	
		// If the tuner number is between 0 and the MAX_TUNER_NUMBER + 1
		if(([aNumber compare:[NSNumber numberWithInt:(MAX_TUNER_NUMBER + 1)]] == NSOrderedAscending) && 
			(([aNumber compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) || 
			([aNumber compare:[NSNumber numberWithInt:0]] ==NSOrderedSame))){
			
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
	if(![[self signalStrength] isEqual:newStrength]){
	
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
	if(![[self signalToNoiseRatio] isEqual:newSnr]){
	
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
	if(![[self symbolErrorQuality] isEqual:newSeq]){
	
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
-(NSNumber *)channelNumber{
	// Temporary variable to hold the return values from the function
	char *tmp_str;
	NSNumber *tmp;
	
	// Return the channel from the device (hdhomerun_device.h)
	if(hdhomerun_device_get_tuner_channel([self hdhr], &tmp_str) > 0){
		
		// Set the return value stored in tmp_str to tmp
		// previously used: [NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding]
		tmp = [NSNumber numberWithInt:[[NSString stringWithUTF8String:tmp_str] intValue]];
	} else {
		
		// Else return what is in the properties (cached) value
		tmp = [properties objectForKey:@"channel"];
	}
	
	return tmp;
}

// Set the channel
- (void)setChannelNumber:(NSNumber *)newChannel{

	// If the new channel is not the same as the existing channel
	if(![[self channelNumber] isEqual:newChannel]){
	
		// Retry the device a few times to make sure the changes are applied
		int retries = 0;
	
		while(retries < MAX_NUMBER_OF_RETRIES){
	
			// Apply the changes to the device (hdhomerun_device.h) 
			// If the changes were received by the hdhr (response greater than 0),
			if(hdhomerun_device_set_tuner_channel([self hdhr], [[newChannel stringValue] UTF8String]) > 0){
			
				// Update the properties to reflect the change and remain key value coding compliant
				[self willChangeValueForKey:@"channel"];
				[properties setObject:newChannel forKey:@"channel"];
				[self didChangeValueForKey:@"channel"];
				
				// Changes were made successfully so quit
				retries = MAX_NUMBER_OF_RETRIES;
				
				// Print debug info
				NSLog(@"Channel set to: %s", [[newChannel stringValue] UTF8String]);
			}
			
			// Increment the retry count
			retries++;
		}
	}
}

// Set the channel based on the info inside a GBChannel object
- (void)setGBChannel:(GBChannel *)newChannel{
	
	// Set the channel and program numbers
	[self setChannelNumber:[newChannel channelNumber]];
	
	// Then set the program
	[self setProgram:[newChannel program]];
	
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

	// Retry the device a few times to make sure the changes are applied
	int retries = 0;
	
	while(retries < MAX_NUMBER_OF_RETRIES){
	
		// If the new program is not the same as the existing channel
		if(![[self program] isEqual:aProgram]){
		
			// Apply the changes to the device (hdhomerun_device.h) 
			// If the changes were received by the hdhr (response greater than 0),
			if(hdhomerun_device_set_tuner_program([self hdhr], [[aProgram stringValue] UTF8String]) > 0){
			
				// Update the properties to reflect the change and remain key value coding compliant
				[self willChangeValueForKey:@"program"];
				[properties setObject:aProgram forKey:@"program"];
				[self didChangeValueForKey:@"program"];
				
				// Changes were made successfully so quit
				retries = MAX_NUMBER_OF_RETRIES;
				
				// Print debug info
				NSLog(@"Program set to: %s", [[aProgram stringValue] UTF8String]);
			}
			
			// Increment the retry count
			retries++;
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
	
	//if( (hdhr != nil) && ![status_key isEqual:@"Offline"]){
	if(hdhr != nil){

		// The hdhr status struct
		struct hdhomerun_tuner_status_t hdhr_status;
		NSUInteger result = hdhomerun_device_get_tuner_status(hdhr, &hdhr_status);
		
		if(result == 1){
		
			// Update the signal strength
			[self setSignalStrength:[NSNumber numberWithInt:(hdhr_status.signal_to_noise_quality)]];
			
			// Update the signal to noise ratio
			[self setSignalToNoiseRatio:[NSNumber numberWithInt:(hdhr_status.signal_to_noise_quality)]];
			
			// Update the symbol error quality
			[self setSymbolErrorQuality:[NSNumber numberWithInt:(hdhr_status.symbol_error_quality)]];
		}
		
		// Get the firmware version
		NSUInteger tmp_int;
		char *tmp_str;
	
		result = hdhomerun_device_get_version(hdhr, &tmp_str, &tmp_int);
	
		// If we sucessfully got the firmware version of the hdhomerun
		if(result == 1){
		
			// Apply the changes
			[self setFirmwareVersion:[NSNumber numberWithUnsignedInt:tmp_int]];
		}
		
		/*[self willChangeValueForKey:@"seq"];
		 forKey:@"seq"];
		[self didChangeValueForKey:@"seq"];
		
		[self willChangeValueForKey:@"bitrate"];
		[properties setValue:[NSString stringWithFormat:@"%f", (hdhr_status.raw_bits_per_second/10000000.0)] forKey:@"bitrate"];
		[self didChangeValueForKey:@"bitrate"];
		
		[self willChangeValueForKey:@"lock"];
		[properties setValue:[NSString stringWithCString:hdhr_status.lock_str encoding:NSASCIIStringEncoding] forKey:@"lock"];
		[self didChangeValueForKey:@"lock"];*/
	}
	
	/*if(hdhr && ![status_key isEqual:@"Offline"]){
		unsigned int tmp_int;
		char *tmp_str;
	
		int result = 0;
		result = hdhomerun_device_get_version(hdhr, &tmp_str, &tmp_int);
	
		if(result == 1){
			
			[self willChangeValueForKey:@"version"];
			[properties setValue:[NSString stringWithCString:tmp_str encoding:NSASCIIStringEncoding] forKey:@"version"];
			[self didChangeValueForKey:@"version"];
		}
		
		unsigned int tmp = 0;
		tmp = hdhomerun_device_get_device_ip(hdhr);
	
		if(tmp > 0){
			[self willChangeValueForKey:@"address"];
			[properties setValue:[NSString stringWithFormat:@"%u.%u.%u.%u", (tmp >> 24) & 0xFF, (tmp >> 16) & 0xFF,
				(tmp >> 8) & 0xFF, (tmp >> 0) & 0xFF] forKey:@"address"];
			[self didChangeValueForKey:@"address"];
		}
	}*/
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
	}
}

// Get the channels
- (NSArray *)channels{
	return channels;
}

// Set the channels
- (void)setChannels:(NSArray *)newChannels{
	
	// If new array is not null of the same as the existing array
	if(newChannels && ![channels isEqualToArray:newChannels]){
		// Notify we are about to change
		[self willChangeValueForKey:@"channels"];
		//[self willChangeValueForKey:@"channels" withSetMutation:NSKeyValueSetSetMutation usingObjects:[NSSet setWithArray:channels]];
		
		// Make the changes
		[channels setArray:newChannels];
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"channels"];
		//[self didChangeValueForKey:@"channels" withSetMutation:NSKeyValueSetSetMutation usingObjects:[NSSet setWithArray:channels]];
	}
}

- (BOOL)cancelThread{
	return cancel_thread;
}

- (void)setCancelThread:(BOOL)cancel{
	
	cancel_thread = cancel;
}

- (BOOL)isScanningChannels{
	return is_scanning_channels;
}

- (void)setIsScanningChannels:(BOOL)flag{
	
	// Only make changes if needed
	if(flag != is_scanning_channels){
	
		// Notify we are about to change
		[self willChangeValueForKey:@"isScanningChannels"];
		
		is_scanning_channels = flag;
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"isScanningChannels"];
	}
}

- (void)setScanningChannels:(NSNumber *)flag{
	
	[self setIsScanningChannels:[flag boolValue]];
}

#pragma mark -
#pragma mark  Playing and Recording Support
#pragma mark -

- (void)play{
	
	// The number of retries to apply the play command to the tuner
	int retries;
	retries = 0;
	
	// The ip to stream the video to (target ip)
	unsigned int ip;
	ip = hdhomerun_device_get_local_machine_addr(hdhr);
	
	// The ip formatted properly
	NSString *ip_str;
	ip_str = [NSString stringWithFormat:@"%u.%u.%u.%u:%u", (ip >> 24) & 0xFF, (ip >> 16) & 0xFF,
			(ip >> 8) & 0xFF, (ip >> 0) & 0xFF, 1234];
	
	// cstring version of the IP, copied over to send to the device	 
	//char ip_cstr[64];
	//strcpy(ip_cstr, [ip_str UTF8String]);
	
	// We will try to set the target IP to the local machine IP 6 times
	//while(retries < MAX_NUMBER_OF_RETRIES){
		
		// If the target IP is not the IP we want to set the video playback to
		if(![ip_str isEqualToString:[self target]]){
			
			// Set the target
			[self setTarget:ip_str];
		
		}
		
		// Sleep for a few
	//	usleep(SLEEP_TIME);
		
		// Increment the retry count
	//	retries++;
	//}
	
	// Update the status to playing
	[self setCaption:@"Playing..."];
	
	// Print debug info
	//NSLog(@"Local machine IP = %@ cstring IP = %s", ip_str, ip_cstr);
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

// Return YES if the self is equal to the given tuner
- (BOOL)isEqual:(GBTuner *)aTuner{
	
	// Assume the tuners are different
	BOOL result = NO;
	
	// Make sure these attributes are not null
	if(([self identificationNumber] != nil) && 
		([aTuner identificationNumber] != nil) &&
		([self number] != nil) &&
		([aTuner number] != nil)){
		
		// Set the result to the comparison between similar attributes
		if([[self identificationNumber] isEqualToNumber:[aTuner identificationNumber]] 
			&& [[self number] isEqualToNumber:[aTuner number]]){
				
				result = YES;
			}
	}
	
	// Print debug information
	//NSLog(@"GBTuner isEqual? %i self's identification = %@ compared to = %@ self's number = %@ compared to = %@", result, [self identificationNumber], [aTuner identificationNumber], [self number], [aTuner number]);

	return result;
}

#pragma mark -
#pragma mark   Archiving And Copying Support
#pragma mark -

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

#pragma mark -
#pragma mark   NSCopying Protocol
#pragma mark -

// Copy with zone as specified in the NSCopying protocol
- (id)copyWithZone:(NSZone*)zone{

	// Initiate a newNode with the specified zone
	GBTuner *newNode = [[[self class] allocWithZone:zone] init];
	
	// Set new node to be a copy of self's properties
	[newNode setProperties:[self properties]];
	
	// Set the channels to be the same
	[newNode setChannels:[self channels]];
	
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
- (void)addGBChannel:(GBChannel *)aChannel{
	
	// If the channel isn't already in the collection
	if(![[self channels] containsObject:aChannel]){
		
		// Then add it
		
		// Notify we are about to change
		[self willChangeValueForKey:@"channels"];

		// Make the changes
		[channels addObject:aChannel];
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"channels"];
	}
}

// Remove a channel from the collection
- (void)removeGBChannel:(GBChannel *)aChannel{
		
	// Notify we are about to change
	[self willChangeValueForKey:@"channels"];
		
	// Make the changes
	[channels removeObject:aChannel];
		
	// Notify everyone of the change
	[self didChangeValueForKey:@"channels"];
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
	
	[self setIsScanningChannels:YES];
}

// Process channels in a new thread
-(void)processChannels:(NSNumber *)mode{

	// Be a good thread and set up our own autorelease pool
	NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
	
	// Set the channel scanning status BOOL to YES
	/*[self performSelectorOnMainThread:@selector(setScanningChannels:)
						withObject:[NSNumber numberWithBool:YES]
						waitUntilDone:YES];*/
	
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
                             waitUntilDone:NO];
	
	// (Re)set the will cancel BOOL
	cancel_thread = NO;
	
	// Set the channel scanning status BOOL to NO
	[self performSelectorOnMainThread:@selector(setScanningChannels:)
						withObject:[NSNumber numberWithBool:NO]
						waitUntilDone:YES];
	
	// Release the autorelease pool as it isn't needed anymore
	[myAutoreleasePool release];
}

// Return an array of available channels that the tuner is able to lock
- (NSNumber *)numberOfAvailableChannels{
	return [NSNumber numberWithInt:[channels count]];
}

int channelscanCallback(va_list ap, const char *type, const char *str){
	
	// The number of channels to scan
	int *_count;
	
	// The channel scanned
	int *_channel;
	
	// Total number of channels to scan
	int *_total;
	
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
	
	// Print debug info
	NSLog(@"AUTOSCANNING DEBUG INFO: type = %s string = %s, channel = %i", type, str, (*_channel));
	
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
		//NSLog(@"Program with type: %s and string: %s", type, str);
		
		// If the program string is not 'none' then continue
		if(strcmp(str, "none") != 0){
		
			// Get the substring that begins with
			char *first_index = strrchr(str, ':');
		
			// Get the index
			int i = (first_index-str);
			int j = strcspn(str,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
			
			// The string is of the format: 3: 4.1 WTAE-DT
			// The program is any number of digits up to the colon
			NSNumber *program = [NSNumber numberWithInt:[[[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(0, i)] intValue]];
			
			// The description is the range of characters from the first character until the end of the string
			NSString *description = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(j, strlen(str) - j)];
			
			// The channel is stored from the scanning call
			NSNumber *channel = [NSNumber numberWithInt:(*_channel)];
			
			// Create a new channel
			GBChannel *new_channel = [[GBChannel alloc] initWithChannelNumber:channel program:program andDescription:description];

			// Tell the main thread to add the new channel to the collection
			[myself performSelectorOnMainThread:@selector(addGBChannel:)
									withObject:new_channel
									waitUntilDone:false];
			
			// Print debug info
			//NSLog(@"Entire string = %s substring = %s first int = %i last int = %i", str, first_index, i, j);
			//NSLog(@"Channel = %i Program = %@ Description = %@", (*_channel), program, description);
		}
	}
	
	// Return 0 if the thread should be cancelled so the scan can stop
	return ![myself cancelThread];
}

#pragma mark -
#pragma mark  Outlineview Datasource Methods
#pragma mark -

// Return the child of the item at the index
- (id)outlineView:(NSOutlineView *)outlineview child:(int)index ofItem:(id)item{
	
	// NOTE: ? is the ternary operator. It is equivelant to if(){ } else{ }
	// DISCUSSION: http://en.wikipedia.org/wiki/Ternary_operation
	
	// If the item is not null return the objectAtIndex of item
	// Else if item is null return the objectAtIndex of tuners
	
	// Print debug info
	NSLog(@"index = %i item = %@", index, item);

	return [(item ? item : channels) objectAtIndex:index];
}

// Return YES if the item is expandable
- (BOOL)outlineView:(NSOutlineView *)outlineview isItemExpandable:(id)item{

	// The only expandable items are the Tuners. They will have a drop down of all tuneable channels
	//return [(item ? item : tuners) isKindOfClass:[GBTuner class]];
	return NO;
}

// Return the number of children of the item
- (int)outlineView:(NSOutlineView *)outlineview numberOfChildrenOfItem:(id)item{
	
	// Int to hold the result
	int result = [channels count];
	
	// If item is not null
	if(item){
	
		// Set the result to the number of channels of the item
		//result = [item numberOfChannels];
		result = 0;
	}
	
	// Print debugging info
	NSLog(@"item = %@ result = %i", item, result);
	
	return result;
}

// The value for the table column
- (id)outlineView:(NSOutlineView *)outlineview objectValueForTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{

	//NSLog(@"item = %@", item);
	return @"test";
	/*if(item){
	
		// The font to use for the title
		NSFont *title_font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];
	
		// Attributes to use
		NSDictionary *title_attributes = [NSDictionary dictionaryWithObjectsAndKeys:title_font, NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		
		// The title string
		NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:[item title] attributes:title_attributes] autorelease];
		
		// The font to use for the caption
		NSFont *caption_font = [NSFont fontWithName:CAPTION_FONT size:CAPTION_HEIGHT];
		
		// Attributes to use
		NSDictionary *caption_attributes = [NSDictionary dictionaryWithObjectsAndKeys:caption_font, NSFontAttributeName, [NSColor grayColor], NSForegroundColorAttributeName, nil];
		
		// The caption string below the title
		NSAttributedString *caption = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%s", [[item caption] UTF8String]] attributes:caption_attributes] autorelease];
		
		// Append the two attributed strings
		[string appendAttributedString:caption];
		
		// The image
		NSImage *image = [[[NSImage alloc] initWithData:[[NSApp applicationIconImage] TIFFRepresentation]] autorelease];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize( row_height, row_height )];
		
		return [NSDictionary dictionaryWithObjectsAndKeys:image, @"Image", string, @"String", nil];

	}
	
	return item;*/
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tc byItem:(id)item
{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
}


#pragma mark -
#pragma mark   Clean up
#pragma mark -

// Clean up
- (void)dealloc{
	hdhomerun_device_destroy([self hdhr]);

	[properties release];
	
	[channels release];
	
	[self stopUpdateTimer];
	[updateTimer release];

	[super dealloc];
}
@end