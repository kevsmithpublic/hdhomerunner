//
//  GBAppDelegate.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBAppDelegate.h"
#import "GBWindowController.h"

@implementation GBAppDelegate
// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed:sender
//
//	NSApplication delegate method placed here so the sample conveniently quits
//	after we close the window.
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	// load the app's main window for display
	//windowController = [[GBWindowController alloc] initWithWindow:[[NSApplication sharedApplication] mainWindow]];
	//windowController = [[GBWindowController alloc] initWithWindowNibName:@"MainWindow"];
	//[windowController showWindow:self];
}

@end
