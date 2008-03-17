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
//  GBRecording.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 3/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GBTuner.h";
#import "GBChannel.h";


@interface GBRecording : NSObject {

			// The file's path
			NSString				*path;
			
			// The file name to use
			NSString				*filename;
			
			// The file to write to
			NSFileWrapper			*fileWrapper;
			
			// The tuner to record from
			GBTuner					*tuner;
			
			// The channel to record
			GBChannel				*channel;
			
			// The timers
			NSTimer					*start_timer;
			NSTimer					*stop_timer;
			NSTimer					*recording_timer;
			
			// The progress of the recording
			NSNumber				*progress;
			
			// BOOL indicating whether the recording is scheduled or not
			BOOL					enabled;
			
			// BOOL indicating whether the recording repeats
			BOOL					repeats;
}

// Append data to the file
- (void)appendDataToFile:(NSData *)someData;

// Set the tuner to the new tuner
- (void)setTuner:(GBTuner *)aTuner;

// Return the tuner
- (GBTuner *)tuner;

// Get the recording's progress
- (NSNumber *)progress;

// Set the progress of the recording's completion
- (void)setProgress:(NSNumber *)newProgress;

// Set the tuner to the new tuner
- (void)setChannel:(GBChannel *)aChannel;

// Return the channel
- (GBChannel *)channel;

// Return the path
- (NSString *)path;
- (void)setPath:(NSString *)newPath;

// Return the file name
- (NSString *)filename;
- (void)setFilename:(NSString *)newFilename;

// Record the time to start recording
- (NSDate *)startDate;

// Set the start time
- (void)setStartDate:(NSDate *)aDate;

// Record the time to stop recording
- (NSDate *)stopDate;

// Set the stop time
- (void)setStopDate:(NSDate *)aDate;

// Record the time to start recording
- (NSDate *)startDate;

// Start the recording when this timer fires
- (void)startRecording:(NSTimer*)theTimer;

// Stop the recording when this timer fires
- (void)stopRecording:(NSTimer*)theTimer;

// Record when this timer fires
- (void)recording:(NSTimer*)theTimer;

// Return whether the reciever repeats
- (BOOL)repeats;

// Set if the receiver should repeat
- (void)setRepeats:(BOOL)state;

// Return the time interval for repeating
- (NSTimeInterval)repeatInterval;

// Set the time interval for repeating
- (void)setRepeatInterval:(NSTimeInterval)interval;

// Set the recording to repeat with the time interval
- (void)repeatWithTimeInterval:(NSTimeInterval)interval;

// Return whether the receiver is scheduled
- (BOOL)enabled;

// Set whether the recording should be scheduled or not
- (void)setEnabled:(BOOL)state;
@end
