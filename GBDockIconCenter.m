//
//  GBDockIconCenter.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBDockIconCenter.h"


@implementation GBDockIconCenter
-(id)init{
	if(self == [super init]){
		values = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionary]];
	}
	
	return self;
}

+(id)iconCenter{
	return self;
}

-(void)addValue:(NSString *)aValue observer:(id)aSender{
	if(aSender && ![aValue isEmpty]){
		
	}
}

-(void)dealloc{
	[super dealloc];
}
@end
