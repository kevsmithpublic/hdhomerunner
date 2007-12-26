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
//  GBTunerController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "hdhomerun.h"

#import "GBTuner.h"
#import "GBController.h"

// GBTunerController conforms to the GBParent protocol because it is considered the Parent of multiple tuners
@interface GBTunerController : GBController {

}
/*-(NSDictionary *)properties;
-(void)setProperties:(NSDictionary *)newProperties;

- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;*/

- (void)discoverDevices;

- (NSArray *)tuners;
- (void)setTuners:(NSArray *)anArray;

- (void)addTuner:(GBTuner *)aTuner;
- (void)addTunerWithDescription:(NSString *)aDescription identification:(NSString *)aID ip:(NSString *)aIP andNumber:(NSNumber *)aNumber;

- (void)removeTuner:(GBTuner *)aTuner;
- (void)removeTunerWithDescription:(NSString *)aDescription identification:(NSString *)aID ip:(NSString *)aIP andNumber:(NSNumber *)aNumber;
@end
