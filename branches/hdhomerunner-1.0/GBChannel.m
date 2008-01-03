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
		
		[self setIsExpandable:NO];
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

#pragma mark - GBParent Protocol Methods

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
	if(flag != [self isChild]){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"isChild"];
		[properties setObject:[NSNumber numberWithBool:flag] forKey:@"isChild"];
		[self didChangeValueForKey:@"isChild"];
	}
}

- (NSMutableArray *)children{
	return nil;
}

- (void)setChildren:(NSArray *)newContents{

}

- (int)numberOfChildren{
	return 0;
}

- (NSImage *)icon{
	return [properties objectForKey:@"icon"];
}

- (void)setIcon:(NSImage *)newImage{
	// If the new icon is not the same as the existing icon
	if([[self icon] isEqual:newImage] != NSOrderedSame){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"icon"];
		[properties setObject:newImage forKey:@"icon"];
		[self didChangeValueForKey:@"icon"];
	}
}

- (NSString *)title{
	return [self description];
	//return [properties objectForKey:@"title"];
}

- (void)setTitle:(NSString *)newTitle{
	[self setDescription:newTitle];
	// If the new title is not the same as the existing description
	/*if([[self title] compare:newTitle] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"title"];
		[properties setObject:newTitle forKey:@"title"];
		[self didChangeValueForKey:@"title"];
	}*/
}

- (NSComparisonResult)compare:(<GBParent> *)aParent{
	return NSOrderedSame;
}

// Return YES if the tuner is equal to the given aParent
- (BOOL)isEqual:(GBChannel <GBParent> *)aParent{
	return ([[self description] isEqualToString:[aParent description]] &&
			[[self title] isEqualToString:[aParent title]] &&
			[[self program] isEqualToNumber:[aParent program]] && 
			[[self number] isEqualToNumber:[aParent number]]);
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
		
		// If the title is null we should set it to be the same as the description (if it isn't null)
		/*if([[self title] isEqualToString:@""]){
		
			// Make sure the description isn't null
			if(![[self description] isEqualToString:@""]){
			
				// Set the title
				[self setTitle:[self description]];
				
			} else {
				
				// Else the title and description are null and should be something.. more friendly
				[self setTitle:@"Untitled"];
				[self setDescription:@"Untitled"];
			}
		}*/
	}
	
	return self;
}

// Return a dictionary representation of the controller AND all its children
- (NSDictionary*)dictionaryRepresentation{
	return properties;
	// The dictionary to return. Default is the properties dictionary
	/*NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:properties];
	
	// If the dictionary contains children...
	if([[dictionary allKeys] containsObject:@"children"]){
	
		// Set the existing collection of children to existingChildren
		NSArray *existingChildren = [dictionary objectForKey:@"children"];
				
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
			
			// Release the dictChild because dictChildren will retain it
			[dictChild release];
		}
				
		// Set the children in dictionary to dictChildren
		[dictionary setObject:dictChildren forKey:@"children"];
	}
	
	return dictionary;*/
}

#pragma mark - NSCoding Protocol

// Init with the given coder (NSCoding Protocol)
- (id)initWithCoder:(NSCoder*)coder{
	
	// Initialize
	if(self = [self init]){
	
		// Make sure the archive has a key for Controller
		if([coder containsValueForKey:@"Channel"]){
			
			// Initialize with the archived dictionary
			[self initWithDictionary:[coder decodeObjectForKey:@"Channel"]];
		}
	}
	
	return self;
}

// Encode with given coder (NSCoding Protocol)
- (void)encodeWithCoder:(NSCoder*)coder{

	// Encode the object into the coder
	[coder encodeObject:properties forKey:@"Channel"];

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
	GBChannel *newNode = [[[self class] allocWithZone:zone] init];
	
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

#pragma mark - Clean up

- (void)dealloc{
	[properties release];

	[super dealloc];
}
@end