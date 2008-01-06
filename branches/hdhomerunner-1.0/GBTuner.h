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
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "hdhomerun.h"
#import "GBParent.h"

@interface GBTuner : NSObject <GBParent, NSCoding, NSCopying> {
		NSMutableDictionary			*properties;		// The key value coded properties of the tuner
		
		struct hdhomerun_device_t	*hdhr;
		BOOL						cancel_thread;
		
		NSTimer						*updateTimer;		// The timer used to update the tuner's properties
}
- (id)initWithIdentification:(NSNumber *)dev_id andTuner:(NSNumber *)tuner_number;
- (id)initWithDescription:(NSString *)description identification:(NSString *)anID ip:(NSString *)anIP andNumber:(NSNumber *)aNumber;

- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)newProperties;

- (NSNumber *)identification;
- (void)setIdentification:(NSNumber *)newID;

- (struct hdhomerun_device_t *)hdhr;
- (void)setHdhr:(struct	hdhomerun_device_t *)aHdhr;

- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;

- (NSString *)ip;
- (void)setIp:(NSString *)aIp;

- (NSNumber *)firmwareVersion;
- (void)setFirmwareVersion:(NSNumber *)newVersion;

- (NSString *)lock;
- (void)setLock:(NSString *)aLock;

- (NSString *)target;
- (void)setTarget:(NSString *)aTarget;

- (NSNumber *)number;
- (void)setNumber:(NSNumber *)aNumber;

- (NSNumber *)signalStrength;
- (void)setSignalStrength:(NSNumber *)newStrength;

- (NSNumber *)signalToNoiseRatio;
- (void)setSignalToNoiseRatio:(NSNumber *)newSnr;

- (NSNumber *)symbolErrorQuality;
- (void)setSymbolErrorQuality:(NSNumber *)newSeq;

- (NSNumber *)bitrate;
- (void)setBitrate:(NSNumber *)newBitrate;

-(NSNumber *)channel;
- (void)setChannel:(NSNumber *)newChannel;

- (NSNumber *)program;
- (void)setProgram:(NSNumber *)aProgram;

- (void)startUpdateTimer;
- (void)stopUpdateTimer;
- (NSTimeInterval)updateInterval;

- (void)setUpdateInterval:(NSTimeInterval)newTime;
- (void)update:(NSTimer*)theTimer;

// GBParent protocol definitions
- (id)initChild;

- (BOOL)isChild;
- (void)setIsChild:(BOOL)flag;

- (NSMutableArray *)children;
- (void)setChildren:(NSArray *)newContents;
- (int)numberOfChildren;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;

- (NSComparisonResult)compare:(<GBParent> *)aParent;
- (BOOL)isEqual:(GBTuner <GBParent> *)aParent;

- (BOOL)isExpandable;
- (void)setIsExpandable:(BOOL)newState;

// NSCopying and NSCoding Protocol
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryRepresentation;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

- (id)copyWithZone:(NSZone*)zone;
- (void)setNilValueForKey:(NSString*)key;

// Channel scanning support
- (NSNumber *)numberOfAvailableChannels;
int channelscanCallback(va_list ap, const char *type, const char *str);
@end
