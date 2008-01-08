/*
	DSGeneralOutlineView - a general purpose outline view subclass.
	
	Copyright (c)2001 - 2007 Night Productions, by Darkshadow. All Rights Reserved.
	Located at: http://www.nightproductions.net/developer.htm
	Email: darkshadow@nightproductions.net
	
	May be used freely, but keep my name/copyright in the header.
	
	I would appreciate any code changes / improvements made sent to me, but
	I do not make that a condition of using this code.
	
	There is NO warranty of any kind, express or implied; use at your own risk.
	Responsibility for damages (if any) to anyone resulting from the use of this
	code rests entirely with the user.
	
	----
	
	This code will compile for 10.3 and up.  It can be made to compile for 10.2 if
	you remove -dragImage:at:offset:event:pasteboard:source:slideBack: or if you
	edit it not to use NSIndexSets.  Note that if you do use this for 10.2, the
	custom alternating row colors won't work.  Everything else will.
	
	---------------------------------------------------------
	* Sometime in 2001 through August 29, 2006 - many revisions,
		created for use with Pref Setter.
	* December 09, 2006 - This version, where I removed some code specific to
		Pref Setter and generalized the outline view for fairly any use.
		Moved the gradient drawing code to this class (was formerly a
		category of NSBezierPath).
	* May 25, 2007 - Fixed up the code a bit; added a new parameter to
		the delegate method that allows you to substitute a custom drag
		image; added a new delegate method to let you know when a drag
		fails.
*/

#import <Cocoa/Cocoa.h>

@interface DSGeneralOutlineView : NSOutlineView {
	NSColor *ds_lightCellColor;
	NSColor *ds_darkCellColor;
	NSColor *ds_secondaryColor;
	NSImage *ds_highlightImage;
	NSImage *ds_secondaryHighlightImage;
	NSDragOperation ds_localOperation;
	NSDragOperation ds_externalOperation;
	float ds_fullRowHeight;
	BOOL ds_roundedSelections;
	BOOL ds_useGradientSelection;
	BOOL ds_useHighlightColorInBackground;
	BOOL ds_useCustomAlternatingRowColors;
	BOOL ds_isFirstResponder;
	BOOL ds_ignoreModKeysInDrag;
}

/* For ease of setting your drag operations without needing to edit the subclass.
   Note that there's a new method on 10.4 that will do this - this is for pre 10.4
   use. It won't hurt anything using this on 10.4 or later, though. */
- (void)setDraggingSourceOperationMaskForLocal:(NSDragOperation)localOperation external:(NSDragOperation)externalOperation;

/* For ease of setting if you want to ignore modifier keys while dragging */
- (void)setIgnoreModifierKeysWhileDragging:(BOOL)aFlag;

/* Sets the custom alternating row colors, and turns them on. */
- (void)setCustomAlternatingRowColors:(NSArray *)colorArray;
- (NSArray *)customAlternatingRowColors;

/* Sets the selections to use rounded edges. */
- (void)setRoundedSelections:(BOOL)aFlag;
- (BOOL)roundedSelections;

/* Sets to use gradient selections.  This is on by default. */
- (void)setUseGradientSelection:(BOOL)aFlag;
- (BOOL)useGradientSelection;

/* Sets to use a bit of the user's highlight color when non first responder.
   Note this is on by default. */
- (void)setUseHighlightColorInBackground:(BOOL)aFlag;
- (BOOL)useHighlightColorInBackground;

/* Sets using the custom alternate row colors.  Note that this doesn't
   do anything if the alternate row colors aren't already set.
   Also note that this flag is turned on automatically when you set
   the custom row colors. */
- (void)setUseCustomAlternatingRowColors:(BOOL)aFlag;
- (BOOL)useCustomAlternatingRowColors;

/* A convenience method to know if we're the first responder.
   Mostly for use in the delegate. */
- (BOOL)isFirstResponder;

/* Delegate methods called by this subclass (if they're implemented):

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldHandleKeyDown:(NSEvent *)keyEvent;

	You can use this to handle key down events in the delegate.  If your delegate handles
	an event, return NO, otherwise return YES to have the outline view process it normally.
	
		- outlineView: the outline view calling the delegate.
		- keyEvent: the pending key down NSEvent.

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tableColumn item:(id)item;

	You can use this to handle text movements (i.e. edits) in the delegate. If your
	delegate handles an event, return NO, otherwise return YES to have the outline
	view process it normally.
	
		- outlineView: the outline view calling the delegate.
		- textMovement: the pending text movement.
		- tableColumn: the table column being edited.
		- item: the item being edited.

- (NSImage *)outlineView:(NSOutlineView *)outlineView dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPoint *)imageLocation event:(NSEvent *)dragEvent;

	You can use this to return a custom drag image.
	
		- outlineView: the outline view calling the delegate.
		- selectedRows: will hold all the rows selected in the outline view.
			  Note it may be empty.
		- selectedColumns: will hold all the columns selected in the outline view.
			  Note it may be empty.
		- imageLocation: a pointer to an NSPoint struct that holds the image location
			  in the outline view's coordinate system.  You can change the point with this
			  if need be.
		- dragEvent: the NSEvent that started the drag.

- (BOOL)outlineViewShouldSlidebackDragImage:(NSOutlineView *)outlineView;

	You can use this method to set whether or not the drag image should slide back
	when it's not accepted / has no where to drop.
	
		- outlineView: the outline view calling the delegate.

- (void)outlineView:(NSOutlineView *)outlineView dragFailed:(NSDragOperation)operation endedAt:(NSPoint)endPoint isInside:(BOOL)isInside
	
	This informs you that a drag has failed.  Note that you can get this message
	for two reasons: either the drag wasn't accepted by any drag source, or the
	user dragged the image over the Trash icon in the Dock.
	
		-outlineView: the outline view for which the drag failed.
		- operation: the drag operation, either NSDragOperationNone for a drag
			that wasn't accepted by anything or NSDragOperationDelete for a
			drag that ended on the Trash icon in the Dock.
		- endPoint: the lower left corner (in screen coordinates) of the drag
			image when the drag failed.
		- isInside: if YES, the drag ended inside the outline view.
*/

@end
