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
