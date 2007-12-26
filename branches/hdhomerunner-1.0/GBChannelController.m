//
//  GBChannelController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannelController.h"


@implementation GBChannelController
- (id)init{
	if(self = [super init]){
		[self setDescription:@"CHANNELS"];						// Set the description of the collection
		[self setTitle:@"CHANNELS"];										// Set the title of the collection
		[self setIsExpandable:NO];										// Set this is an expandable collection
		//[self setChildren:[NSMutableArray arrayWithCapacity:0]];		// Set the collection to initially be empty
	
		NSImage *icon = [NSImage imageNamed:@"Folder"];
		[self setIcon:icon];
		
		[self setIsChild:YES];
	}
	
	return self;
}


@end
