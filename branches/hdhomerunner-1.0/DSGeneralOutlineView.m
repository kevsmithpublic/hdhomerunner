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

#import "DSGeneralOutlineView.h"


@implementation DSGeneralOutlineView

#pragma mark -
#pragma mark Callback Functions
#pragma mark -

void blendOutlineColors( void *info, const float *input, float *output )
{
	float *colors = (float *)info;
	
	output[0] = fabsf( colors[0] - (colors[4] * input[0]) );
	output[1] = fabsf( colors[1] - (colors[5] * input[0]) );
	output[2] = fabsf( colors[2] - (colors[6] * input[0]) );
	output[3] = fabsf( colors[3] - (colors[7] * input[0]) );
}

#pragma mark -
#pragma mark Class Initialization / Deallocation
#pragma mark -

- (id)initWithCoder:(NSCoder *)aCoder
{
	if ( (self = [super initWithCoder:aCoder]) ) {
		/*set to use gradient selections by default*/
		ds_useGradientSelection = YES;
		/*set to use highlight color when not first responder for selections*/
		ds_useHighlightColorInBackground = YES;
		ds_localOperation = NSDragOperationGeneric;
		ds_externalOperation = NSDragOperationNone;
		ds_fullRowHeight = ([self rowHeight] + [self intercellSpacing].height);
		ds_roundedSelections = NO;
		ds_useCustomAlternatingRowColors = NO;
		ds_ignoreModKeysInDrag = YES;
		ds_lightCellColor = nil;
		ds_darkCellColor = nil;
		ds_highlightImage = nil;
		ds_secondaryHighlightImage = nil;
		ds_secondaryColor = [[[NSColor secondarySelectedControlColor] blendedColorWithFraction:0.15 ofColor:[NSColor alternateSelectedControlColor]] retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemColorsChanged:) name:NSSystemColorsDidChangeNotification object:nil];
	}
	
	return self;
}

- (id)initWithFrame:(NSRect)viewFrame
{
	if ( (self = [super initWithFrame:viewFrame]) ) {
		/*set to use gradient selections by default*/
		ds_useGradientSelection = YES;
		/*set to use highlight color when not first responder for selections*/
		ds_useHighlightColorInBackground = YES;
		ds_localOperation = NSDragOperationGeneric;
		ds_externalOperation = NSDragOperationNone;
		ds_fullRowHeight = ([self rowHeight] + [self intercellSpacing].height);
		ds_roundedSelections = NO;
		ds_useCustomAlternatingRowColors = NO;
		ds_ignoreModKeysInDrag = YES;
		ds_lightCellColor = nil;
		ds_darkCellColor = nil;
		ds_highlightImage = nil;
		ds_secondaryHighlightImage = nil;
		ds_secondaryColor = [[[NSColor secondarySelectedControlColor] blendedColorWithFraction:0.15 ofColor:[NSColor selectedControlColor]] retain];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemColorsChanged:) name:NSSystemColorsDidChangeNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[ds_lightCellColor release];
	[ds_darkCellColor release];
	[ds_secondaryColor release];
	[ds_highlightImage release];
	[ds_secondaryHighlightImage release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSSystemColorsDidChangeNotification object:nil];

	[super dealloc];
}

#pragma mark -
#pragma mark Subclassed Methods
#pragma mark -

- (BOOL)becomeFirstResponder
{
	ds_isFirstResponder = [super becomeFirstResponder];
	return ds_isFirstResponder;
}

- (BOOL)resignFirstResponder
{
	ds_isFirstResponder = [super resignFirstResponder];
	if ( ds_isFirstResponder ) {
		/* Test to see if we're resigning first responder to the field editor.*/
		ds_isFirstResponder = [(NSView *)[[self window] firstResponder] isDescendantOf:self];
		return YES;
	}
	
	return ds_isFirstResponder;
}

- (void)setIntercellSpacing:(NSSize)aSize
{
	ds_fullRowHeight = ([self rowHeight] + aSize.height);
	[ds_highlightImage release];
	ds_highlightImage = nil;
	[ds_secondaryHighlightImage release];
	ds_secondaryHighlightImage = nil;
	[super setIntercellSpacing:aSize];
}

- (void)setRowHeight:(float)rowHeight
{
	ds_fullRowHeight = (rowHeight + [self intercellSpacing].height);
	[ds_highlightImage release];
	ds_highlightImage = nil;
	[ds_secondaryHighlightImage release];
	ds_secondaryHighlightImage = nil;
	[super setRowHeight:rowHeight];
}

- (void)setDraggingSourceOperationMask:(unsigned int)mask forLocal:(BOOL)isLocal
{
	if ( isLocal )
		ds_localOperation = mask;
	else
		ds_externalOperation = mask;
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
    if (isLocal)
		return ds_localOperation;
    
	return ds_externalOperation;
}

- (BOOL)ignoreModifierKeysWhileDragging
{
    return ds_ignoreModKeysInDrag;
}

#pragma mark -
#pragma mark Methods Calling Custom Delegate Methods
#pragma mark -

/* I got very tired of needing to change the subclass every time I wanted to do some
   sort of key handling.  So I created a new delegate handler to do this instead.
   Now, the delegate just needs to implement
   - (BOOL)outlineView:(NSOutlineView *)outlineView shouldHandleKeyDown:(NSEvent *)keyEvent
   and return NO if it handles the keydown itself or YES if it doesn't (which will have
   the outline view handle it as it normally would).
*/
-(void)keyDown:(NSEvent *)event
{
	if ( [[self delegate] respondsToSelector:@selector(outlineView:shouldHandleKeyDown:)] ) {
		SEL delSelector = @selector(outlineView:shouldHandleKeyDown:);
		BOOL returnValue = YES;
		NSInvocation *delInv = [NSInvocation invocationWithMethodSignature:[[self delegate] methodSignatureForSelector:delSelector]];
		[delInv setTarget:[self delegate]];
		[delInv setSelector:delSelector];
		[delInv setArgument:&self atIndex:2];
		[delInv setArgument:&event atIndex:3];
		[delInv invoke];
		[delInv getReturnValue:&returnValue];
		
		if ( returnValue ) {
			[super keyDown:event];
		}
	} else {
		[super keyDown:event];
	}
}

/* Same as the above, but for editing purposes.  If you want to restrict what normally happens
   (i.e. you don't want a tab event to go to the next table cell), implement
   - (BOOL)outlineView:(NSOutlineView *)outlineView shouldAllowTextMovement:(unsigned int)textMovement tableColumn:(NSTableColumn *)tableColumn item:(id)item
   in your delegate and return NO if the delegate handles it or YES if you want the
   outline view to handle it normally.
*/
- (void)textDidEndEditing:(NSNotification *)notification;
{
	if ( [[self delegate] respondsToSelector:@selector(outlineView:shouldAllowTextMovement:tableColumn:item:)] ) {
		unsigned int textMovement = [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue];
		BOOL returnValue = YES;
		id item = [self itemAtRow:[self editedRow]];
		NSTableColumn *tableColumn = [[self tableColumns] objectAtIndex:[self editedColumn]];
		NSInvocation *textInv = [NSInvocation invocationWithMethodSignature:[[self delegate] methodSignatureForSelector:@selector(outlineView:shouldAllowTextMovement:tableColumn:item:)]];
		
		[textInv setTarget:[self delegate]];
		[textInv setSelector:@selector(outlineView:shouldAllowTextMovement:tableColumn:item:)];
		[textInv setArgument:&self atIndex:2];
		[textInv setArgument:&textMovement atIndex:3];
		[textInv setArgument:&tableColumn atIndex:4];
		[textInv setArgument:&item atIndex:5];
		[textInv invoke];
		[textInv getReturnValue:&returnValue];
		
		if ( !returnValue ) {
			NSMutableDictionary *replacedInfo = [[[notification userInfo] mutableCopy] autorelease];
			NSNotification *replacedNotification = nil;
			[replacedInfo setObject:[NSNumber numberWithInt:NSIllegalTextMovement] forKey:@"NSTextMovement"];
			replacedNotification = [NSNotification notificationWithName:[notification name] object:[notification object] userInfo:replacedInfo];
			[super textDidEndEditing:replacedNotification];
			[[self window] makeFirstResponder:self];
			return;
		}
	}
	
	[super textDidEndEditing:notification];
}

/* Draw the drag image.  If your delegate implements
   - (NSImage *)outlineView:(NSOutlineView *)outlineView dragImageForSelectedRows:(NSIndexSet *)selectedRows selectedColumns:(NSIndexSet *)selectedColumns dragImagePosition:(NSPoint *)imageLocation dragImageSize:(NSSize)imageSize event:(NSEvent *)dragEvent
   it will use the returned image as the drag image.
   Additionally, if your delegate implements
   - (BOOL)outlineViewShouldSlidebackDragImage:(NSOutlineView *)outlineView
   it will use the return value to decide if the image will slideback or not.
*/
- (void)dragImage:(NSImage *)anImage at:(NSPoint)imageLoc offset:(NSSize)mouseOffset event:(NSEvent *)theEvent pasteboard:(NSPasteboard *)pboard source:(id)sourceObject slideBack:(BOOL)slideBack
{
	NSImage *dragImage = nil;
	BOOL shouldSlideBack = slideBack;
	
	if ( [[self delegate] respondsToSelector:@selector(outlineView:dragImageForSelectedRows:selectedColumns:dragImagePosition:dragImageSize:event:)] ) {
		SEL delSel = @selector(outlineView:dragImageForSelectedRows:selectedColumns:dragImagePosition:dragImageSize:event:);
		NSIndexSet *selectedRows = [self selectedRowIndexes];
		NSIndexSet *selectedColumns = [self selectedColumnIndexes];
		NSPoint *pntr = &imageLoc;
		NSSize imgSize = [anImage size];
		NSInvocation *delInv = [NSInvocation invocationWithMethodSignature:[[self delegate] methodSignatureForSelector:delSel]];
		[delInv setTarget:[self delegate]];
		[delInv setSelector:delSel];
		[delInv setArgument:&self atIndex:2];
		[delInv setArgument:&selectedRows atIndex:3];
		[delInv setArgument:&selectedColumns atIndex:4];
		[delInv setArgument:&pntr atIndex:5];
		[delInv setArgument:&imgSize atIndex:6];
		[delInv setArgument:&theEvent atIndex:7];
		[delInv invoke];
		[delInv getReturnValue:&dragImage];
	}
	if ( [[self delegate] respondsToSelector:@selector(outlineViewShouldSlidebackDragImage:)] ) {
		NSInvocation *delInv = [NSInvocation invocationWithMethodSignature:[[self delegate] methodSignatureForSelector:@selector(outlineViewShouldSlidebackDragImage:)]];
		[delInv setTarget:[self delegate]];
		[delInv setSelector:@selector(outlineViewShouldSlidebackDragImage:)];
		[delInv setArgument:&self atIndex:2];
		[delInv invoke];
		[delInv getReturnValue:&shouldSlideBack];
	}
	
	if ( dragImage == nil )
		dragImage = anImage;
	
	[super dragImage:dragImage at:imageLoc offset:mouseOffset event:theEvent pasteboard:pboard source:sourceObject slideBack:shouldSlideBack];
}

/*	Drag has ended.  If your delegate implements
	- (void)tableView:(NSTableView *)tableView dragFailed:(NSDragOperation)operation endedAt:(NSPoint)endPoint isInside:(BOOL)isInside
	it will inform your delegate if the drag fails due to it not being accepted or having been dragged
	to the Trash icon in the Dock.
*/
- (void)draggedImage:(NSImage *)anImage endedAt:(NSPoint)aPoint operation:(NSDragOperation)op
{
	if ( ((op == NSDragOperationNone) || (op == NSDragOperationDelete)) && [[self delegate] respondsToSelector:@selector(outlineView:dragFailed:endedAt:isInside:)] ) {
		NSInvocation *dragInv = [NSInvocation invocationWithMethodSignature:[[self delegate] methodSignatureForSelector:@selector(outlineView:dragFailed:endedAt:isInside:)]];
		NSPoint cursPoint = [NSEvent mouseLocation];
		NSPoint myPoint = [self convertPoint:[[self window] convertScreenToBase:cursPoint] fromView:nil];
		BOOL isInside = NSPointInRect( myPoint, [self visibleRect] );
		[dragInv setTarget:[self delegate]];
		[dragInv setSelector:@selector(outlineView:dragFailed:endedAt:isInside:)];
		[dragInv setArgument:&self atIndex:2];
		[dragInv setArgument:&op atIndex:3];
		[dragInv setArgument:&aPoint atIndex:4];
		[dragInv setArgument:&isInside atIndex:5];
		[dragInv invoke];
	}
	
	[super draggedImage:anImage endedAt:aPoint operation:op];
}

#pragma mark -
#pragma mark Setters / Getters
#pragma mark -

/* For ease of setting your drag operations without needing to edit the subclass
   Note that there's a new method on 10.4 that will do this - this is for pre 10.4
   use.
*/
- (void)setDraggingSourceOperationMaskForLocal:(NSDragOperation)localOperation external:(NSDragOperation)externalOperation
{
	ds_localOperation = localOperation;
	ds_externalOperation = externalOperation;
}

/* For ease of setting if you want to ignore modifier keys while dragging */
- (void)setIgnoreModifierKeysWhileDragging:(BOOL)aFlag
{
	ds_ignoreModKeysInDrag = aFlag;
}

/* Sets the custom alternating row colors, and turns them on. */
- (void)setCustomAlternatingRowColors:(NSArray *)colorArray
{
	if ( colorArray == nil ) {
		ds_useCustomAlternatingRowColors = NO;
		[ds_lightCellColor release];
		ds_lightCellColor = nil;
		[ds_darkCellColor release];
		ds_darkCellColor = nil;
	} else {
		NSAssert( ([colorArray count] >= 2), @"This implementation of custom alternating row colors needs two row colors." );
		
		[ds_lightCellColor release];
		ds_lightCellColor = [[colorArray objectAtIndex:0] retain];
		[ds_darkCellColor release];
		ds_darkCellColor = [[colorArray objectAtIndex:1] retain];
		
		ds_useCustomAlternatingRowColors = YES;
	}
	
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

- (NSArray *)customAlternatingRowColors
{
	return [NSArray arrayWithObjects:ds_lightCellColor, ds_darkCellColor, nil];
}

/* Sets the selections to use rounded edges. */
- (void)setRoundedSelections:(BOOL)aFlag
{
	ds_roundedSelections = aFlag;
	[ds_highlightImage release];
	ds_highlightImage = nil;
	[ds_secondaryHighlightImage release];
	ds_secondaryHighlightImage = nil;
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

- (BOOL)roundedSelections
{
	return ds_roundedSelections;
}

/* Sets to use gradient selections.  This is on by default. */
- (void)setUseGradientSelection:(BOOL)aFlag
{
	ds_useGradientSelection = aFlag;
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

- (BOOL)useGradientSelection
{
	return ds_useGradientSelection;
}

/* Sets to use a bit of the user's highlight color when non first responder.
   Note this is on by default.
*/
- (void)setUseHighlightColorInBackground:(BOOL)aFlag
{
	ds_useHighlightColorInBackground = aFlag;
	[ds_secondaryColor release];
	if ( aFlag )
		ds_secondaryColor = [[[NSColor secondarySelectedControlColor] blendedColorWithFraction:0.15 ofColor:[NSColor alternateSelectedControlColor]] retain];
	else
		ds_secondaryColor = [[NSColor secondarySelectedControlColor] retain];
	
	[ds_secondaryHighlightImage release];
	ds_secondaryHighlightImage = nil;
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

- (BOOL)useHighlightColorInBackground
{
	return ds_useHighlightColorInBackground;
}

/* Sets using the custom alternate row colors.  Note that this doesn't
   do anything if the alternate row colors aren't already set.
   Also note that this flag is turned on automatically when you set
   the custom row colors.
*/
- (void)setUseCustomAlternatingRowColors:(BOOL)aFlag
{
	ds_useCustomAlternatingRowColors = aFlag;
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

- (BOOL)useCustomAlternatingRowColors
{
	return ds_useCustomAlternatingRowColors;
}

/* A convenience method to know if we're the first responder.
   Mostly for use in the delegate.
*/
- (BOOL)isFirstResponder
{
	return ds_isFirstResponder;
}

#pragma mark -
#pragma mark Drawing Row Background / Selection Methods
#pragma mark -

/* Draws a gradient in the given rect starting with the start color at the top blending
   to the end color at the bottom. Note that this blends the alpha components as well.
*/
- (void)gradientFillInRect:(NSRect)fillRect startColor:(NSColor *)startColor endColor:(NSColor *)endColor
{
	NSAssert( [[startColor colorSpaceName] isEqualToString:NSDeviceRGBColorSpace], @"Start color must be converted to device color space before use." );
	NSAssert( [[endColor colorSpaceName] isEqualToString:NSDeviceRGBColorSpace], @"End color must be converted to device color space before use." );
	
	struct CGFunctionCallbacks callbacks = { 0, blendOutlineColors, NULL };
	float colors[8] = {
		[startColor redComponent],
		[startColor greenComponent],
		[startColor blueComponent],
		[startColor alphaComponent],
		fabsf( [startColor redComponent] - [endColor redComponent] ),
		fabsf( [startColor greenComponent] - [endColor greenComponent] ),
		fabsf( [startColor blueComponent] - [endColor blueComponent] ),
		fabsf( [startColor alphaComponent] - [endColor alphaComponent] )
	};
	CGFunctionRef callbackFunction = CGFunctionCreate( colors, 1, NULL, 4, NULL, &callbacks );
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGPoint src = { NSMinX(fillRect), NSMaxY(fillRect) };
	CGPoint dst = { NSMinX(fillRect), NSMinY(fillRect) };
	
	CGShadingRef shading = CGShadingCreateAxial( colorspace, src, dst, callbackFunction, NO, NO );
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSaveGState( context );
	
	CGContextSetShouldAntialias( context, true );
	CGContextDrawShading( context, shading );
	
	CGContextRestoreGState( context );
	
	CGShadingRelease( shading );
	CGColorSpaceRelease( colorspace );
	CGFunctionRelease( callbackFunction );
}
	

/* If we're using custom alternating row colors, draw them here.
   This would be the "official" way of doing it, rather than overriding
   the private method _alternatingRowBackgroundColors.
   Note that this method only exists in 10.3 and later (my way of saying this only works on
   10.3 and later).
*/
- (void)drawBackgroundInClipRect:(NSRect)clipRect
{
	if ( ds_useCustomAlternatingRowColors && (ds_lightCellColor != nil) && (ds_darkCellColor != nil) ) {
		NSRect myClipRect = [self bounds];
		NSRect drawRect = { {0, 0}, {myClipRect.size.width, ds_fullRowHeight} };
		BOOL firstRow = YES;
		
		[[self backgroundColor] set];
		NSRectFillUsingOperation( clipRect, NSCompositeSourceOver ); 
		
		while ( (NSMinY(drawRect) <= NSHeight(myClipRect)) ) {
			if ( NSIntersectsRect( drawRect, myClipRect ) ) {
				firstRow ? [ds_lightCellColor set] : [ds_darkCellColor set];
				NSRectFillUsingOperation( drawRect, NSCompositeSourceOver );
			}
			firstRow = !firstRow;
			drawRect.origin.y += ds_fullRowHeight;
		}
	} else {
		[super drawBackgroundInClipRect:clipRect];
	}
}

/* Creates the gradient highlight image if it's not already created. */
- (NSImage *)highlightImage
{
	if ( ds_highlightImage == nil ) {
		NSColor *ds_primaryStartColor = [[[NSColor alternateSelectedControlColor] highlightWithLevel:0.25] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		NSColor *ds_primaryEndColor = [[[NSColor alternateSelectedControlColor] shadowWithLevel:0.19] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		NSRect rowRect = NSMakeRect( 0, 0, NSWidth([self frame]), ds_fullRowHeight - 1 );

		ds_highlightImage = [[NSImage alloc] initWithSize:rowRect.size];
		[ds_highlightImage setFlipped:[self isFlipped]];

		[ds_highlightImage lockFocus];
		if ( ds_roundedSelections ) {
			NSBezierPath *aPath = [NSBezierPath bezierPath];
			float endCapPoint = ( ds_fullRowHeight / 3 );
			[aPath moveToPoint:NSMakePoint( NSMinX(rowRect) + endCapPoint, NSMinY(rowRect))];
			[aPath curveToPoint:NSMakePoint( NSMinX(rowRect) + endCapPoint, NSMaxY(rowRect)) controlPoint1:NSMakePoint( NSMinX(rowRect) - 2., NSMinY(rowRect) - 2. ) controlPoint2:NSMakePoint( NSMinX(rowRect) - 2., NSMaxY(rowRect) + 2. )];
			[aPath lineToPoint:NSMakePoint( NSMaxX(rowRect) - endCapPoint, NSMaxY(rowRect) )];
			[aPath curveToPoint:NSMakePoint( NSMaxX(rowRect) - endCapPoint, NSMinY(rowRect) ) controlPoint1:NSMakePoint( NSMaxX(rowRect) + 2., NSMaxY(rowRect) + 2. ) controlPoint2:NSMakePoint( NSMaxX(rowRect) + 2., NSMinY(rowRect) - 2. )];
			[aPath closePath];
			[aPath setClip];
		}
		[[NSColor alternateSelectedControlColor] set];
		NSRectFillUsingOperation( rowRect, NSCompositeSourceOver );
		[self gradientFillInRect:rowRect startColor:ds_primaryStartColor endColor:ds_primaryEndColor];
		[ds_highlightImage unlockFocus];
	}
	
	return [[ds_highlightImage retain] autorelease];
}

/* Creates the non first responder highlight image.
   This image is only created when using rounded row selections.
*/
- (NSImage *)secondaryHighlightImage
{
	if ( ds_secondaryHighlightImage == nil ) {
		NSRect rowRect = NSMakeRect( 0, 0, [self frame].size.width, ds_fullRowHeight - 1 );
		NSBezierPath *aPath = [NSBezierPath bezierPath];
		float endCapPoint = ( ds_fullRowHeight / 3 );
		
		ds_secondaryHighlightImage = [[NSImage alloc] initWithSize:rowRect.size];
		[ds_secondaryHighlightImage setFlipped:[self isFlipped]];
		
		[aPath moveToPoint:NSMakePoint( NSMinX(rowRect) + endCapPoint, NSMinY(rowRect) )];
		[aPath curveToPoint:NSMakePoint( NSMinX(rowRect) + endCapPoint, NSMaxY(rowRect) ) controlPoint1:NSMakePoint( NSMinX(rowRect) - 2., NSMinY(rowRect) - 2. ) controlPoint2:NSMakePoint( NSMinX(rowRect) - 2., NSMaxY(rowRect) + 2. )];
		[aPath lineToPoint:NSMakePoint( NSMaxX(rowRect) - endCapPoint, NSMaxY(rowRect) )];
		[aPath curveToPoint:NSMakePoint( NSMaxX(rowRect) - endCapPoint, NSMinY(rowRect) ) controlPoint1:NSMakePoint( NSMaxX(rowRect) + 2., NSMaxY(rowRect) + 2. ) controlPoint2:NSMakePoint( NSMaxX(rowRect) + 2., NSMinY(rowRect) - 2. )];
		[aPath closePath];
		
		
		[ds_secondaryHighlightImage lockFocus];
		[aPath setClip];
		[ds_secondaryColor set];
		NSRectFillUsingOperation( rowRect, NSCompositeSourceOver );
		[ds_secondaryHighlightImage unlockFocus];
	}
	
	return [[ds_secondaryHighlightImage retain] autorelease];
}

/* Draws the highlight.  If we're using gradient selections, will use that.
   Otherwise, just calls to super.
   Note that it uses images.  This is because the shading code can bog things
   down quite badly if there are a lot of items selected and it's used
   to create the highlight every single time.
*/
- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	if ( ds_useGradientSelection ) {
		BOOL isFirst = ( ([NSApp keyWindow] == [self window]) && ds_isFirstResponder );
		NSRange visible = [self rowsInRect:clipRect];
		unsigned int j = visible.location;
		unsigned int total = visible.length + j;
		
		if ( [self inLiveResize] ) {
			[ds_highlightImage release];
			ds_highlightImage = nil;
			[ds_secondaryHighlightImage release];
			ds_secondaryHighlightImage = nil;
		} else if ( NSWidth([self bounds]) != [ds_highlightImage size].width ) {
			[ds_highlightImage release];
			ds_highlightImage = nil;
			[ds_secondaryHighlightImage release];
			ds_secondaryHighlightImage = nil;
		}
		
		while ( j <= total ) {
			if ( [self isRowSelected:j] ) {
				NSRect rowRect = [self rectOfRow:j];
				
				rowRect.size.height -= 1;
				
				if ( isFirst ) {
					[[self highlightImage] drawInRect:rowRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.];
				} else if ( ds_roundedSelections ) {
					[[self secondaryHighlightImage] drawInRect:rowRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.];
				} else {
					[ds_secondaryColor set];
					NSRectFillUsingOperation( rowRect, NSCompositeSourceOver );
				}
			}
			j++;
		}
	} else {
		[super highlightSelectionInClipRect:clipRect];
	}
}

#pragma mark -
#pragma mark Notifications
#pragma mark -

/* Notification to handle if the user changes the highlight color */
- (void)systemColorsChanged:(NSNotification *)changeNote
{
	[ds_secondaryColor release];
	
	if ( ds_useHighlightColorInBackground )
		ds_secondaryColor = [[[NSColor secondarySelectedControlColor] blendedColorWithFraction:0.15 ofColor:[NSColor alternateSelectedControlColor]] retain];
	else
		ds_secondaryColor = [[NSColor secondarySelectedControlColor] retain];
	
	[ds_highlightImage release];
	ds_highlightImage = nil;
	[ds_secondaryHighlightImage release];
	ds_secondaryHighlightImage = nil;
	
	if ( [[self window] isVisible] )
		[self setNeedsDisplayInRect:[[self enclosingScrollView] documentVisibleRect]];
}

@end
