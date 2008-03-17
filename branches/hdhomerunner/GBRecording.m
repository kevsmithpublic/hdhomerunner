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
//  GBRecording.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 3/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBRecording.h"

#define	REPEAT_NONE		0.0f
#define	REPEAT_DAILY	86400.0f
#define	REPEAT_WEEKLY	604800.0f
#define REPEAT_RECORDING 0.064f

@implementation GBRecording

- (id)init{

	// Init
	if(self = [super init]){
		
		// Create the path string
		path = [[NSString alloc] init];
		
		// Create the filename string
		filename = [[NSString alloc] initWithString:@"Untitled"];
		
		// Create the file wrapper
		fileWrapper = [[NSFileWrapper alloc] init];
		
		// Set the tuner and channel to empty
		tuner = [[GBTuner alloc] init];
		channel = [[GBChannel alloc] init];
		
		// Initialize the timers
		start_timer = [[NSTimer timerWithTimeInterval:REPEAT_NONE target:self selector:@selector(startRecording:) userInfo:nil repeats:NO] retain];
		stop_timer = [[NSTimer timerWithTimeInterval:REPEAT_NONE target:self selector:@selector(stopRecording:) userInfo:nil repeats:NO] retain];
		recording_timer = [[NSTimer timerWithTimeInterval:REPEAT_RECORDING target:self selector:@selector(recording:) userInfo:nil repeats:YES] retain];
		
		// Set a default start and stop date
		[self setStartDate:[NSDate date]];
		[self setStopDate:[NSDate dateWithTimeIntervalSinceNow:60]];
		
		// By default the recording should be disabled
		enabled = NO;
	}
	
	return self;
}

- (id)initWithPath:(NSString *)aPath{
	
	// Init
	if(self = [self init]){
		
		// Create the path string
		[self setPath:aPath];
	}
	
	return self;
}

// Append data to the file
- (void)appendDataToFile:(NSData *)someData{
	
	// The default file manager
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *full_path = [[NSString stringWithFormat:@"%@/%@/%@%@", [self path], [[self channel] description], [[self filename] stringByReplacingOccurrencesOfString:@"/" withString:@":"], @".ts", nil] stringByStandardizingPath];//[[NSString stringWithFormat:@"%@/%@/%@%@", [[self path], [[self channel] description] stringByReplacingOccurrencesOfString:@"/" withString:@":"], [[self filename] stringByReplacingOccurrencesOfString:@"/" withString:@":"], @".ts", nil] stringByStandardizingPath];//[fileManager stringWithFileSystemRepresentation:file_system_path length:strlen(file_system_path)];

	// If the file exists then append data to it else create the file first
	if([fileManager fileExistsAtPath:full_path] && someData){
		
		// Create a file handle for reading and writing
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:full_path];
		
		// Seek to the end of the file
		[fileHandle seekToEndOfFile];
		
		// Write the data to the end of the file
		[fileHandle writeData:someData];
		
		// Close the file
		[fileHandle closeFile];
		
		// Update the file wrapper
		//[fileWrapper updateFromPath:full_path];
	} else {
	
		// Break the full_path up into parts and make sure each part exists
		
		// The parts seperated by /
		NSArray	*path_array = [[full_path stringByDeletingLastPathComponent] pathComponents];//[[NSString stringWithFormat:@"%@/%@", [self path], [[self channel] description], nil] pathComponents];
				
		// Temporary string to hold the path
		NSString *tmp_path = [NSString string];
		
		// Item to store the components to while enumerating
		NSString *path_component;
		
		// The enumerator to loop over the paths
		NSEnumerator *enumerator = [path_array objectEnumerator];
		
		// Loop over all the components in the path and determine if the path exists
		while(path_component = [enumerator nextObject]){
							
			// Append the path to the existing (temporary) path
			tmp_path = [NSString pathWithComponents:[[tmp_path pathComponents] arrayByAddingObject:path_component]];
			
			// BOOL to indicate if the file is a directory
			BOOL isDir;
			
			// If the temporary path does not exist and the component
			if(![fileManager fileExistsAtPath:[tmp_path stringByExpandingTildeInPath] isDirectory:&isDir]){

				// Create the directory
				[fileManager createDirectoryAtPath:tmp_path attributes:nil];
			}
		}
	
		// Create the file
		[fileManager createFileAtPath:full_path contents:someData attributes:nil]; 
	}
}

#pragma mark -
#pragma mark  Timer Methods
#pragma mark -

// Return whether the reciever repeats
- (BOOL)repeats{

	return repeats;
}

// Set if the receiver should repeat
- (void)setRepeats:(BOOL)state{
	
	// If the state is not the same as the existing state
	if(repeats != state){
		
		
		// Set the start timer to repeat
		
		
		// If the timers are enabled re-add them to the run loop
		if(enabled){
		
		}
		
		// Update the value of repeats
		repeats = state;
	}
}

// Return the time interval for repeating
- (NSTimeInterval)repeatInterval{
	
	return [start_timer timeInterval];
}

// Set the time interval for repeating
- (void)setRepeatInterval:(NSTimeInterval)interval{
	
	// If the interval is not the same as the current time interval
	if([self repeatInterval] != interval){
		
		// Stop the timers
		
		
		// Create new timers
		
		
		// If the timers were enabled then re-add them to the run loop
		
	}
}

// Set the recording to repeat with the time interval
- (void)repeatWithTimeInterval:(NSTimeInterval)interval{
	
	// If it isn't already set, set the timers to repeat
	[self setRepeats:YES];
	
	// Set the time interval
	[self setRepeatInterval:interval];
}

// Return whether the receiver is scheduled
- (BOOL)enabled{
	
	return enabled;
}

// Set whether the recording should be scheduled or not
- (void)setEnabled:(BOOL)state{
	
	// If we aren't already in the state
	if(enabled != state){
		
		// If we should schedule ourselves
		if(state){
			
			// Then start the timer
			[[NSRunLoop currentRunLoop] addTimer:start_timer forMode:NSDefaultRunLoopMode];
		} else if([recording_timer isValid]){
			
			// Else if the recording timer is valid (aka we are recording)
			
			// Manually fire the stop recording signal
			[stop_timer fire];
			
			// Then invalidate the stop timer
			[stop_timer invalidate];
		}
		
		// Update enabled
		enabled = state;
	}

}

// Start the recording when this timer fires
- (void)startRecording:(NSTimer*)theTimer{
	
	NSLog(@"start timer fired");
	
	// Set the channel of the tuner to the channel we want to record
	[[self tuner] setGBChannel:[self channel]];
	
	// If starting the recording was successful
	if(hdhomerun_device_stream_start([[self tuner] hdhr]) == 1){
		
		// Add the stop and recording timers to the run loop
		[[NSRunLoop currentRunLoop] addTimer:recording_timer forMode:NSDefaultRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer:stop_timer forMode:NSDefaultRunLoopMode];
	}
}

// Stop the recording when this timer fires
- (void)stopRecording:(NSTimer*)theTimer{
	NSLog(@"stop timer fired");
	
	// Stop the recording timer
	[recording_timer invalidate];
		
	// Try to stop the recording
	hdhomerun_device_stream_stop([[self tuner] hdhr]);
		
	// Set the progress to 100%
	[self setProgress:[NSNumber numberWithInt:100]];
}

// Record when this timer fires
- (void)recording:(NSTimer*)theTimer{
	NSLog(@"recording...");
	
	// Recording parameters
	size_t max_size = 2048;
	size_t *pactual_size;
	uint8_t *bytes;
	
	// Grab the stream from the device
	bytes = hdhomerun_device_stream_recv([[self tuner] hdhr], max_size, pactual_size);
	
	// Save the data
	[self appendDataToFile:[NSData dataWithBytes:bytes length:(*pactual_size)]];
	
	// The total progress is how long we have been recording divided by the total recording time
	NSUInteger total_progress = [[NSDate date] timeIntervalSinceDate:[self startDate]]/[[self stopDate] timeIntervalSinceDate:[self startDate]];
	
	// Update the progress indicator every 1%
	if((total_progress % 5) == 1){
	
		// Update the progress
		[self setProgress:[NSNumber numberWithInt:total_progress]];
	}
	
	/*
	extern int hdhomerun_device_stream_start(struct hdhomerun_device_t *hd);
extern uint8_t *hdhomerun_device_stream_recv(struct hdhomerun_device_t *hd, size_t max_size, size_t *pactual_size);
extern void hdhomerun_device_stream_flush(struct hdhomerun_device_t *hd);
extern void hdhomerun_device_stream_stop(struct hdhomerun_device_t *hd);
*/
}

#pragma mark -
#pragma mark  Acessor Methods
#pragma mark -

// Get the recording's progress
- (NSNumber *)progress{
	
	return progress;
}

// Set the progress of the recording's completion
- (void)setProgress:(NSNumber *)newProgress{
	
	// If aProgress doesn't equal the existing progress
	if(![[self progress] isEqualToNumber:newProgress] && newProgress){
		
		// Key value coding
		[self willChangeValueForKey:@"progress"];
		
		// Auto release the current progress
		[progress autorelease];
		
		// Free the progress
		progress = nil;
		
		// Assign tuner to the new tuner and retain it
		progress = [newProgress retain];
		
		// Key value coding
		[self didChangeValueForKey:@"progress"];
	}
}

// Record the time to start recording
- (NSDate *)startDate{
	
	// Return the firing date of the timer
	return [start_timer fireDate];
}

// Set the start time
- (void)setStartDate:(NSDate *)aDate{

	// Only create the timer if aDate is LATER than the current date
	// AND earlier than the stop date AND not equal to the current start date
	if(([aDate compare:[NSDate date]] == NSOrderedDescending) &&
		([aDate compare:[self stopDate]] == NSOrderedAscending) &&
		![aDate isEqualToDate:[self startDate]]){
		
		[self willChangeValueForKey:@"startDate"];
	
		// Set the fire date of the timer
		[start_timer setFireDate:aDate];
		
		[self didChangeValueForKey:@"startDate"];
	}
}

// Record the time to stop recording
- (NSDate *)stopDate{

	// Return the firing date of the timer
	return [stop_timer fireDate];
}

// Set the stop time
- (void)setStopDate:(NSDate *)aDate{

	// Only create the timer if aDate is LATER than the current start date
	// AND not equal to the current stop date
	if(([aDate compare:[self startDate]] == NSOrderedDescending) && 
		![aDate isEqualToDate:[self stopDate]]){
		
		[self willChangeValueForKey:@"stopDate"];
	
		// Set the fire date of the timer
		[stop_timer setFireDate:aDate];
		
		[self didChangeValueForKey:@"stopDate"];
	}
}

// Set the tuner to the new tuner
- (void)setTuner:(GBTuner *)aTuner{
	
	// If the tuner is not nil and not the same as the existing tuner
	if((aTuner != nil) && ![tuner isEqual:aTuner]){
		
		// Key value coding
		[self willChangeValueForKey:@"tuner"];
		
		// Auto release the current tuner
		[tuner autorelease];
		
		// Free the tuner
		tuner = nil;
		
		// Assign tuner to the new tuner and retain it
		tuner = [aTuner retain];
		
		// Key value coding
		[self didChangeValueForKey:@"tuner"];
	}
}

// Return the tuner
- (GBTuner *)tuner{

	return tuner;
}

// Set the channel to the new tuner
- (void)setChannel:(GBChannel *)aChannel{
	
	// If the channel is not nil and not the same as the existing channel
	if((channel != nil) && ![channel isEqual:aChannel]){
		
		// Key value coding
		[self willChangeValueForKey:@"channel"];
		
		// Auto release the current channel
		[channel autorelease];
		
		// Free the tuner
		channel = nil;
		
		// Assign channel to the new channel and retain it
		channel = [aChannel retain];
		
		// Key value coding
		[self didChangeValueForKey:@"channel"];
	}
}

// Return the channel
- (GBChannel *)channel{

	return channel;
}


// Return the path
- (NSString *)path{

	return path;
}

// Set the path to the new path
- (void)setPath:(NSString *)newPath{
	
	// Make sure newPath is not nil or equal to the existing path
	if(newPath && ![[self path] isEqual:newPath]){
		
		// Release the existing path
		[path release];
		
		// Set it to nil
		path = nil;
		
		// Reassign path
		path = [[NSString alloc] initWithString:newPath];
	}
}

// Return the file name
- (NSString *)filename{

	return filename;
}

// Set the filename to newFilename
- (void)setFilename:(NSString *)newFilename{
	
	// Make sure newPath is not nil or equal to the existing filename
	if(newFilename && ![[self filename] isEqual:newFilename]){
		
		// Release the existing filename
		[path release];
		
		// Set it to nil
		filename = nil;
		
		// Reassign path
		filename = [[NSString alloc] initWithString:newFilename];
	}
}

// Comparison methods
// Return YES if the channel and tuner are equal
- (BOOL)isEqual:(GBRecording *)aRecording{
	
	return ([[self channel] isEqual:[aRecording channel]] && [[self tuner] isEqual:[aRecording tuner]]);
}

// Clean up
- (void)dealloc{

	[path release];
	[fileWrapper release];
	[tuner release];
	[channel release];
	
	[start_timer release];
	[stop_timer release];
	[recording_timer release];
	
	[super dealloc];
}
@end
