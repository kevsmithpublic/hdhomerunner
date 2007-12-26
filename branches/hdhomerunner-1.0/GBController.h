//
//  GBController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GBParent.h"

@interface GBController : NSObject <GBParent> {
		NSMutableDictionary			*properties;
}
- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)newProperties;

- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;

- (id)initChild;

- (BOOL)isChild;
- (void)setIsChild:(BOOL)flag;

- (NSMutableArray *)children;
- (void)setChildren:(NSArray *)newContents;
- (int)numberOfChildren;
- (void)addChild:(id <GBParent>)aChild;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;

- (NSComparisonResult)compare:(GBController <GBParent> *)aParent;
- (BOOL)isEqual:(GBController <GBParent> *)aParent;

- (BOOL)isExpandable;
- (void)setIsExpandable:(BOOL)newState;
@end
