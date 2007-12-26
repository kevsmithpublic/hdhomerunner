//
//  GBChannel.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannel.h"


@implementation GBChannel

- (id)init{
	if(self = [super init]){
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
	}
	
	return self;
}

#pragma mark - Accessor Methods

// Get properties
- (NSDictionary *)properties{
	return properties;
}

// Set properties
- (void)setProperties:(NSDictionary *)newProperties{
	// Update the properties and remain key value coding compliant
	[self willChangeValueForKey:@"properties"];
	[properties setDictionary:newProperties];
	[self didChangeValueForKey:@"properties"];
}

// Get identification number
- (NSNumber *)identification{
	return [properties objectForKey:@"identification"];
}

// Get the description
- (NSString *)description{
	return [properties objectForKey:@"description"];
}

// Set the description
- (void)setDescription:(NSString *)aDescription{
	// If the new description is not the same as the existing description
	if([[self description] compare:aDescription] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"description"];
		[properties setObject:aDescription forKey:@"description"];
		[self didChangeValueForKey:@"description"];
	}
}

// Get the channel number
- (NSNumber *)number{
	return [properties objectForKey:@"number"];
}

// Set the channel number
- (void)setNumber:(NSNumber *)aNumber{
	// If the new number is not the same as the existing number
	if([[self number] compare:aNumber] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"number"];
		[properties setObject:aNumber forKey:@"number"];
		[self didChangeValueForKey:@"number"];
	}
}

// Get the program number
- (NSNumber *)program{
	return [properties objectForKey:@"program"];
}

// Set the program number
- (void)setProgram:(NSNumber *)aProgram{
	// If the new number is not the same as the existing number
	if([[self program] compare:aProgram] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"program"];
		[properties setObject:aProgram forKey:@"program"];
		[self didChangeValueForKey:@"program"];
	}
}

- (NSImage *)icon{
	return [properties objectForKey:@"icon"];
}
- (void)setIcon:(NSImage *)newImage{
	if(![[self icon] isEqual:newImage]){
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"icon"];
		[properties setObject:newImage forKey:@"icon"];
		[self didChangeValueForKey:@"icon"];
	}
}

- (NSURL *)url{
	return [properties objectForKey:@"url"];
}

- (void)setURL:(NSURL *)newURL{
	if(![[[self url] absoluteString] isEqualToString:[newURL absoluteString]]){
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"url"];
		[properties setObject:newURL forKey:@"url"];
		[self didChangeValueForKey:@"url"];
	}
}

#pragma mark - Clean up

- (void)dealloc{
	[properties release];

	[super dealloc];
}
@end
