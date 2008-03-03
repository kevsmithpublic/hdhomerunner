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
