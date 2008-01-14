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
#import "DBListSplitView.h"

// Declare classes
@class DSGeneralOutlineView;

@interface GBWindowController : NSWindowController {

		// Main window elements
		IBOutlet		DBListSplitView			*tunerSplitView;

		// The tuner to get the data from
						GBTuner					*tuner;	
		
		// The view
		IBOutlet		NSView					*_view;

		// The webview to show the channel's URL
		IBOutlet		WebView					*_web;
		
		// The outline view
		IBOutlet		DSGeneralOutlineView	*channelListOutlineView;
		
		// The content view
		IBOutlet		NSView					*contentViewPlaceHolder;
		
		// Control items
		IBOutlet		NSButton				*_add;
		IBOutlet		NSButton				*_remove;
		IBOutlet		NSButton				*_refresh_channels;
		
		// Option items
		IBOutlet		NSPopUpButton			*_channelscan_mode;

}
- (NSView *)view;
- (void)updateWebView:(GBChannel *)aChannel;

- (void)reloadAllChannelData;
- (void)reloadChannelData:(GBChannel *)aChannel;

- (void)changeCurrentView:(NSView *)newView;
- (void)channelsChanged:(NSNotification *)notification;

- (void)endAlertSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)refresh:(id)sender;

- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString;
- (void)setRepresentedTuner:(GBTuner *)aTuner;
- (GBTuner *)representedTuner;
@end
