//
//  GBWindowController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "GBTuner.h"

// Declare classes
@class DSGeneralOutlineView;

@interface GBWindowController : NSWindowController {

		// The tuner to get the data from
						GBTuner			*tuner;	
		
		// The view
		IBOutlet		NSView			*_view;

		// The webview to show the channel's URL
		IBOutlet		WebView			*_web;
		
		// The outline view
		IBOutlet		DSGeneralOutlineView	*channelListOutlineView;
		
		// Control items
		IBOutlet		NSButton				*_add;
		IBOutlet		NSButton				*_remove;
		IBOutlet		NSButton				*_refresh_channels;
		
		// Option items
		IBOutlet		NSPopUpButton			*_channelscan_mode;
		
		// The textfields to show the relevant info
		/*IBOutlet		NSTextField		*_title;
		IBOutlet		NSTextField		*_program;
		IBOutlet		NSTextField		*_channel;
		IBOutlet		NSTextField		*_url;*/
}
- (NSView *)view;
- (void)updateView;
- (void)channelsChanged:(NSNotification *)notification;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)refresh:(id)sender;

- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString;
- (void)setRepresentedTuner:(GBTuner *)aTuner;
- (GBTuner *)representedTuner;
@end
