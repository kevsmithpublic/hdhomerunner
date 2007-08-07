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
//  GBChannel.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannel.h"


@implementation GBChannel
-(id)init{
	if(self = [super init]){
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		[properties setValue:@"New Channel" forKey:@"description"];
		[properties setObject:[[NSNumber alloc] initWithInt:0] forKey:@"channel"];
		[properties setObject:[[NSNumber alloc] initWithInt:0] forKey:@"program"];
		
		status = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"offline" ofType:@"tiff"]], @"Offline",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"idle" ofType:@"tiff"]], @"Idle",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playing" ofType:@"tiff"]], @"Playing",
															[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recording" ofType:@"tiff"]], @"Recording", nil];
		
		status_key = [[NSString alloc] initWithString:@"Offline"];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector: @selector(tunerWillPlayChannel:) name:@"GBTunerWillPlayChannel" object:nil];
		[nc addObserver:self selector: @selector(tunerWillStopPlayingChannel:) name:@"GBTunerWillStopPlayingChannel" object:nil]; 
	}
	
	return self;
}

-(id)initWithDictionary:(NSDictionary *)newProperties{
	[self init];
	
	[self setProperties:newProperties];
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[properties valueForKey:@"description"], @"description",
																	[properties objectForKey:@"channel"], @"channel",
																	[properties objectForKey:@"program"], @"program", nil];

	GBChannel *copy = [[GBChannel alloc] initWithDictionary:dict];
	
	return copy;
}

-(NSDictionary *)properties{
	return properties;
}

-(void)setProperties:(NSDictionary *)newProperties{
	[self willChangeValueForKey:@"properties"];
	if([newProperties valueForKey:@"description"]){
		[properties setValue:[newProperties valueForKey:@"description"] forKey:@"description"];
	}
	if([newProperties valueForKey:@"channel"]){
		[properties setValue:[newProperties valueForKey:@"channel"] forKey:@"channel"];
	}
	if([newProperties valueForKey:@"program"]){
		[properties setValue:[newProperties valueForKey:@"program"] forKey:@"program"];
	}
	[self didChangeValueForKey:@"properties"];
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:properties forKey:@"channel"];
}

- (id)initWithCoder:(NSCoder *)decoder{
	[self init];

	if([decoder containsValueForKey:@"channel"]){
		[self setProperties:[decoder decodeObjectForKey:@"channel"]];
	}
	
	return self;
}

-(NSImage *)status{
	NSLog(@"return channel status");
	return [status objectForKey:status_key];
}

-(void)setStatus:(NSString *)newStatusKey{
	if(![newStatusKey isEqual:status_key] && [status valueForKey:newStatusKey]){
		[self willChangeValueForKey:@"status"];
		[status_key autorelease];
		status_key = [newStatusKey copy];
		NSLog(@"set channel status = %@", status_key);
		[self didChangeValueForKey:@"status"];
	}
}

-(NSArray *)statusKeys{
	return [status allKeys];
}

-(void)tunerWillStopPlayingChannel:(NSNotification *)notification{
	NSLog(@"channel got the message about stop playing");
	GBChannel *tmp = [[notification userInfo] 
						objectForKey:@"channel"];
						
	if([self isEqual:tmp]){
		NSLog(@"we are stopping this channel");
		[self setStatus:@"Idle"];
		
	}
}


-(void)tunerWillPlayChannel:(NSNotification *)notification{
	NSLog(@"channel got the message about playing");
	GBChannel *tmp = [[notification userInfo] 
						objectForKey:@"channel"];
						
	if([self isEqual:tmp]){
		NSLog(@"we are playing this channel");
		[self setStatus:@"Playing"];
		
	}
}

-(BOOL)isEqual:(GBChannel *)obj{
	BOOL result = NO;
	
	if([properties isEqual:[obj properties]]){
		
		result = YES;
	}
	
	return result;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	[properties release];
	
	[super dealloc];
}
@end
