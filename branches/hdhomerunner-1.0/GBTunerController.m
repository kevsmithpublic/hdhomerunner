//
//  GBTunerController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBTunerController.h"


@implementation GBTunerController
- (id)init{
	if(self = [super init]){
				
		[self setDescription:@"HDHomerun Tuners"];						// Set the description of the collection
		[self setTitle:@"DEVICES"];										// Set the title of the collection
		[self setIsExpandable:YES];										// Set this is an expandable collection
		[self setChildren:[NSMutableArray arrayWithCapacity:0]];		// Set the collection to initially be empty
		
		[self discoverDevices];
	}
	
	return self;
}

- (void)discoverDevices{
	// Post a notification to indicate the start of device discovery process
	NSNotificationCenter	*defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter postNotificationName:@"GBWillStartDiscoverDevices" object:self];

	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	struct hdhomerun_discover_device_t result_list[128];
	
	// Temporary Array to hold the objects
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	// Query the network for devices. Return the number of devices into count and populate the devices into the result list.
	uint32_t IP_WILD_CARD = 0;
	
	int count = hdhomerun_discover_find_devices_custom(IP_WILD_CARD, HDHOMERUN_DEVICE_TYPE_TUNER, HDHOMERUN_DEVICE_ID_WILDCARD, result_list, 128);
	//int count = hdhomerun_discover_find_devices(HDHOMERUN_DEVICE_TYPE_TUNER, result_list, 128);
	
	// Print the number of devices found.
	NSLog(@"found %d devices", count);
	
	// Loop over all the devices. Create a hddevice with each device we find.
	int i;
	for(i = 0; i < count; i++){
		unsigned int dev_id = result_list[i].device_id;

		// Add each tuner of the device to the tmp array. We will later see if there are any new tuners out there.
		// This method of adding tuners to a tmp array is severly limited and assumes that each HDHomeRun has two and only two tuners.
		// Should SiliconDust release a future HDHomeRun with more than two tuners this alogrithm will have to be altered.
		[tmp addObject:[[GBTuner alloc] initWithIdentification:[NSNumber numberWithInt:dev_id] andTuner:[NSNumber numberWithInt:0]]];
		[tmp addObject:[[GBTuner alloc] initWithIdentification:[NSNumber numberWithInt:dev_id] andTuner:[NSNumber numberWithInt:1]]];
	}
	
	// Add new tuners
	NSEnumerator *newdevice_enumerator = [tmp objectEnumerator];
	
	// The new object to add
	id new_object;
		
	BOOL result;
 
	// While there are discovered tuners
	while ((new_object = [newdevice_enumerator nextObject])) {
		// Check if the new_object is already in tuner arrary (the children)
		result = [[self children] containsObject:new_object];
		
		// If there isn't a match then add the new tuner to the table
		if(!result){
		
			// Post a notification that a new tuner is found and added to the collection
			// The tuner is attached to the notification in the userinfo dictionary
			[defaultCenter postNotificationName:@"GBDidDiscoverDevices" 
										object:self 
										userInfo:[NSDictionary dictionaryWithObjectsAndKeys:new_object, @"tuner", nil ]];
			
			// Add the tuner to the collection
			[self addChild:new_object];
		}
	}
	
	// Post a notification to indicate finished finding devices
	[defaultCenter postNotificationName:@"GBDidEndDiscoverDevices" object:self];
}

// Get the tuner array
- (NSArray *)tuners{
	return [properties objectForKey:@"tuners"];
}

// Set the tuner array
- (void)setTuners:(NSArray *)anArray{

	// Set the starting index to 0
	int index = 0;
	
	// While the index is less than the number of items in the array
	while(index < [anArray count]){
	
		// Add the item at the index to the tuner array
		[self addTuner:[anArray objectAtIndex:index]];
		
		// Increment the index
		index++;
	}
}

// Add the tuner
- (void)addTuner:(GBTuner *)aTuner{
	NSMutableArray *anArray = [properties objectForKey:@"tuners"];
	
	// If anArray doesn't contain aTuner...
	if(![anArray containsObject:aTuner]){
	
		// Add aTuner to the array
		[anArray addObject:aTuner];
	}
}

// Add tuner with description, ID, IP, and number
- (void)addTunerWithDescription:(NSString *)aDescription identification:(NSString *)aID ip:(NSString *)aIP andNumber:(NSNumber *)aNumber{

}

// Remove the tuner 
- (void)removeTuner:(GBTuner *)aTuner{

}

// Remove the tuner with description, ID, IP, and number
- (void)removeTunerWithDescription:(NSString *)aDescription identification:(NSString *)aID ip:(NSString *)aIP andNumber:(NSNumber *)aNumber{

}

// Cleanup
- (void)dealloc{

	[super dealloc];
}
@end
