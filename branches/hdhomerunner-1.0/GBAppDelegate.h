//
//  GBAppDelegate.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "hdhomerun.h"
#import "GBTuner.h"

@class GBWindowController;

@interface GBAppDelegate : NSObject {
		NSMutableArray		*tuners;
		
		NSFont				*font;
}

- (NSMutableArray *)tuners;
- (void)setTuners:(NSArray *)newTuners;

@end
