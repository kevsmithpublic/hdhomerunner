//
//  GBChannel.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBChannel : NSObject {
	NSMutableDictionary			*properties;		// The key value coded properties of the channel
}

- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)newProperties;

- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;

- (NSURL *)url;
- (void)setURL:(NSURL *)newURL;

- (NSNumber *)number;
- (void)setNumber:(NSNumber *)aNumber;

- (NSNumber *)program;
- (void)setProgram:(NSNumber *)aProgram;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

@end
