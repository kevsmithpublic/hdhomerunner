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
//  Created by Gregory Barchard on 7/14/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBTuner.h"

#define HDHOMERUN_DEVICE_IP_WILDCARD 0x00000000
#define UPDATE_TIMER_INTERVAL 1

@implementation GBTuner
-(id)init{
	if(self = [super init]){
		NSLog(@"init tuner");
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		[properties setValue:@"New Tuner" forKey:@"description"];
		[properties setValue:@"none" forKey:@"address"];
		[properties setValue:@"none" forKey:@"identification"];
		[properties setValue:@"-" forKey:@"version"];
		[properties setValue:@"none" forKey:@"lock"];
		[properties setValue:@"none" forKey:@"target"];
		[properties setValue:@"0" forKey:@"number"];
		//[properties setValue:@"90210" forKey:@"lineuplocation"];
		[properties setObject:[NSNumber numberWithInt:0] forKey:@"strength"];
		[properties setObject:[NSNumber numberWithInt:0] forKey:@"snr"];
		[properties setObject:[NSNumber numberWithInt:0] forKey:@"seq"];
		[properties setValue:@"0" forKey:@"bitrate"];

		channel = [[GBChannel alloc] init];
				
		status = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"offline" ofType:@"tiff"]], @"Offline",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"idle" ofType:@"tiff"]], @"Idle",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playing" ofType:@"tiff"]], @"Playing",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recording" ofType:@"tiff"]], @"Recording", nil];
		
		status_key = [[NSString alloc] initWithString:@"Offline"]; 
		
		// The tuner
		hdhr = nil;
		
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIMER_INTERVAL target:self selector:@selector(update:) userInfo:nil repeats:YES];
	}
	
	return self;
}

-(id)initWithDictionary:(NSDictionary *)newProperties{
	[self init];
	
	if([newProperties count] > 0){
	
		[properties removeAllObjects];
		[properties setDictionary:newProperties];
		
		hdhr = [self deviceWithID:[properties valueForKey:@"identification"] andNumber:[properties valueForKey:@"number"]];
	}
	
	return self;
}

-(id)initWithIdentification:(unsigned int)dev_id andTuner:(int)tuner{
		[self init];
		
		if((tuner != 0) && (tuner != 1)){
			tuner = 0;
		}
		
		if((dev_id != nil)){
			[self willChangeValueForKey:@"properties"];
			[properties setValue:[NSString stringWithFormat:@"%x", dev_id] forKey:@"identification"];
			[properties setValue:[NSString stringWithFormat:@"%x", dev_id] forKey:@"description"];
			[properties setValue:[NSString stringWithFormat:@"%i", tuner] forKey:@"number"];
			[self didChangeValueForKey:@"properties"];
			
			NSLog(@"creating device with id: %x tuner: %d", dev_id, tuner);
			hdhr = [self deviceWithID:[properties valueForKey:@"identification"] andNumber:[properties valueForKey:@"number"]];
		}
		
		return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
	[self init];

	if([decoder containsValueForKey:@"tuner"]){
	
		[self initWithDictionary:[decoder decodeObjectForKey:@"tuner"]];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:properties forKey:@"tuner"];
}


-(struct hdhomerun_device_t	*)deviceWithID:(NSString *)anID andNumber:(NSString *)aNumber{
	struct hdhomerun_device_t	*val = nil;

	if(![anID isEqualToString:@""] && ([aNumber isEqualToString:@"0"] || [aNumber isEqualToString:@"1"])){//([aNumber isEqualToNumber:[NSNumber numberWithInt:0]] || [aNumber isEqualToNumber:[NSNumber numberWithInt:1]])){
		NSString *dev_str = [[anID stringByAppendingString:@"-"] stringByAppendingString:aNumber];
		
		char tmp[64];
		strcpy(tmp, [dev_str UTF8String]);
		//NSLog(@"tmp = %s", tmp);
		
		val = hdhomerun_device_create_from_str(tmp);
	}
	
	return val;
}

-(BOOL)upgrade:(NSURL *)newFirmware{
	BOOL result = NO;
	
	if(newFirmware){
		int tmp;
		//NSLog(@"trying to upgrade %@", [newFirmware absoluteString]);
		FILE *upgrade_file = fopen([[newFirmware absoluteString] UTF8String], "rb");
		tmp = hdhomerun_device_upgrade(hdhr, upgrade_file);
		
		if(tmp < 1){
			result = NO;
		} else {
			result = YES;
		}
	}
	
	return result;
}

-(NSImage *)status{
	return [status objectForKey:status_key];
}

-(void)setStatus:(NSString *)newStatusKey{
	if(![newStatusKey isEqual:status_key] && [status valueForKey:newStatusKey]){
		[self willChangeValueForKey:@"status"];
		[status_key autorelease];
		status_key = [newStatusKey copy];
		[self didChangeValueForKey:@"status"];
	}
}

-(NSArray *)statusKeys{
	return [status allKeys];
}

-(NSDictionary *)properties{
	return properties;
}

-(void)setProperties:(NSDictionary *)newProperties{	
	[self willChangeValueForKey:@"properties"];
	[properties removeAllObjects];
	[properties addEntriesFromDictionary:newProperties];
	[self didChangeValueForKey:@"properties"];
}

-(void)update:(NSTimer*)timer{
	
	if( (hdhr != nil) && ![status_key isEqual:@"Offline"]){
		// The hdhr status struct
		struct hdhomerun_tuner_status_t hdhr_status;
		hdhomerun_device_get_tuner_status(hdhr, &hdhr_status);
		
		[self willChangeValueForKey:@"strength"];
		[properties setObject:[NSNumber numberWithInt:(hdhr_status.signal_strength/10)] forKey:@"strength"];
		[self didChangeValueForKey:@"strength"];
		
		[self willChangeValueForKey:@"snr"];
		[properties setObject:[NSNumber numberWithInt:(hdhr_status.signal_to_noise_quality/10)] forKey:@"snr"];
		[self didChangeValueForKey:@"snr"];
		
		[self willChangeValueForKey:@"seq"];
		[properties setObject:[NSNumber numberWithInt:(hdhr_status.symbol_error_quality/10)] forKey:@"seq"];
		[self didChangeValueForKey:@"seq"];
		
		[self willChangeValueForKey:@"bitrate"];
		[properties setValue:[NSString stringWithFormat:@"%f", (hdhr_status.raw_bits_per_second/10000000.0)] forKey:@"bitrate"];
		[self didChangeValueForKey:@"bitrate"];
		
		[self willChangeValueForKey:@"lock"];
		[properties setValue:[NSString stringWithCString:hdhr_status.lock_str encoding:NSASCIIStringEncoding] forKey:@"lock"];
		[self didChangeValueForKey:@"lock"];
	}
	
	if(hdhr && ![status_key isEqual:@"Offline"]){
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
	}
	
	// If the tuner is playing show the signal strength in the dock icon
	/*if(hdhr && [status_key isEqual:@"Playing"]){
		
	}*/
}

- (id)startAutoscan:(id)someData worker:(ThreadWorker *)tw{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // pool is created
	
	NSDictionary        *thingsIllNeed;
    NSProgressIndicator *progress;
	NSMutableArray		*data;
	int count = 0;
	int _channel = 0;

	// Get stuff I'll need to talk to on the other thread.
    thingsIllNeed	= (NSDictionary *)someData;
    progress		= (NSProgressIndicator *)[thingsIllNeed objectForKey:@"progress"];
	data			= (NSMutableArray *)[thingsIllNeed objectForKey:@"data"];
	//data			= (NSMutableDictionary *)[thingsIllNeed objectForKey:@"data"];

	channelscan_execute_all(hdhr, HDHOMERUN_CHANNELSCAN_MODE_SCAN, &autoscancallback, &count, &_channel, progress, data, tw);
	
	[pool release];
	//return userInfo; // Will be passed to didEndSelector
	return someData;
}

-(int)numberOfChannelsToScan{
	int count = 0;
	int _channel = 0;
	channelscan_execute_all(hdhr, HDHOMERUN_CHANNELSCAN_MODE_CHANNELLIST, &autoscancallback, &count, &_channel, nil, nil, nil); 
	
	return count;
}

-(void)scanDidFinish:(id)userInfo{
	/*NSDictionary        *thingsIllNeed;
    NSProgressIndicator *progress;

	// Get stuff I'll need to talk to on the other thread.
    thingsIllNeed  = (NSDictionary *)userInfo;
    progress       = (NSProgressIndicator *)[thingsIllNeed objectForKey:@"progress"];

	NSLog(@"autoscan did finish");
	[progress incrementBy:1.0];*/
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"GBTunerAutoscanDidFinish" object:self userInfo:userInfo];
}

int autoscancallback(va_list ap, const char *type, const char *str){
		int *tmp;
		int *chan;
		NSProgressIndicator *progress;
		//NSMutableDictionary *data;
		NSMutableArray *data;
		ThreadWorker	*tw;
		
		tmp = va_arg(ap, int *);
		chan = va_arg(ap, int *);
		progress = va_arg(ap, NSProgressIndicator *);
		data = va_arg(ap, NSMutableArray *);
		//data = va_arg(ap, NSMutableDictionary *);
		tw = va_arg(ap, ThreadWorker *);

		//NSLog(@"chan = %i mem = %i", (*chan), chan);
	
	if(strcmp(type, "SCANNING") == 0){
		//NSLog(@"type: %s", type);
		//NSLog(@"string: %s", str);
		
		(*tmp)++;
		
		char *first_index = strrchr(str, ':');
		char *last_index = strrchr(str,')');
		//NSLog(@"first = %i", first_index-str);
		//NSLog(@"last = %i", last_index-str);
				
		int i = first_index-str;
		int j = last_index-str;
		//NSLog(@"i = %i", i);
		//NSLog(@"j = %i", j);
		
		NSString *ns_str = [[NSString stringWithUTF8String:str] substringWithRange:NSMakeRange(i+1, j-i-1)];
		//NSLog(@"ns_str = %i", [ns_str intValue]);
		
		(*chan) = [ns_str intValue];
		
		[progress incrementBy:1.0];
		[progress displayIfNeeded];
	}
	/*if(strcmp(type, "LOCK") == 0){
		NSLog(@"type: %s", type);
		NSLog(@"string: %s", str);
	}*/
	if(strcmp(type, "PROGRAM") == 0){
		//NSLog(@"type: %s", type);
		//NSLog(@"string: %s", str);
		
		char *first_index = strrchr(str, '.');
		
		int i = first_index-str;
		int j = strcspn(str,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
		//NSLog(@"i = %i", i);
		//NSLog(@"j = %i", j);
		
		if((first_index != NULL) && (j>0)){//(last_index != NULL)){
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
		}
	}

	BOOL result = 1;
	
	if([tw cancelled]){
		result = 0;
	}
	
	return result;
}

-(NSString *)lineuplocation{
	return lineuplocation;
}

-(void)setLineuplocation:(NSString *)newLineuplocation{
	if(![lineuplocation isEqual:newLineuplocation] && [newLineuplocation isEqual:@""]){
		if(hdhomerun_device_set_lineup_location(hdhr, [newLineuplocation UTF8String]) == 1){
			[self willChangeValueForKey:@"lineuplocation"];
			[lineuplocation autorelease];
			lineuplocation = [newLineuplocation copy];
			[self didChangeValueForKey:@"lineuplocation"];
		}
	}
}

-(GBChannel *)channel{
	// Return the current channel of the tuner
	return channel;
}

-(void)setChannel:(GBChannel *)newChannel{
	NSLog(@"channel = %@ newChannel = %@", [[channel properties] valueForKey:@"description"], [[newChannel properties] valueForKey:@"description"]); 
	if(![channel isEqual:newChannel]){
		
		[self willChangeValueForKey:@"channel"];
		//[channel setStatus:@"Offline"];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		//NSLog(@"posting stop playing channel notification");
		[nc postNotificationName:@"GBTunerWillStopPlayingChannel" object:self userInfo:[NSDictionary dictionaryWithObject:channel forKey:@"channel"]];

		[channel autorelease];
		channel = [newChannel copy];//retain];//[newChannel copy];
		[self didChangeValueForKey:@"channel"];
		
		if([status_key isEqual:@"Playing"]){
			[self playChannel];
			//NSLog(@"replay");
		}
		
	}
}

-(void)playChannel{
	
	int retries;
	retries = 0;
	
	unsigned int ip;
	ip = hdhomerun_device_get_local_machine_addr(hdhr);
	
	NSString *ip_str;
	ip_str = [NSString stringWithFormat:@"%u.%u.%u.%u:%u", (ip >> 24) & 0xFF, (ip >> 16) & 0xFF,
			(ip >> 8) & 0xFF, (ip >> 0) & 0xFF, 1234];
	
	NSLog(@"ip = %@", ip_str);
		 
	char ip_cstr[64];
	strcpy(ip_cstr, [ip_str UTF8String]);
	//NSLog(@"ip = %s", ip_cstr);
	NSLog(@"channel = %@", [[[channel properties] objectForKey:@"channel"] stringValue]);
	while(	(!(hdhomerun_device_set_tuner_channel(hdhr, [[[[channel properties] objectForKey:@"channel"] stringValue] UTF8String]) > 0) ||
			!(hdhomerun_device_set_tuner_program(hdhr, [[[[channel properties] objectForKey:@"program"] stringValue] UTF8String]) > 0) ||
			!(hdhomerun_device_set_tuner_target(hdhr, ip_cstr) > 0)) &&
			(retries < 5)){
			
			retries++;
	}
	

	if(retries < 5){
		[self willChangeValueForKey:@"target"];
		[properties setValue:ip_str forKey:@"target"];
		[self didChangeValueForKey:@"target"];
		
		[self setStatus:@"Playing"];
		//[channel setStatus:@"Playing"];
		
		//NSLog(@"posting notification GBTunerWillPlayChannel");
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"GBTunerWillPlayChannel" object:self userInfo:[NSDictionary dictionaryWithObject:channel forKey:@"channel"]];
	}

	//char *tmp;
	//hdhomerun_device_get_tuner_target(hdhr, &tmp);
	//NSLog(@"ip is = %s", tmp);
}

-(BOOL)isEqual:(GBTuner *)obj{
	BOOL result = NO;
	
	if(([[properties valueForKey:@"identification"] isEqual:[[obj properties] valueForKey:@"identification"]] &&
	[[properties valueForKey:@"number"] isEqual:[[obj properties] valueForKey:@"number"]])){
		
		result = YES;
	}
	
	return result;
}

-(void)dealloc{
	[updateTimer invalidate];

	[updateTimer release];
	
	[properties release];
	[channel release];

	hdhomerun_device_destroy(hdhr);

	[super dealloc];
}

@end
