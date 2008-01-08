//
//  GBAppDelegate.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBAppDelegate.h"



#pragma mark -
#pragma mark  Definitions
#pragma mark -

#define FONT_HEIGHT				11.0
#define ROW_HEIGHT				18.0

@implementation GBAppDelegate

#pragma mark -
#pragma mark  Init Methods
#pragma mark -

- (id)init{
	if(self = [super init]){
		
		// Initialize the tuner array
		tuners = [[NSMutableArray alloc] initWithCapacity:0];
		
		// Initialize the font
		font = [NSFont fontWithName:@"Lucida Grande" size:FONT_HEIGHT];
		
		// Discover any (new) tuners
		[self discoverTuners];
	}
	
	return self;
}

// Locate tuners on the network
- (void)discoverTuners{

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
		result = [[self tuners] containsObject:new_object];
		
		// If there isn't a match then add the new tuner to the table
		if(!result){
		
			// Post a notification that a new tuner is found and added to the collection
			// The tuner is attached to the notification in the userinfo dictionary
			[defaultCenter postNotificationName:@"GBDidDiscoverDevices" 
										object:self 
										userInfo:[NSDictionary dictionaryWithObjectsAndKeys:new_object, @"tuner", nil ]];
			
			// Add the tuner to the collection
			[self addTuner:new_object];
		}
	}
	
	// Post a notification to indicate finished finding devices
	[defaultCenter postNotificationName:@"GBDidEndDiscoverDevices" object:self];
}

#pragma mark -
#pragma mark  Accessor Methods
#pragma mark -

// Return the tuners
- (NSMutableArray *)tuners{
	return tuners;
}

// Set the tuners to the new tuner array while remaining key value coding compliant.
- (void)setTuners:(NSArray *)newTuners{
	
	// If the new tuner array is not equal the existing array
	if(newTuners && ![tuners isEqualToArray:newTuners]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners setArray:newTuners];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Add a tuner to the tuners array while remaining key value coding compliant.
- (void)addTuner:(GBTuner *)newTuner{
	
	// If the new tuner is not null and not already in the tuner array
	if(newTuner && ![[self tuners] containsObject:newTuner]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners addObject:newTuner];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"];
	}
}

#pragma mark -
#pragma mark Outline View Datasource Methods
#pragma mark -

// If the item exists return the object at index of item. Else item is null and we should return 
// the index specifed within the tuner array
- (id)outlineView:(NSOutlineView *)olv child:(int)myIndex ofItem:(id)item{
	return [(item ? item : tuners) objectAtIndex:myIndex];
}

// The item is expandable if it is of class GBTuner
// As before, if the item is null we should return the tuners array info
- (BOOL)outlineView:(NSOutlineView *)olv isItemExpandable:(id)item{
	return [(item ? item : tuners) isKindOfClass:[GBTuner class]];
}

// The number of children of the item (if item is not null) or the number of tuners (if item is null)
- (int)outlineView:(NSOutlineView *)olv numberOfChildrenOfItem:(id)item{
	return [(item ? item : tuners) count];
}

// Return the value for the item
- (id)outlineView:(NSOutlineView *)olv objectValueForTableColumn:(NSTableColumn *)tc byItem:(id)item{

	// The dictionary to return to the cell
	NSDictionary	*result;
	
	// Use the font height 
	float fontSize = FONT_HEIGHT;
	
	// Padding is the average of the top and bottom of the font
	float padding = ceilf( ( fabs([font ascender]) + fabs([font descender]) ) / 2. );
	
	// fontSize = fontSize * 2;
	fontSize *= 2;
	
	// Pad the fontSize. fontSize = fontSize + padding
	fontSize += padding;
	
	// If the fontSize is greater than 32 then make the larger of the two numbers (fontSize or 32).
	float largerNum = ( fontSize > 32. ? fontSize : 32. );

	// If the item isn't null
	if(item){
		
		// The attributes to apply to the string
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		
		// The string
		NSAttributedString *string = [[[NSAttributedString alloc] initWithString:[item title] attributes:attributes] autorelease];
		
		// The image to draw next to the string
		NSImage *image = [[[NSImage alloc] initWithData:[[item icon] TIFFRepresentation]] autorelease];
		
		// Let the image resize itself automatically
		[image setScalesWhenResized:YES];
		
		// Set its initial size to fit into the cell
		[image setSize:NSMakeSize( largerNum, largerNum )];
		
		// Set the result for display
		result = [NSDictionary dictionaryWithObjectsAndKeys:image, @"Image", string, @"String", nil];
	}
	
	// Return the result
	return result;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tc byItem:(id)item{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
	NSLog(@"GBAppDelegate trying to edit");
}

#pragma mark -
#pragma mark Outline View Delegate Methods
#pragma mark -

- (BOOL)outlineView:(NSOutlineView *)olv shouldSelectItem:(id)item
{
	if ( [item isKindOfClass:[NSDictionary class]] ) {
		if ( [[item objectForKey:@"String"] isKindOfClass:[NSString class]] ) {
			if ( [[item objectForKey:@"String"] isEqualToString:@""] ) {
				return NO;
			}
		}
	}
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)olv shouldHandleKeyDown:(NSEvent *)keyEvent
{
	if ( [[olv selectedRowIndexes] count] == 1 ) {
		unichar aChar;
		
		if ( ([keyEvent characters] != nil) && ![keyEvent isARepeat] ) {
			aChar = [[keyEvent characters] characterAtIndex:0];
			if ( (aChar == NSCarriageReturnCharacter) || (aChar == NSEnterCharacter) ) {
				[olv editColumn:0 row:[[olv selectedRowIndexes] firstIndex] withEvent:keyEvent select:YES];
				return NO;
			}
		}
	}
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)olv shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tc item:(id)item
{
	if ( textMovement == NSReturnTextMovement )
		return NO;
	else if ( (textMovement == NSTabTextMovement) || (textMovement == NSBacktabTextMovement) ) 
		return NO;
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (NSImage *)outlineView:(NSOutlineView *)olv dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPointPointer)imageLocation dragImageSize:(NSSize)imageSize event:(NSEvent *)event
{
	NSImage *theImage = nil;
	NSPoint mouseLoc = [olv convertPoint:[event locationInWindow] fromView:nil];
	int draggedRow = [olv rowAtPoint:mouseLoc];
	int thisIndex = [selectedRows firstIndex];
	NSRect imageRect = [olv frameOfCellAtColumn:0 row:draggedRow];
	NSTableColumn *myColumn = [olv tableColumnWithIdentifier:@"The Column"];
	id anItem = nil;
	NSBezierPath *aPath = [NSBezierPath bezierPath];
	
	if ( [selectedRows containsIndex:draggedRow] && ([selectedRows count] > 1) ) {
		imageRect = NSUnionRect( [olv frameOfCellAtColumn:0 row:[selectedRows firstIndex]], [olv frameOfCellAtColumn:0 row:[selectedRows lastIndex]] );
		if ( NSHeight(imageRect) > NSHeight([[olv enclosingScrollView] documentVisibleRect]) )
			imageRect = NSIntersectionRect( imageRect, [[olv enclosingScrollView] documentVisibleRect] );
	}	
	imageRect.origin.y = 0.;
	imageRect.origin.x = 0.;
	
	imageRect = NSIntegralRect( imageRect );

	[aPath moveToPoint:NSMakePoint(NSMinX(imageRect) + 5., NSMinY(imageRect) )];
	[aPath curveToPoint:NSMakePoint(NSMinX(imageRect), NSMinY(imageRect) + 5.) controlPoint1:NSMakePoint(NSMinX(imageRect) + 2.5, NSMinY(imageRect)) controlPoint2:NSMakePoint(NSMinX(imageRect), NSMinY(imageRect) + 2.5)];
	
	[aPath lineToPoint:NSMakePoint(NSMinX(imageRect), NSMaxY(imageRect) - 5.)];
	[aPath curveToPoint:NSMakePoint(NSMinX(imageRect) + 5., NSMaxY(imageRect)) controlPoint1:NSMakePoint(NSMinX(imageRect), NSMaxY(imageRect) - 2.5) controlPoint2:NSMakePoint(NSMinX(imageRect) + 2.5, NSMaxY(imageRect))];
	
	[aPath lineToPoint:NSMakePoint(NSMaxX(imageRect) - 5., NSMaxY(imageRect))];
	[aPath curveToPoint:NSMakePoint(NSMaxX(imageRect), NSMaxY(imageRect) - 5.) controlPoint1:NSMakePoint(NSMaxX(imageRect) - 2.5, NSMaxY(imageRect)) controlPoint2:NSMakePoint(NSMaxX(imageRect), NSMaxY(imageRect) - 2.5)];
	
	[aPath lineToPoint:NSMakePoint(NSMaxX(imageRect), NSMinY(imageRect) + 5.)];
	[aPath curveToPoint:NSMakePoint(NSMaxX(imageRect) - 5., NSMinY(imageRect)) controlPoint1:NSMakePoint(NSMaxX(imageRect), NSMinY(imageRect) + 2.5) controlPoint2:NSMakePoint(NSMaxX(imageRect) - 2.5, NSMinY(imageRect))];
	[aPath closePath];
	
	theImage = [[NSImage alloc] initWithSize:imageRect.size];
	
	[theImage lockFocus];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[aPath addClip];
	[[[NSColor alternateSelectedControlColor] colorWithAlphaComponent:0.6] set];
	NSRectFillUsingOperation( imageRect, NSCompositeSourceOver );
	[[[NSColor blackColor] colorWithAlphaComponent:0.7] set];
	[aPath stroke];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
	if ( [selectedRows containsIndex:draggedRow] && ([selectedRows count] > 1) ) {
		NSRect totalRect = [[olv enclosingScrollView] documentVisibleRect];
		while ( thisIndex != NSNotFound ) {
			NSRect thisRect = [olv frameOfCellAtColumn:0 row:thisIndex];
			NSCell *aCell = [[[myColumn dataCellForRow:thisIndex] copy] autorelease];
			float indentLevel = ([olv indentationPerLevel] * [olv levelForRow:thisIndex]);
			float heightDiff = 0. - NSMinY(totalRect);

			anItem = [olv itemAtRow:thisIndex];
			[aCell setObjectValue:[[olv dataSource] outlineView:olv objectValueForTableColumn:myColumn byItem:anItem]];
			
			/* There's probably a better way to lay these out, but this is pretty close.
			   I actually spent about 12 hours on just this.  Getting the drag image working.
			   I wish there was an easy way to flip the coordinates... well, since I cut the
			   drag image to be the size of the outline view AND explicitly set its X and Y
			   coordinates to 0, I'm pretty much stuck doing it this way.
			   
			   Oh, and you probably shouldn't be using cells like this.
			*/
			if ( NSIntersectsRect( thisRect, totalRect ) ) {
				thisRect.origin.x = 0.;
				thisRect.origin.x += indentLevel;
				thisRect.origin.y = fabs( ((thisRect.origin.y - 1) + heightDiff) - NSHeight(imageRect) ) - NSHeight( thisRect );
				if ( (NSMinY(thisRect) <= (NSMinY(imageRect) - (NSHeight(thisRect) / 2))) || (NSMaxY(thisRect) >= (NSMaxY(imageRect) + (NSHeight(thisRect) / 2))) ) {
					thisIndex = [selectedRows indexGreaterThanIndex:thisIndex];
					continue;
				}
				[aCell drawWithFrame:thisRect inView:[[olv window] contentView]];
			}
			thisIndex = [selectedRows indexGreaterThanIndex:thisIndex];
		}
	} else {
		NSCell *aCell = [[[myColumn dataCellForRow:draggedRow] copy] autorelease];
		anItem = [olv itemAtRow:draggedRow];
		[aCell setObjectValue:[[olv dataSource] outlineView:olv objectValueForTableColumn:myColumn byItem:anItem]];
		[aCell drawWithFrame:imageRect inView:[[olv window] contentView]];
	}
	[theImage unlockFocus];
	
	return [theImage autorelease];
}


#pragma mark -
#pragma mark  Application Delegate Methods
#pragma mark -

// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed:sender
//
//	NSApplication delegate method placed here so the sample conveniently quits
//	after we close the window.
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

// -------------------------------------------------------------------------------
//	applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	// load the app's main window for display
	//windowController = [[GBWindowController alloc] initWithWindow:[[NSApplication sharedApplication] mainWindow]];
	//windowController = [[GBWindowController alloc] initWithWindowNibName:@"MainWindow"];
	//[windowController showWindow:self];
}

#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{
	[tuners release];
	
	[super dealloc];
}

@end
