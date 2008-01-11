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
//  GBAppDelegate.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBAppDelegate.h"

// The number of tuners per hdhomerun device
#define TUNERS_PER_DEVICE	2

// GUI Definitions
#define TITLE_HEIGHT				11.0
#define TITLE_FONT				@"Lucida Grande Bold"

#define CAPTION_HEIGHT			(TITLE_HEIGHT - 1.0)
#define CAPTION_FONT			@"Helvetica"

//#define ROW_HEIGHT				18.0

@implementation GBAppDelegate

#pragma mark -
#pragma mark  Init Methods
#pragma mark -

- (id)init{
	
	if(self = [super init]){
		
		// Initialize the mutable array of tuners
		tuners = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return self;
}

#pragma mark -
#pragma mark  Finish Launching & Awake from Nib
#pragma mark -

// The application will finish launching. Load contents from disk
- (void)applicationWillFinishLaunching:(NSNotification *)notification{
	

}

// Actions to complete before awaking from the NIB
- (void)awakeFromNib{

	// Load tuners from preferences

	// Locate all the tuners on the network
	NSArray *available_tuners = [self discoverTuners];
	
	// Any tuner not in the preferences but available should be added
	NSEnumerator	*tuner_enumerator = [available_tuners objectEnumerator];
	
	// The tuner
	GBTuner		*tuner;
	
	// Loop over the available tuners and try to add it to tuners
	while(tuner = [tuner_enumerator nextObject]){
	
		// Add the tuner to the array. addTuners: will check if the tuner is already
		// inside tuners so we don't have to check for that here.
		[self addTuner:tuner];
	}
	
	
	// Set the splitters' autosave names.
	//[splitView setPositionAutosaveName:@"SourceListSplitView"];
	//[splitView setPositionAutosaveName:@"ListSplitView"];

	// Set the source list view into the main window
	[sourceListView setFrameSize:[sourceListViewPlaceholder frame].size];
	[sourceListViewPlaceholder addSubview:sourceListView];
	
	// The font to use
	NSFont *font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];

	// Use the font height 
	float fontSize = TITLE_HEIGHT + CAPTION_HEIGHT;
	
	// Padding is the average of the top and bottom of the font
	float padding = ceilf( ( fabs([font ascender]) + fabs([font descender]) ) / 2. );
	
	// fontSize = fontSize * 2;
	fontSize *= 2;
	
	// Pad the fontSize. fontSize = fontSize + padding
	fontSize += padding;
	
	// If the fontSize is greater than 32 then make the larger of the two numbers (fontSize or 32).
	row_height = ( fontSize > 32. ? fontSize : 32. );

	// Set the row height
	[sourceListOutlineView setRowHeight:(row_height + 2.)];
	
	
	// Set up the outline view
	//[genOV setRowHeight:(largerNum + 2.)];
	[sourceListOutlineView setAutoresizesOutlineColumn:NO];
	//[sourceListOutlineView setRoundedSelections:YES];
	//[genOV setDraggingSourceOperationMaskForLocal:NSDragOperationNone external:NSDragOperationCopy];
	//[genOV setRoundedSelections:[[NSUserDefaults standardUserDefaults] boolForKey:@"DSUseRoundedSelections"]];
	//[sourceListOutlineView setUseGradientSelection:[[NSUserDefaults standardUserDefaults] boolForKey:@"DSUseGradientSelections"]];
	//[genOV setUseHighlightColorInBackground:[[NSUserDefaults standardUserDefaults] boolForKey:@"DSUseHighlightInBackground"]];
	
	/*if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"DSUseCustomAlternatingRowColors"] ) {
		NSArray *colorArray = [NSArray arrayWithObjects:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"DSLightColor"]], [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"DSDarkColor"]], nil];
		[genOV setCustomAlternatingRowColors:colorArray];
		setCustomColors = YES;
	}
	[genOV selectRow:0 byExtendingSelection:NO];*/

}

#pragma mark -
#pragma mark  Set, Add, remove, and discover tuners
#pragma mark -

// Get the tuners
- (NSArray *)tuners{
	return tuners;
}

// Set the tuners to new tuners while remaining key value coding compliant
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

// Add a tuner to the array while remaining key value coding complaint
- (void)addTuner:(GBTuner *)newTuner{
	
	// Only add new tuner to the array if it isn't already in there
	if(![tuners containsObject:newTuner]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners addObject:newTuner];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Remove a tuner from the array while remaining key value coding complaint
- (void)removeTuner:(GBTuner *)aTuner{
	
	// Only remove the tuner from the array it is already in there
	if([tuners containsObject:aTuner]){
		
		// Let everyone that the contents of tuners will change
		[self willChangeValueForKey:@"tuners"];

		// Then add the tuner
		[tuners removeObject:aTuner];
		
		// Let everyone know the contents of tuners did change
		[self didChangeValueForKey:@"tuners"]; 
	}
}

// Discover any tuners on the network
- (NSArray *)discoverTuners{
	
	// A temporary array to hold tuners that we find on the network
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
	
	// Set the result list to size 128 to hold up to 128 autodiscovered devices.
	struct hdhomerun_discover_device_t result_list[128];
	
	// Query the network for devices. Return the number of devices into count and populate the devices into the result list.
	uint32_t IP_WILD_CARD = 0;
	int count = hdhomerun_discover_find_devices_custom(IP_WILD_CARD, HDHOMERUN_DEVICE_TYPE_TUNER, HDHOMERUN_DEVICE_ID_WILDCARD, result_list, 128);
	//int count = hdhomerun_discover_find_devices(HDHOMERUN_DEVICE_TYPE_TUNER, result_list, 128);
	
	// Print the number of devices found.
	//NSLog(@"found %d devices", count);
	
	// Loop over all the devices. Create a GBTuner with each device we find.
	
	// The int we are going to use to loop
	int i;
	
	// Loop over each tuner in the results list
	for(i = 0; i < count; i++){
	
		// Assign the hdhomerun's device id parameter to dev_id
		unsigned int dev_id = result_list[i].device_id;

		// The int we are going to loop over
		int j;
		
		// Each hdhomerun physically has more than 1 tuner. Since the result_list does not factor this in
		// we should create an appropriate number of tuners.
		for(j = 0; j < TUNERS_PER_DEVICE; j++){
		
			// Print the tuner and device id that we are about to add
			//NSLog(@"Device ID: %x Tuner Number: %@", [[NSNumber numberWithUnsignedInt:dev_id] unsignedIntValue], [NSNumber numberWithUnsignedInt:j]);
			
			// Allocate the device
			GBTuner *aTuner = [[GBTuner alloc] initWithIdentificationNumber:[NSNumber numberWithUnsignedInt:dev_id] andTunerNumber:[NSNumber numberWithInt:j]];
			
			// Allocate and Initiate a newly created GBTuner object with the device id (dev_id) and tuner number (j)
			[tmp addObject:aTuner];
			
			// Register for notifications of when this objects title, caption, or image values change
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			[notificationCenter addObserver:self selector:@selector(reloadDataForObject:) name:@"GBTunerDataChanged" object:aTuner];
		}
	}
	
	// Return the collection of tuners
	return tmp;
}

#pragma mark -
#pragma mark  Notification Center Methods
#pragma mark -

// Reload the table data for the object posting the notification
- (void)reloadDataForObject:(NSNotification *)notification{

	// Get the object that posted the notification
	GBTuner *theTuner = [notification object];
	
	// Print debug info
	//NSLog(@"notification received from %@", [theTuner title]);
	
	// Get the row of the item that posted the notification
	int row = [sourceListOutlineView rowForItem:theTuner];
	
	// Make sure the row is greater than -1
	if(row > -1){
		
		// Tell the outline view to update only the row that posted the notification
		// This is more efficient than calling reloadData since we are only updating the single
		// cell rather than the entire table.
		[sourceListOutlineView setNeedsDisplayInRect:[sourceListOutlineView rectOfRow:row]];
	}
}

#pragma mark -
#pragma mark  Outlineview Delegate Methods
#pragma mark -

// Specify whether the user should be able to select a particular item
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldSelectItem:(id)item{
	/*if ( [item isKindOfClass:[NSDictionary class]] ) {
		if ( [[item objectForKey:@"String"] isKindOfClass:[NSString class]] ) {
			if ( [[item objectForKey:@"String"] isEqualToString:@""] ) {
				return NO;
			}
		}
	}*/
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldHandleKeyDown:(NSEvent *)keyEvent{
	/*if ( [[olv selectedRowIndexes] count] == 1 ) {
		unichar aChar;
		
		if ( ([keyEvent characters] != nil) && ![keyEvent isARepeat] ) {
			aChar = [[keyEvent characters] characterAtIndex:0];
			if ( (aChar == NSCarriageReturnCharacter) || (aChar == NSEnterCharacter) ) {
				[olv editColumn:0 row:[[olv selectedRowIndexes] firstIndex] withEvent:keyEvent select:YES];
				return NO;
			}
		}
	}*/
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (BOOL)outlineView:(NSOutlineView *)outlineview shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tc item:(id)item{
	if ( textMovement == NSReturnTextMovement )
		return NO;
	else if ( (textMovement == NSTabTextMovement) || (textMovement == NSBacktabTextMovement) ) 
		return NO;
	
	return YES;
}

/* Delegate method with DSGeneralOutlineView */
- (NSImage *)outlineView:(NSOutlineView *)outlineview dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPointPointer)imageLocation dragImageSize:(NSSize)imageSize event:(NSEvent *)event
{
	NSImage *theImage = nil;
	NSPoint mouseLoc = [outlineview convertPoint:[event locationInWindow] fromView:nil];
	int draggedRow = [outlineview rowAtPoint:mouseLoc];
	int thisIndex = [selectedRows firstIndex];
	NSRect imageRect = [outlineview frameOfCellAtColumn:0 row:draggedRow];
	NSTableColumn *myColumn = [outlineview tableColumnWithIdentifier:@"The Column"];
	id anItem = nil;
	NSBezierPath *aPath = [NSBezierPath bezierPath];
	
	if ( [selectedRows containsIndex:draggedRow] && ([selectedRows count] > 1) ) {
		imageRect = NSUnionRect( [outlineview frameOfCellAtColumn:0 row:[selectedRows firstIndex]], [outlineview frameOfCellAtColumn:0 row:[selectedRows lastIndex]] );
		if ( NSHeight(imageRect) > NSHeight([[outlineview enclosingScrollView] documentVisibleRect]) )
			imageRect = NSIntersectionRect( imageRect, [[outlineview enclosingScrollView] documentVisibleRect] );
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
		NSRect totalRect = [[outlineview enclosingScrollView] documentVisibleRect];
		while ( thisIndex != NSNotFound ) {
			NSRect thisRect = [outlineview frameOfCellAtColumn:0 row:thisIndex];
			NSCell *aCell = [[[myColumn dataCellForRow:thisIndex] copy] autorelease];
			float indentLevel = ([outlineview indentationPerLevel] * [outlineview levelForRow:thisIndex]);
			float heightDiff = 0. - NSMinY(totalRect);

			anItem = [outlineview itemAtRow:thisIndex];
			[aCell setObjectValue:[[outlineview dataSource] outlineView:outlineview objectValueForTableColumn:myColumn byItem:anItem]];
			
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
				[aCell drawWithFrame:thisRect inView:[[outlineview window] contentView]];
			}
			thisIndex = [selectedRows indexGreaterThanIndex:thisIndex];
		}
	} else {
		NSCell *aCell = [[[myColumn dataCellForRow:draggedRow] copy] autorelease];
		anItem = [outlineview itemAtRow:draggedRow];
		[aCell setObjectValue:[[outlineview dataSource] outlineView:outlineview objectValueForTableColumn:myColumn byItem:anItem]];
		[aCell drawWithFrame:imageRect inView:[[outlineview window] contentView]];
	}
	[theImage unlockFocus];
	
	return [theImage autorelease];
}


#pragma mark -
#pragma mark  Outlineview Datasource Methods
#pragma mark -

// Return the child of the item at the index
- (id)outlineView:(NSOutlineView *)outlineview child:(int)index ofItem:(id)item{
	
	// NOTE: ? is the ternary operator. It is equivelant to if(){ } else{ }
	// DISCUSSION: http://en.wikipedia.org/wiki/Ternary_operation
	
	// If the item is not null return the objectAtIndex of item
	// Else if item is null return the objectAtIndex of tuners
	
	// Print debug info
	NSLog(@"index = %i item = %@", index, item);

	return [(item ? item : tuners) objectAtIndex:index];
}

// Return YES if the item is expandable
- (BOOL)outlineView:(NSOutlineView *)outlineview isItemExpandable:(id)item{

	// The only expandable items are the Tuners. They will have a drop down of all tuneable channels
	//return [(item ? item : tuners) isKindOfClass:[GBTuner class]];
	return NO;
}

// Return the number of children of the item
- (int)outlineView:(NSOutlineView *)outlineview numberOfChildrenOfItem:(id)item{
	
	// Int to hold the result
	int result = [tuners count];
	
	// If item is not null
	if(item){
	
		// Set the result to the number of channels of the item
		//result = [item numberOfChannels];
		result = 0;
	}
	
	// Print debugging info
	NSLog(@"item = %@ result = %i", item, result);
	
	return result;
}

// The value for the table column
- (id)outlineView:(NSOutlineView *)outlineview objectValueForTableColumn:(NSTableColumn *)tablecolumn byItem:(id)item{

	//NSLog(@"item = %@", item);
	
	if(item){
	
		// The font to use for the title
		NSFont *title_font = [NSFont fontWithName:TITLE_FONT size:TITLE_HEIGHT];
	
		// Attributes to use
		NSDictionary *title_attributes = [NSDictionary dictionaryWithObjectsAndKeys:title_font, NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		
		// The title string
		NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:[item title] attributes:title_attributes] autorelease];
		
		// The font to use for the caption
		NSFont *caption_font = [NSFont fontWithName:CAPTION_FONT size:CAPTION_HEIGHT];
		
		// Attributes to use
		NSDictionary *caption_attributes = [NSDictionary dictionaryWithObjectsAndKeys:caption_font, NSFontAttributeName, [NSColor grayColor], NSForegroundColorAttributeName, nil];
		
		// The caption string below the title
		NSAttributedString *caption = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%s", [[item caption] UTF8String]] attributes:caption_attributes] autorelease];
		
		// Append the two attributed strings
		[string appendAttributedString:caption];
		
		// The image
		NSImage *image = [[[NSImage alloc] initWithData:[[NSApp applicationIconImage] TIFFRepresentation]] autorelease];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize( row_height, row_height )];
		
		return [NSDictionary dictionaryWithObjectsAndKeys:image, @"Image", string, @"String", nil];

	}
	
	return item;
}

- (void)outlineView:(NSOutlineView *)olv setObjectValue:(id)aValue forTableColumn:(NSTableColumn *)tc byItem:(id)item
{
	/* Do Nothing - just wanted to show off my fancy text field cell's editing */
}

#pragma mark -
#pragma mark  Dealloc Methods
#pragma mark -

- (void)dealloc{
	
	[tuners release];
	
	[super dealloc];
}
@end
