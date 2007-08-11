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
//  GBArrayController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/29/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GBChannel;
@class GBTuner;

@interface GBArrayController : NSArrayController {
		IBOutlet NSTableView *tableView;		// The tableview associated with the array controller
}
-(void)selectionDidChange:(NSNotification *)notification;

/*
 support for drag and drop
 */

- (BOOL)tableView:(NSTableView *)tv
		writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard*)pboard;

- (NSDragOperation)tableView:(NSTableView*)tv
				validateDrop:(id <NSDraggingInfo>)info
				 proposedRow:(int)row
	   proposedDropOperation:(NSTableViewDropOperation)op;

- (BOOL)tableView:(NSTableView*)tv
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(int)row
	dropOperation:(NSTableViewDropOperation)op;
@end
