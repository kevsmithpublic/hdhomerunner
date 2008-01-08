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
//  GBController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBController.h"


@implementation GBController
- (id)initWithWindow:(NSWindow *)window{
	if(self = [super initWithWindow:window]){
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		[self setIsChild:NO];
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"Window"];
	
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

- (void)setChildren:(NSMutableArray *)newContents{
	// If the new children is not the same as the existing children
	if(![[self children] isEqualToArray:newContents]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"children"];
		[properties setObject:newContents forKey:@"children"];
		[self didChangeValueForKey:@"children"];
	}
}

- (void)addChildToParent:(id <GBParent>)aChild{
	
	// Make sure the child is not null or already in the children
	if(aChild && ![[self children] containsObject:aChild]){
		
		// Temporary object to hold the current array contents
		NSMutableArray	*tmp = [self children];
		
		// Add the new child
		[tmp addObject:aChild];
		
		// Set the children
		[self setChildren:tmp];
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

#pragma mark - Archiving And Copying Support

// Init with the contents of a dictionary
- (id)initWithDictionary:(NSDictionary*)dictionary{
	
	// Run the initialization
	if(self = [self init]){
	
		// If dictionary is not null...
		if(dictionary){
		
			// Set the properties dictionary to dictionary
			[properties setDictionary:dictionary];
			
			// If there are children associated with the properities then convert the children
			// from dictionary objects into normal children
			if([[properties allKeys] containsObject:@"children"]){
			
				// Set the dictionary collection of children to dictChildren
				NSArray *dictChildren = [dictionary objectForKey:@"children"];
				
				// Initialize newChildren to be the array for the new children
				NSMutableArray	*newChildren = [NSMutableArray array];
				
				// The enumerator to loop over
				NSEnumerator	*enumerator = [dictChildren objectEnumerator];
				
				// Assign each object in the enumeration to object.
				id object;
 
				while ((object = [enumerator nextObject])){
				
					// Take each dictionary object and create and init a new child
					id newChild = [[[self class] alloc] initWithDictionary:object];
					
					// Add the new child to the newChildren array
					[newChildren addObject:newChild];
					
					// Release the newChild because newChildren will retain it
					[newChild release];
				}
				
				// Set the children to newChildren
				[self setChildren:newChildren];
			}
		}
	}
	
	return self;
}

// Configure the Controller to the specified dictionary
- (void)configureWithDictionary:(NSDictionary *)dictionary{
	
	// If dictionary is not null...
	if(dictionary){
	
		// Set the properties dictionary to dictionary
		//[properties setDictionary:dictionary];
		[self setProperties:dictionary];
		
		// If there are children associated with the properities then convert the children
		// from dictionary objects into normal children
		if([[properties allKeys] containsObject:@"children"]){
		
			// Set the dictionary collection of children to dictChildren
			NSArray *dictChildren = [dictionary objectForKey:@"children"];
			
			// Initialize newChildren to be the array for the new children
			NSMutableArray	*newChildren = [NSMutableArray array];
			
			// The enumerator to loop over
			NSEnumerator	*enumerator = [dictChildren objectEnumerator];
			
			// Assign each object in the enumeration to object.
			id object;

			while ((object = [enumerator nextObject])){
			
				// Take each dictionary object and create and init a new child
				id newChild = [[[self class] alloc] initWithDictionary:object];
				
				// Add the new child to the newChildren array
				[newChildren addObject:newChild];
				
				// Release the newChild because newChildren will retain it
				[newChild release];
			}
			
			// Set the children to newChildren
			[self setChildren:newChildren];
		}
	}
}

// Return a dictionary representation of the controller AND all its children
- (NSDictionary *)dictionaryRepresentation{

	// The dictionary to return. Default is the properties dictionary
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:properties];
	
	// If the dictionary contains children...
	if([[dictionary allKeys] containsObject:@"children"]){
		
		// Set the existing collection of children to existingChildren
		NSArray *existingChildren = [dictionary objectForKey:@"children"];
		
		// We should only continue if there are items in the array
		if([existingChildren count] > 0){
					
			// Initialize dictChildren to be the array for the dictionary representation of the children
			NSMutableArray	*dictChildren = [NSMutableArray array];
					
			// The enumerator to loop over
			NSEnumerator	*enumerator = [existingChildren objectEnumerator];
					
			// Assign each object in the enumeration to object.
			id	object;
	 
			while ((object = [enumerator nextObject])){
					
				// Take each child and make a dictionary representation of that object
				NSDictionary *dictChild = [object dictionaryRepresentation];
				
				// Add the dictionary version of the child to dictChildren
				[dictChildren addObject:dictChild];
			}
			
			// Set the children in dictionary to dictChildren
			[dictionary setObject:dictChildren forKey:@"children"];
		
		}			
	}
	
	return dictionary;
}

#pragma mark - NSCoding Protocol

// Init with the given coder (NSCoding Protocol)
- (id)initWithCoder:(NSCoder*)coder{
	
	// Initialize
	if(self = [self init]){
	
		// Make sure the archive has a key for Controller
		if([coder containsValueForKey:@"Controller"]){
			
			// Initialize with the archived dictionary
			[self initWithDictionary:[coder decodeObjectForKey:@"Controller"]];
		}
	}
	
	return self;
}

// Encode with given coder (NSCoding Protocol)
- (void)encodeWithCoder:(NSCoder*)coder{

	// Encode the object into the coder
	[coder encodeObject:properties forKey:@"Controller"];

	/*// The keys to encode
	NSEnumerator *enumerator = [[properties allKeys] objectEnumerator];

	// A specific key
	NSString *key;

	while (key = [enumerator nextObject]){
	
		// Encode the object into the coder
		[coder encodeObject:[properties objectForKey:key] forKey:key];
	}*/
}

#pragma mark - NSCopying Protocol

// Copy with zone as specified in the NSCopying protocol
- (id)copyWithZone:(NSZone*)zone{

	// Initiate a newNode with the specified zone
	GBController *newNode = [[[self class] allocWithZone:zone] init];
	
	// Set new node to be a copy of self's properties
	[newNode setProperties:[self properties]];
	
	return newNode;
}

// Set the nil value for an empty title and description
- (void)setNilValueForKey:(NSString*)key{

	// If the empty key is the title or description
	if ([key isEqualToString:@"title"] || [key isEqualToString:@"description"]){
		
		// Set the key to a default value. In this case "Untitled"
		[properties setObject:@"Untitled" forKey:key];
	} else{
	
		// Else call the super's setNilValueForKey
		[super setNilValueForKey:key];
	}
}


- (void)dealloc{
	[properties release];
	
	[super dealloc];
}

@end
