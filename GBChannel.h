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
//  GBChannel.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBChannel : NSObject {
			NSMutableDictionary			*properties;
			
			NSString			*status_key;
			NSDictionary		*status;
}
-(id)initWithDictionary:(NSDictionary *)newProperties;

-(NSImage *)status;
-(void)setStatus:(NSString *)newStatus;
-(NSArray *)statusKeys;

-(NSDictionary *)properties;
-(void)setProperties:(NSDictionary *)newProperties;

-(void)tunerWillStopPlayingChannel:(NSNotification *)notification;
-(void)tunerWillPlayChannel:(NSNotification *)notification;

-(BOOL)isEqual:(GBChannel *)obj;
@end
