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
//  GBArrayController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/29/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBArrayController.h"
#define GBTableViewDataType @"GBPasteBoardType"

@implementation GBArrayController
- (void)selectNext:(id)sender{
	[super selectNext:sender];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"GBTunerWillChangeChannel" object:nil];
}

- (void)selectPrevious:(id)sender{
	[super selectPrevious:sender];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"GBTunerWillChangeChannel" object:nil];
}

- (BOOL)tableView:(NSTableView *)tv
		writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard*)pboard{
	
	NSLog(@"should drag");
	BOOL result = NO;
	 
	if([[[self arrangedObjects] objectAtIndex:[rowIndexes firstIndex]] isKindOfClass:[GBChannel class]]){
		// Copy the row numbers to the pasteboard.
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[self arrangedObjects] objectAtIndex:[rowIndexes firstIndex]]];
		[pboard declareTypes:[NSArray arrayWithObject:@"channel"] owner:self];
		[pboard setData:data forType:GBTableViewDataType];
		
		result = YES;
	}
	 
	 return result;
}

- (NSDragOperation)tableView:(NSTableView*)tv
				validateDrop:(id <NSDraggingInfo>)info
				 proposedRow:(int)row
	   proposedDropOperation:(NSTableViewDropOperation)op{
	
	if ([info draggingSource] == tableView){
		return NSDragOperationNone;
    }
	
	[tv setDropRow:row dropOperation:NSTableViewDropOn];
	
	NSLog(@"validate Drop");
    //return NSDragOperationEvery;
	return NSDragOperationGeneric;
	//return NSDragOperationLink;  
}

- (BOOL)tableView:(NSTableView*)tv
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(int)row
	dropOperation:(NSTableViewDropOperation)op{
	
	NSLog(@"accept drop");
	
	NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:GBTableViewDataType];
	//NSLog(@"tv = %@", [[[[tv dataSource] arrangedObjects] objectAtIndex:row] setChannel:[NSKeyedUnarchiver unarchiveObjectWithData:rowData]]);
	[[[self arrangedObjects] objectAtIndex:row] setChannel:[NSKeyedUnarchiver unarchiveObjectWithData:rowData]];
	NSLog(@"data %@", [NSKeyedUnarchiver unarchiveObjectWithData:rowData]);
    //NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    //int dragRow = [rowIndexes firstIndex];
	

	
	return YES;
}

- (void)awakeFromNib
{
	[tableView registerForDraggedTypes:[NSArray arrayWithObject:GBTableViewDataType]];
}
@end
