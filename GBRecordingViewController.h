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
//  GBRecordingViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 3/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBViewController.h"

#import <Cocoa/Cocoa.h>

#import "GBRecording.h"


@interface GBRecordingViewController : GBViewController {

		// Interface elements
		
		// Main window elements
		IBOutlet			NSTextField			*_name;
		IBOutlet			NSTextField			*_path;
		
		// The date picker
		IBOutlet			NSWindow			*_date_window;
		IBOutlet			NSDatePicker		*_date_picker;
		IBOutlet			NSTextField			*_date_holder;
		
		// The inspector (info) window
		IBOutlet			NSWindow			*_info_window;
		
		// The text fields stored in a form
		IBOutlet			NSTextField			*_info_name;
		IBOutlet			NSTextField			*_info_channel;
		IBOutlet			NSTextField			*_info_start_date;
		IBOutlet			NSTextField			*_info_stop_date;
		
		// The check box
		IBOutlet			NSButton			*_info_check_box;
		
		// The configuration buttons
		IBOutlet			NSButton			*_start_date;
		IBOutlet			NSButton			*_stop_date;
		
		IBOutlet			NSButton			*_channels;
		
		// The recording displayed in the view
							GBRecording			*recording;
}

// Interface actions

// Show the info sheet
- (void)showInfo;

// Show the date picker
- (IBAction)showDatePicker:(id)sender;

// Validate the date picker
- (IBAction)validate:(id)sender;

// Accessor Methods
- (void)setRecording:(GBRecording *)aRecording;
- (GBRecording *)recording;

// Binding methods
- (void)registerAsObserverForRecording:(GBRecording *)aRecording;
- (void)unRegisterAsObserverForRecording:(GBRecording *)aRecording;

// Comparison methods
- (BOOL)isEqual:(GBRecordingViewController *)controller;

// Modify the start or end date when the sheet closes
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo;

@end