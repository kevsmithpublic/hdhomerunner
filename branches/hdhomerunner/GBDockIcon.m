//
//  GBDockIcon.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 3/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBDockIcon.h"


@implementation GBDockIcon

static GBDockIcon *sharedInstance = nil;

// Initialize
- (id)init{

	// If an instance of the class already exists
	if(sharedInstance){

		// dealloc it
		[self dealloc];
	} else {
	
		// Call the super class's init
		sharedInstance = [super init];
		
		// Create an empty array
		recordingArray = [[NSMutableArray alloc] initWithCapacity:0];
	}

	return sharedInstance;
}

@end
