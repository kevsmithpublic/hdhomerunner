// The MIT License
//
// Copyright (c) 2008 Gregory Barchard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  GBTuner.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "hdhomerun.h"

#import "GBChannel.h"
//#import "GBRecording.h"

//@class GBChannel;
@class GBRecording;

// Declare classes
@class DSGeneralOutlineView;

@interface GBTuner : NSObject <NSCoding, NSCopying> {
		NSMutableDictionary			*properties;		// The key value coded properties of the tuner
		
		// An array of channels associated with the tuner
		NSMutableArray				*channels;
		
		// An array of recordings associated with the tuner
		NSMutableArray				*recordings;
				
		struct hdhomerun_device_t	*hdhr;
		BOOL						cancel_thread;
		BOOL						is_scanning_channels;
		
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

-(NSNumber *)channelNumber;
- (void)setChannelNumber:(NSNumber *)newChannel;

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

// Get the recordings
- (NSArray *)recordings;
- (void)setRecordings:(NSArray *)newRecordings;

- (NSComparisonResult)compare:(GBTuner *)aTuner;
- (BOOL)isEqual:(GBTuner *)aTuner;

// NSCopying and NSCoding Protocol
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryRepresentation;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

- (id)copyWithZone:(NSZone*)zone;
- (void)setNilValueForKey:(NSString*)key;

// Channel scanning support
- (void)addGBChannel:(GBChannel *)aChannel;
- (void)removeGBChannel:(GBChannel *)aChannel;
- (NSNumber *)numberOfPossibleChannels:(NSNumber *)mode;
- (NSNumber *)numberOfAvailableChannels;
- (void)scanForChannels:(NSNumber *)mode;
-(void)processChannels:(NSNumber *)mode;
int channelscanCallback(va_list ap, const char *type, const char *str);
- (BOOL)isScanningChannels;
- (void)setIsScanningChannels:(BOOL)flag;
- (void)setScanningChannels:(NSNumber *)flag;

// Recording support
- (void)addGBRecording:(GBRecording *)aRecording;
- (void)removeGBRecording:(GBRecording *)aRecording;

// Channel playing and recording
- (void)play;
@end