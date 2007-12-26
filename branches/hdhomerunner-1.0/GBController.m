//
//  GBController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBController.h"


@implementation GBController
- (id)init{
	if(self = [super init]){
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		[self setIsChild:NO];
	}
	
	return self;
}

// Get properties
- (NSDictionary *)properties{
	return properties;
}

// Set properties
- (void)setProperties:(NSDictionary *)newProperties{
	[properties setDictionary:newProperties];
}

// Get the description
- (NSString *)description{
	return [properties valueForKey:@"description"];
}

// Set the description
- (void)setDescription:(NSString *)aDescription{
	[properties setValue:aDescription forKey:@"description"];
}

- (id)initChild{
	if(self = [self init]){
		[self setIsChild:YES];
	}
	
	return self;
}

- (BOOL)isChild{
	return [[properties objectForKey:@"isChild"] boolValue];
}

- (void)setIsChild:(BOOL)flag{
	if([self isChild] != flag){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"isChild"];
		[properties setValue:[NSNumber numberWithBool:flag] forKey:@"isChild"];
		[self didChangeValueForKey:@"isChild"];
	}
}

- (NSMutableArray *)children{
	return [properties valueForKey:@"children"];
}

- (void)setChildren:(NSArray *)newContents{
	// If the new children is not the same as the existing children
	if(![[self children] isEqualToArray:newContents]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"children"];
		[properties setObject:newContents forKey:@"children"];
		[self didChangeValueForKey:@"children"];
	}
}

- (void)addChild:(id <GBParent>)aChild{
	
	if(aChild){
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"children"];
		
		// Temporary object to hold the current array contents
		NSMutableArray	*tmp = [self children];
		
		// Add the new child
		[tmp addObject:aChild];
		
		// Update the properties with the additional child
		[properties setObject:tmp forKey:@"children"];
		
		[self didChangeValueForKey:@"children"];
	}
}

- (int)numberOfChildren{
	return [[self children] count];
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

- (NSString *)title{
	return [properties valueForKey:@"title"];
}

- (void)setTitle:(NSString *)newTitle{
	// If the new title is not the same as the existing title
	if(![[self title] isEqualToString:newTitle]){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"title"];
		[properties setValue:newTitle forKey:@"title"];
		[self didChangeValueForKey:@"title"];
	}
}

- (NSComparisonResult)compare:(GBController <GBParent> *)aParent{
	return NSOrderedSame;
}

// Return wether the receiver is equal to the parent
- (BOOL)isEqual:(GBController <GBParent> *)aParent{
	
	// Assume the two objects are not equal
	BOOL result = NO;
	
	// If the title, description, and children are the same;
	if([[self title] isEqualToString:[aParent title]] && [[self description] isEqualToString:[aParent description]] &&
		[[self children] isEqualToArray:[aParent children]]){
		
		// Then the two objects are equal
		result = YES;
	}
	
	// Return the result
	return result;
}

// Get isExpandable
- (BOOL)isExpandable{
	return [[properties objectForKey:@"isExpandable"] boolValue];
}

// Set isExpandable
- (void)setIsExpandable:(BOOL)newState{
	if([self isExpandable] != newState){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"isExpandable"];
		[properties setObject:[NSNumber numberWithBool:newState] forKey:@"isExpandable"];
		[self didChangeValueForKey:@"isExpandable"];
	}
}

- (void)dealloc{
	[properties release];
	
	[super dealloc];
}

@end
