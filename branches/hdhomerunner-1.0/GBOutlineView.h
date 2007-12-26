//
//  GBOutlineView.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GBOutlineView : NSObject {
		IBOutlet	NSOutlineView		*view;		//	The view to delegate to
		
					NSMutableArray		*contents;
}

// Delegate Methods
/*- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;*/
@end
