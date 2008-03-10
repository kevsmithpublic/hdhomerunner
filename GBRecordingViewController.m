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
//  GBRecordingViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 3/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBRecordingViewController.h"


@implementation GBRecordingViewController
// Initialize
- (id)init{

	// Call the super class's init
	if(self = [super init]){
		
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed: @"RecordingView" owner: self]){
            
			// Release
			[self release];
			
			// Point to nil
            self = nil;
        }
	}

	return self;
}

// Awake from nib
- (void)awakeFromNib{
	
	// Bind the text field to the date picker's date
	[_date_holder bind:@"value" toObject:_date_picker withKeyPath:@"dateValue" options:nil];
	
	// Let the button images adjust any image in it automatically
	/*[[_start_date image] setScalesWhenResized:YES];
	[[_stop_date image] setScalesWhenResized:YES];
	[[_channels image] setScalesWhenResized:YES];
	
	[[_start_date image] setSize:NSMakeSize(18.0f, 18.0f)];
	[[_stop_date image] setSize:NSMakeSize(18.0f, 18.0f)];
	[[_channels image] setSize:NSMakeSize(18.0f, 18.0f)];*/
}

#pragma mark -
#pragma mark  Acessor Methods
#pragma mark -

// Set the tuner to the new tuner
- (void)setRecording:(GBRecording *)aRecording{
	
	// If the tuner is not nil and not the same as the existing tuner
	if((aRecording != nil) && ![recording isEqual:aRecording]){
		
		// Set the subview to not observe changes for a new tuner
		//[self unRegisterSubviewsForTuner:[self tuner]];
		
		// Unregister ourselves as an observer of the tuner
		[self unRegisterAsObserverForRecording:[self recording]];
		
		// Key value coding
		[self willChangeValueForKey:@"recording"];
		
		// Auto release the current tuner
		[recording autorelease];
		
		// Free the tuner
		recording = nil;
		
		// Assign tuner to the new tuner and retain it
		recording = [aRecording retain];
		
		// Key value coding
		[self didChangeValueForKey:@"recording"];
		
		// Register ourselves as an observer for the new tuner
		[self registerAsObserverForRecording:[self recording]];
		
		// Reload the view 
		//[self reloadView];
	}
}

// Return the recording
- (GBRecording *)recording{

	return recording;
}


// Show the info sheet
- (void)showInfo{
	
	// Fill in the date fields
	[_info_start_date setObjectValue:[[self recording] startDate]];
	[_info_stop_date setObjectValue:[[self recording] stopDate]];
	
	// Make the display the key window
	[_info_window makeKeyAndOrderFront:nil];
}

// Show the date picker
- (IBAction)showDatePicker:(id)sender{
	
	// Set the date picker to the current date
	[_date_picker setDateValue:[NSDate date]];
	
	// Open a sheet over the panel
	[NSApp beginSheet:_date_window modalForWindow:_info_window
        modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:sender];
}

// Modify the start or end date when the sheet closes
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo{

	// If the hit ok
	if (returnCode == NSOKButton) {

		// Get the date picker's date
		NSDate *date = [_date_picker dateValue];

		// If the context info is related to the start date
		if(contextInfo == _start_date){

			// Set the recording's start date by exploiting bindings
			[[self recording] setStartDate:date];
		} else if(contextInfo == _stop_date){
			
			// Else if the content info is related to the stop date

			// Set the recording's stop date by exploiting bindings
			[[self recording] setStopDate:date];			
		}
	} else if (returnCode == NSAlertAlternateReturn) {
	
		// Don't do anything. The user cancelled the action
	}
	
	[sheet orderOut:self];
}

// Validate the date picker
- (IBAction)validate:(id)sender{
	
	// End the sheet
    [NSApp endSheet:_date_window returnCode:[[sender title] isEqualToString:@"OK"]];
}

#pragma mark -
#pragma mark  Comparison Methods
#pragma mark -

// Compare self and controller to see if they're equal
- (BOOL)isEqual:(GBRecordingViewController *)controller{
	
	// Return they are equal if the recordings are equal
	return [[self recording] isEqual:[controller recording]];
}

#pragma mark -
#pragma mark  Binding Methods
#pragma mark -

// Bind up the objects according to the recording
- (void)registerAsObserverForRecording:(GBRecording *)aRecording{

	// Bind the text fields to the appropriate recording properites
	
	// The main window
	[_name bind:@"value" toObject:aRecording withKeyPath:@"filename" options:nil];
	[_info_name bind:@"value" toObject:aRecording withKeyPath:@"filename" options:nil];
	
	// The info panel
	[_path bind:@"value" toObject:aRecording withKeyPath:@"path" options:nil];
	
	// Bind the enable button to the recordings enable value
	[_info_check_box bind:@"value" toObject:aRecording withKeyPath:@"enabled" options:nil];
	
	// Register for changes in the start or stop dates
	[aRecording addObserver:self
			forKeyPath:@"startDate"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
			
	[aRecording addObserver:self
			forKeyPath:@"stopDate"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
}

- (void)unRegisterAsObserverForRecording:(GBRecording *)aRecording{

    [aRecording removeObserver:self forKeyPath:@"startDate"];
	[aRecording removeObserver:self forKeyPath:@"stopDate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
						ofObject:(id)object
                        change:(NSDictionary *)change
						context:(void *)context {
	
	// If the start date was changed
	if ([keyPath isEqual:@"startDate"]) {
		
		// Update the text field
		[_info_start_date setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
    } else if([keyPath isEqual:@"stopDate"]) {

		// If the stop date was changed 
		
		// Update the text field
		[_info_stop_date setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
	}
}


// Clean up
- (void)dealloc{
	
	[_date_picker removeObserver:_date_holder forKeyPath:@"dateValue"];
	
	[recording release];
	
	[super dealloc];
}
@end
