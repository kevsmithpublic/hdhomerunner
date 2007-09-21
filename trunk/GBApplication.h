//
//  GBApplication.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 9/20/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBApplication : NSApplication {

}

-(void)handleNextChannelScript:(NSScriptCommand *)command;
-(void)handlePreviousChannelScript:(NSScriptCommand *)command;
@end
