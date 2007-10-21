//    This file is part of hdhomerunner.

//    hdhomerunner is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    hdhomerunner is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

//
//  GBApplication.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 9/20/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBApplication.h"
#import "GBController.h"

@implementation GBApplication
-(id)init{

	if(self = [super init]){
	
	}

	return self;
}

-(void)handlenextchannelScriptCommand:(NSScriptCommand *)command{
	NSLog(@"handling next command");
	//[[self delegate] 
}

-(void)handlePreviousChannelScriptCommand:(NSScriptCommand *)command{
	NSLog(@"handling previous command");
}

-(BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key{
	BOOL result = NO;
	
	NSLog(@"key checked = %@", key);
	
	
	
	return result;
}
@end
