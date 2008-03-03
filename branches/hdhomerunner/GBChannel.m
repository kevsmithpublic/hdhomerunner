// The MIT License
//
// Copyright (c) 2008 Gregory Barchard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  GBChannel.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBChannel.h"


@implementation GBChannel

#pragma mark -
#pragma mark   Init Methods
#pragma mark -

- (id)init{
	if(self = [super init]){
		
		properties = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return self;
}

- (id)initWithChannelNumber:(NSNumber *)aChannel program:(NSNumber *)aProgram andDescription:(NSString *)aDescription{

	// Call the default init
	if(self = [self init]){
	
		// Set the channel
		[self setChannelNumber:aChannel];
		
		// Set the program
		[self setProgram:aProgram];
		
		// Set the description
		[self setDescription:aDescription];
	}
	
	return self;
}

#pragma mark -
#pragma mark   Accessor Methods
#pragma mark -

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
	if(![[self description] isEqual:aDescription]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"description"];
		[properties setObject:aDescription forKey:@"description"];
		[self didChangeValueForKey:@"description"];
	}
}

// Get the channel number
- (NSNumber *)channelNumber{
	return [properties objectForKey:@"channelNumber"];
}

// Set the channel number
- (void)setChannelNumber:(NSNumber *)aNumber{
	// If the new number is not the same as the existing number
	if(![[self channelNumber] isEqual:aNumber]){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"channelNumber"];
		[properties setObject:aNumber forKey:@"channelNumber"];
		[self didChangeValueForKey:@"channelNumber"];
	}
}

// Get the program number
- (NSNumber *)program{
	return [properties objectForKey:@"program"];
}

// Set the program number
- (void)setProgram:(NSNumber *)aProgram{

	// If the new number is not the same as the existing number
	if(![[self program] isEqual:aProgram]){
	
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

- (NSImage *)smallIcon{
	
	// The image to return
	NSImage *image = [[self icon] copy];
	
	// Set the image's size
	[image setSize:NSMakeSize(16.0f, 16.0f)];
	
	// return the image
	return image;
}

- (NSImage *)icon{
	return [properties objectForKey:@"icon"];
}

- (void)setIcon:(NSImage *)newImage{
	// If the new icon is not the same as the existing icon
	if(![[self icon] isEqual:newImage]){
		
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"smallIcon"];
		[self willChangeValueForKey:@"icon"];
		[properties setObject:newImage forKey:@"icon"];
		[self didChangeValueForKey:@"smallIcon"];
		[self didChangeValueForKey:@"icon"];
	}
}

- (NSString *)title{

	return [properties objectForKey:@"title"];
}

- (void)setTitle:(NSString *)newTitle{
	
	// If the new title is not the same as the existing description
	if([[self title] compare:newTitle] != NSOrderedSame){
	
		// Update the properties to reflect the change and remain key value coding compliant
		[self willChangeValueForKey:@"title"];
		[properties setObject:newTitle forKey:@"title"];
		[self didChangeValueForKey:@"title"];
	}
}


- (NSArray *)recordings{
	
	return nil;
}

- (int)numberOfRecordings{
	
	return 0;
}

// Return YES if the tuner is equal to the given aParent
- (BOOL)isEqual:(GBChannel *)aParent{
	return ((aParent ? [[self program] isEqualToNumber:[aParent program]] && 
			[[self channelNumber] isEqualToNumber:[aParent channelNumber]] : NO));
}


#pragma mark -
#pragma mark  Archiving And Copying Support
#pragma mark -

// Init with the contents of a dictionary
- (id)initWithDictionary:(NSDictionary*)dictionary{
	
	// The dictionary to return
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
	
	// Run the initialization
	if(self = [self init]){
	
		// If dictionary is not null...
		if(dict){
		
			// If there is a URL set then convert the string into a NSURL
			if([[dict allKeys] containsObject:@"url"]){
				
				// Set the URL properly
				[dict setObject:[NSURL URLWithString:[dict objectForKey:@"url"]] forKey:@"url"];
			}
		
			// Set the properties dictionary to dictionary
			[properties setDictionary:dict];
		}
	}

	
	return self;
}

// Return a dictionary representation of the controller AND all its children
- (NSDictionary*)dictionaryRepresentation{

	// The dictionary to return
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:properties];
	
	// If there is a URL associated with the channel then change it to a string for archiving
	if([[dictionary allKeys] containsObject:@"url"]){
		
		// Change the url to string
		[dictionary setObject:[[dictionary objectForKey:@"url"] absoluteString] forKey:@"url"];
	}

	return dictionary;
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

#pragma mark -
#pragma mark   NSCoding Protocol
#pragma mark -

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

#pragma mark -
#pragma mark   NSCopying Protocol
#pragma mark -

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