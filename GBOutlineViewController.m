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
//  GBOutlineViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBOutlineViewController.h"


@implementation GBOutlineViewController

- (id) initWithViewColumn:(NSTableColumn *) vCol
{
    if ((self = [super init]) != nil)
    {
        // Weak references
        subviewTableColumn = vCol;
        subviewTableView = [subviewTableColumn tableView];
        
        // Setup table view delegate and data source
        [subviewTableView setDataSource: self];
        [subviewTableView setDelegate: self];
        
        // Setup cell type for views column
        [subviewTableColumn setDataCell: [[[SubviewTableViewCell alloc] init] autorelease]];
        
        // Setup column properties
        [subviewTableColumn setEditable: NO];
    }
    
    return self;
}

- (void) dealloc
{
    subviewTableView = nil;
    subviewTableColumn = nil;
    delegate = nil;
    
    [super dealloc];
}

+ (id) controllerWithViewColumn:(NSTableColumn *) vCol
{
    return [[[self alloc] initWithViewColumn: vCol] autorelease];
}

- (void) setDelegate:(id) obj
{
    // Check that the object passed to this method supports the required methods
    NSParameterAssert([obj conformsToProtocol: @protocol(SubviewTableViewControllerDataSourceProtocol)]);
    
    // Weak reference
    delegate = obj;
}

- (id) delegate
{
    return delegate;
}

- (void) reloadTableView
{
    while ([[subviewTableView subviews] count] > 0)
    {
		[[[subviewTableView subviews] lastObject] removeFromSuperviewWithoutNeedingDisplay];
    }
    [subviewTableView reloadData];
}

- (BOOL) isValidDelegateForSelector:(SEL) command
{
    return (([self delegate] != nil) && [[self delegate] respondsToSelector: command]);
}

// Methods from NSTableViewDelegate category

- (BOOL) selectionShouldChangeInTableView:(NSOutlineView *) outlineView
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] selectionShouldChangeInOutlineView: outlineView];
    }
    else
    {
	return YES;
    }
}

- (void) outlineView:(NSOutlineView *) outlineView didClickTableColumn:(NSTableColumn *) tableColumn
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: outlineView withObject: tableColumn];
    }
}

- (void) outlineView:(NSOutlineView *) outlineView didDragTableColumn:(NSTableColumn *) tableColumn
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: outlineView withObject: tableColumn];
    }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
	
	if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView:outlineView heightOfRowByItem:item];
    } else{
	return [[item view] bounds].size.height;
	}
}

- (void) outlineView:(NSOutlineView *) outlineView mouseDownInHeaderOfTableColumn:(NSTableColumn *) tableColumn
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: outlineView withObject: tableColumn];
    }
}

- (BOOL) outlineView:(NSOutlineView *) outlineView shouldEditTableColumn:(NSTableColumn *) tableColumn item:(id) item
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView: outlineView shouldEditTableColumn: tableColumn item: item];
    }
    else
    {
	return YES;
    }
}

- (BOOL) outlineView:(NSOutlineView *) outlineView shouldSelectItem:(id) item
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView: outlineView shouldSelectItem: item];
    }
    else
    {
	return YES;
    }
}

- (BOOL) outlineView:(NSOutlineView *) outlineView shouldSelectTableColumn:(NSTableColumn *) tableColumn
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView: outlineView shouldSelectTableColumn: tableColumn];
    }
    else
    {
	return YES;
    }
}

- (void) outlineView:(NSOutlineView *) outlineView willDisplayCell:(id) cell forTableColumn:(NSTableColumn *) tableColumn item:(id) item
{
    if (tableColumn == subviewTableColumn)
    {
        if ([self isValidDelegateForSelector: @selector(outlineView:viewForItem:)])
	{
            // This is one of the few interesting things going on in this class. This is where
            // our custom cell class is assigned the custom view that should be displayed for
            // a particular row.
            
            //[(SubviewTableViewCell *)cell addSubview: [[self delegate] tableView: tableView viewForRow: row]];
			[(SubviewTableViewCell *)cell addSubview:[item view]];
	}
    }
    else
    {
        if ([self isValidDelegateForSelector: _cmd])
	{
	    //[[self delegate] tableView: tableView willDisplayCell: cell forTableColumn: tableColumn row: row];
		[[self delegate] outlineView: outlineView willDisplayCell: cell forTableColumn: tableColumn item: item];
	}
    }
}

- (void) outlineViewColumnDidMove:(NSNotification *) notification
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void) outlineViewColumnDidResize:(NSNotification *) notification
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void) outlineViewSelectionDidChange:(NSNotification *) notification
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void) outlineViewSelectionIsChanging:(NSNotification *) notification
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification{
	if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification{
	if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void)outlineViewItemWillCollapse:(NSNotification *)notification{
	if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification{
	if ([self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] performSelector: _cmd withObject: notification];
    }
}


// Methods from NSTableDataSource protocol

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
	NSInteger count = 0;
    
    if ([self isValidDelegateForSelector: _cmd])
    {
	count = [[self delegate] outlineView:outlineView numberOfChildrenOfItem:item];
    }

    return count;
 }
 
 - (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
	
	if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView:outlineView isItemExpandable:item];
    }
    else
    {
	return NO;
    }
 }
 
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    id obj = nil;

    if ( [self isValidDelegateForSelector: _cmd])
    {
	obj = [[self delegate] outlineView: outlineView child:index ofItem: item];
    }

    return obj;  
}

- (BOOL) outlineView:(NSOutlineView *) outlineView acceptDrop:(id <NSDraggingInfo>) info item:(id) item childIndex:(NSInteger)index
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView:outlineView acceptDrop:info item:item childIndex:index];
    }
    else
    {
	return NO;
    }
}

- (id) outlineView:(NSOutlineView *) outlineView objectValueForTableColumn:(NSTableColumn *) tableColumn byItem:(id) item
{
    id obj = nil;

    if ((tableColumn != subviewTableColumn) && [self isValidDelegateForSelector: _cmd])
    {
	obj = [[self delegate] outlineView: outlineView objectValueForTableColumn: tableColumn byItem: item];
    }

    return obj;
}

- (void) outlineView:(NSOutlineView *) outlineView setObjectValue:(id) obj forTableColumn:(NSTableColumn *) tableColumn byItem:(id) item
{
    if ((tableColumn != subviewTableColumn) && [self isValidDelegateForSelector: _cmd])
    {
	[[self delegate] outlineView: outlineView setObjectValue: obj forTableColumn: tableColumn byItem: item];
    }
}

- (NSDragOperation) outlineView:(NSOutlineView *) outlineView validateDrop:(id <NSDraggingInfo>) info proposedItem:(id) item proposedChildIndex:(NSInteger) index
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView: outlineView validateDrop: info proposedItem: item proposedChildIndex: index];
    }
    else
    {
	return NO;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    if ([self isValidDelegateForSelector: _cmd])
    {
	return [[self delegate] outlineView: outlineView writeItems: items toPasteboard: pboard];
    }
    else
    {
	return NO;
    }
}
@end
