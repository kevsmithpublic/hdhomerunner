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
//  GBTuner.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/14/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "hdhomerun.h";

@class GBChannel;

@interface GBTuner : NSObject {
		NSMutableDictionary	*properties;		// A dictionary of the tuner's properties
		
		GBChannel			*channel;			// The tuner's setpoint
				
		NSTimer				*updateTimer;		// The timer to update the GUI
				
		NSString			*status_key;		// The current tuner's status
		NSDictionary		*status;			// The status -> icon mappings
		
		NSString			*lineuplocation;	// The location of the tuner
			
		struct		hdhomerun_device_t	*hdhr;	// The tuner
}
-(id)initWithIdentification:(unsigned int)dev_id andTuner:(int)tuner;
-(id)initWithDictionary:(NSDictionary *)newProperties;

-(struct hdhomerun_device_t	*)deviceWithID:(NSString *)anID andNumber:(NSString *)aNumber;

-(BOOL)upgrade:(NSURL *)newFirmware;

-(NSImage *)status;
-(void)setStatus:(NSString *)newStatus;
-(NSArray *)statusKeys;

-(NSDictionary *)properties;
-(void)setProperties:(NSDictionary *)newProperties;

-(GBChannel *)channel;
-(void)setChannel:(GBChannel *)newChannel;

-(NSString *)lineuplocation;
-(void)setLineuplocation:(NSString *)newLineuplocation;

-(void)update:(NSTimer*)timer;

-(NSArray *)autoscanForLocation;

-(void)playChannel;

-(BOOL)isEqual:(GBTuner *)obj;
@end
