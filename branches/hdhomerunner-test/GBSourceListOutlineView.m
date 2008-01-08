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
//  GBSourceListOutlineView.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBSourceListOutlineView.h"

@implementation GBSourceListOutlineView
- (void)awakeFromNib
{
	//[self setDelegate:self];
	
	/* Make the intercell spacing similar to that used in iCal's Calendars list. */
	[self setRowHeight:18];
    [self setIntercellSpacing:NSMakeSize(0.0, 0.0)];
    
	/* Use our custom NSImageCell subclass for the first column. */
    NSTableColumn *firstCol = [[self tableColumns] objectAtIndex:0];
	SourceListImageCell *theImageCell = [[SourceListImageCell alloc] init];
	[firstCol setDataCell:theImageCell];
	[theImageCell release];
    
	/* Use our custom NSTextFieldCell subclass for the second column. */
    NSTableColumn *secondCol = [[self tableColumns] objectAtIndex:1];
    SourceListTextCell *theTextCell = [[SourceListTextCell alloc] init];
    [secondCol setDataCell:theTextCell];
	[[secondCol dataCell] setFont:[NSFont labelFontOfSize:[NSFont smallSystemFontSize]]];
    [theTextCell release];
}

	


	// Make return and tab only end editing, and not cause other cells to edit.
	// Found this code here: http://www.borkware.com/quickies/one?topic=NSTableView
	// It was not part of the original SourceListTableView routines from Matt Gemmell.
- (void)textDidEndEditing:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
	
    int textMovement = [[userInfo valueForKey:@"NSTextMovement"] intValue];

    if (textMovement == NSReturnTextMovement
			|| textMovement == NSTabTextMovement
			|| textMovement == NSBacktabTextMovement) {

        NSMutableDictionary *newInfo;
        newInfo = [NSMutableDictionary dictionaryWithDictionary: userInfo];

        [newInfo setObject:[NSNumber numberWithInt: NSIllegalTextMovement]
					forKey:@"NSTextMovement"];

        notification = [NSNotification notificationWithName:[notification name]
													 object:[notification object]
												   userInfo:newInfo];

    }

    [super textDidEndEditing: notification];
    [[self window] makeFirstResponder:self];

}




	// If the Delete key is pressed, delete the selected list item.
	// This was not part of the original SourceListTableView routines from Matt Gemmell.
- (void)keyDown:(NSEvent *)theEvent
{
    NSString *tString;
    unsigned int stringLength;
    unsigned int i;
    unichar tChar;
	
    tString = [theEvent characters];
	
    stringLength = [tString length];

    for (i = 0; i < stringLength; i++) {
        tChar = [tString characterAtIndex:i];
		
        if (tChar == 0x7F) {
            NSMenuItem *tMenuItem = [[NSMenuItem alloc] initWithTitle:@""
															   action:@selector(delete:)
														keyEquivalent:@""];
			
            if ([self validateMenuItem:tMenuItem] == YES){
				[[[NSApp keyWindow] delegate] delete:self];
            }else{
                NSBeep();
			}
            [tMenuItem release];
            return;
        }
    }

    [super keyDown:theEvent];
}




- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem
{
    if ([aMenuItem action] == @selector(delete:)) {
        if ([self numberOfSelectedRows]>0){
			return YES;
		}else{
			return NO;
		}
    }
	
    return YES;
}

@end
