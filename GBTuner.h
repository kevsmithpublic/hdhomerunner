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
//#import <WebKit/WebKit.h>

#import "hdhomerun.h"
#import "GBChannel.h"

// Declare classes
@class DSGeneralOutlineView;

@interface GBTuner : NSObject <NSCoding, NSCopying> {
		NSMutableDictionary			*properties;		// The key value coded properties of the tuner
		
		NSMutableArray				*channels;
				
		struct hdhomerun_device_t	*hdhr;
		BOOL						cancel_thread;
		
		NSTimer						*updateTimer;		// The timer used to update the tuner's properties
		

}
- (id)initWithIdentificationNumber:(NSNumber *)dev_id andTunerNumber:(NSNumber *)tuner_number;

- (struct hdhomerun_device_t *)deviceWithIdentificationNumber:(NSNumber *)id_number andTunerNumber:(NSNumber *)tuner_number;

- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)newProperties;

- (NSNumber *)identificationNumber;
- (void)setIdentificationNumber:(NSNumber *)newID;

- (struct hdhomerun_device_t *)hdhr;
- (void)setHdhr:(struct	hdhomerun_device_t *)aHdhr;

- (NSString *)location;
- (void)setLocation:(NSString *)aLocation;

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

- (void)setGBChannel:(GBChannel *)newChannel;

- (NSNumber *)program;
- (void)setProgram:(NSNumber *)aProgram;

- (void)startUpdateTimer;
- (void)stopUpdateTimer;
- (NSTimeInterval)updateInterval;

- (void)setUpdateInterval:(NSTimeInterval)newTime;
- (void)update:(NSTimer*)theTimer;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;

- (NSString *)caption;
- (void)setCaption:(NSString *)newCaption;

- (BOOL)cancelThread;
- (void)setCancelThread:(BOOL)cancel;

- (NSArray *)channels;
- (void)setChannels:(NSArray *)newChannels;

- (NSComparisonResult)compare:(GBTuner *)aParent;
- (BOOL)isEqual:(GBTuner *)aParent;

// NSCopying and NSCoding Protocol
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryRepresentation;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

- (id)copyWithZone:(NSZone*)zone;
- (void)setNilValueForKey:(NSString*)key;

// Channel scanning support
- (void)addChannel:(GBChannel *)aChannel;
- (void)removeChannel:(GBChannel *)aChannel;
- (NSNumber *)numberOfPossibleChannels:(NSNumber *)mode;
- (NSNumber *)numberOfAvailableChannels;
- (void)scanForChannels:(NSNumber *)mode;
-(void)processChannels:(NSNumber *)mode;
int channelscanCallback(va_list ap, const char *type, const char *str);

// Channel playing and recording
- (void)play;
@end