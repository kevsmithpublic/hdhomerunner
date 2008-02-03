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
//
//  GBOutlineViewController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SubviewTableViewCell.h"

// Based on code from SubviewTableViewController.h
// Joar Wingfors joar.com
@interface GBOutlineViewController : NSObject {

    @private

    NSTableView *subviewTableView;
    NSTableColumn *subviewTableColumn;

    id delegate;
}

// Convenience factory method
+ (id) controllerWithViewColumn:(NSTableColumn *) vCol;

// The delegate is required to conform to the SubviewTableViewControllerDataSourceProtocol
- (void) setDelegate:(id) obj;
- (id) delegate;

// The method to call instead of the standard "reloadData" method of NSTableView.
// You need to call this method at any time that you would have called reloadData
// on a table view.
- (void) reloadTableView;

@end

@protocol SubviewTableViewControllerDataSourceProtocol

// The view retreived will not be retained, and will be resized to fit the
// cell in the table view. Please adjust the row height and column width in
// ib (or in code) to make sure that it is appropriate for the views used.
//- (NSView *) outlineView:(NSTableView *) outlineview viewForRow:(int) row;
//- (NSView *) tableView:(NSTableView *) tableView viewForRow:(int) row;
- (NSView *) outlineView:(NSOutlineView *) outlineview viewForItem:(id) item;
@end
