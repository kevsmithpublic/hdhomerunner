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


@implementation GBRecording

- (id)init{

	// Init
	if(self = [super init]){
		
		// Create the path string
		path = [[NSString alloc] init];
		
		// Create the file wrapper
		fileWrapper = [[NSFileWrapper alloc] init];
	}
	
	return self;
}

- (id)initWithPath:(NSString *)aPath{
	
	// Init
	if(self = [super init]){
		
		// Create the path string
		path = [[NSString alloc] initWithString:aPath];
		
		// Create the file wrapper
		fileWrapper = [[NSFileWrapper alloc] initWithPath:aPath];		
		
	}
	
	return self;
}

// Return the path
- (NSString *)path{

	return path;
}

// Append data to the file
- (void)appendDataToFile:(NSData *)someData{
	
	// The default file manager
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// If the file exists then append data to it else create the file first
	if([fileManager fileExistsAtPath:[self path]] && someData){
		
		// Create a file handle for reading and writing
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self path]];
		
		// Seek to the end of the file
		[fileHandle seekToEndOfFile];
		
		// Write the data to the end of the file
		[fileHandle writeData:someData];
		
		// Close the file
		[fileHandle closeFile];
		
		// Update the file wrapper
		[fileWrapper updateFromPath:[self path]];
	} else {
	
		// Create the file
		[fileManager createFileAtPath:[self path] contents:someData attributes:nil]; 
	}
}

// Return the file name
- (NSString *)filename{

	return [fileWrapper filename];
}


@end
