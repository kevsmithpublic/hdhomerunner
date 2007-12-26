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
//  GBController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GBParent.h"

@interface GBController : NSObject <GBParent, NSCoding, NSCopying> {
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

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryRepresentation;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

- (id)copyWithZone:(NSZone*)zone;
- (void)setNilValueForKey:(NSString*)key;
@end
