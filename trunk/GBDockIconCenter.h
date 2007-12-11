//
//  GBDockIconCenter.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBDockIconCenter : NSObject {
	NSMutableDictionary			*values;
}
+(id)iconCenter;

-(void)addValue:(NSString *)aValue observer:(id)aSender;
-(void)removeObserver:(id)aSender;

@end
