//
//  GBApplication.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 9/20/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBApplication.h"


@implementation GBApplication
-(id)init{

	if(self = [super init]){
	
	}

	return self;
}

-(void)handleNextChannelScript:(NSScriptCommand *)command{
	NSLog(@"handling next command");
	//[[self delegate] 
}

-(void)handlePreviousChannelScript:(NSScriptCommand *)command{
	NSLog(@"handling previous command");
}

-(BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key{
	BOOL result = NO;
	
	NSLog(@"key checked = %@", key);
	
	
	
	return result;
}
@end
