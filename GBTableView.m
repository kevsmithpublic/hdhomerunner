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
//  GBTableView.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/29/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBTableView.h"


@implementation GBTableView
- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
	/*if (!flag) {
		// for external dragged URLs, allow link or copy
		return NSDragOperationLink | NSDragOperationCopy;
	}
	return [super draggingSourceOperationMaskForLocal:flag];*/
	
	//if(flag){
	//	return NSDragOperationLink;
	//} else {
	//	return NSDragOperationNone;
	//}
	return NSDragOperationEvery;
}

-(void)selectionDidChange:(NSNotification *)notification{
	[[self dataSource] setSelectionIndexes:[self selectedRowIndexes]];
}

- (void)awakeFromNib
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];		
	[nc addObserver:self selector: @selector(selectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:self];
}
@end
