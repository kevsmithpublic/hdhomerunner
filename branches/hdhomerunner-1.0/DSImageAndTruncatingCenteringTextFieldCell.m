/*
	DSImageAndTruncatingCenteringTextFieldCell (That's a mouth full...)
	
	Copyright (c) 2006 Night Productions, by Darkshadow. All Rights Reserved.
	http://www.nightproductions.net/developer.htm
	darkshadow@nightproductions.net
	
	May be used freely, but keep my name/copyright in the header.
	
	There is NO warranty of any kind, express or implied; use at your own risk.
	Responsibility for damages (if any) to anyone resulting from the use of this
	code rests entirely with the user.
	
	------------------------------------
	
	* December 09, 2006 - initial version
*/

#import "DSImageAndTruncatingCenteringTextFieldCell.h"

@implementation DSImageAndTruncatingCenteringTextFieldCell

- (void)dealloc
{
	[displayImage release];
	[originalObjectValue release];
	
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)aZone
{
	DSImageAndTruncatingCenteringTextFieldCell *cell = (DSImageAndTruncatingCenteringTextFieldCell *)[super copyWithZone:aZone];
	cell->displayImage = nil;
	cell->originalObjectValue = nil;
	
	return cell;
}

- (void)setDisplayImage:(NSImage *)anImage
{
	if ( anImage != displayImage ) {
		[anImage retain];
		[displayImage release];
		displayImage = anImage;
	}
}

- (NSImage *)displayImage
{
	return [[displayImage retain] autorelease];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSSize aSize = [[self attributedStringValue] size];
    float height = ( (aSize.height < cellFrame.size.height) ? aSize.height : cellFrame.size.height );
    NSRect imageFrame, strFrame;
	
	if ( displayImage != nil ) {
		NSSize imageSize = [displayImage size];
	
		NSDivideRect( cellFrame, &imageFrame, &cellFrame, 3 + imageSize.width, NSMinXEdge );
		
		imageFrame.origin.x += 3;
		imageFrame.size = imageSize;
		
		if ( NSMidY(imageFrame) != NSMidY(cellFrame) ) {
			float diff = ceilf( fabs( NSMidY(imageFrame) - NSMidY(cellFrame) ) );
				imageFrame.origin.y += diff;
			if ( [controlView isFlipped] ) {
				[displayImage setFlipped:YES];
			} else {
				[displayImage setFlipped:NO];
			}
		}
		
		[[NSGraphicsContext currentContext] saveGraphicsState];
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		
		[displayImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.];
		
		[[NSGraphicsContext currentContext] restoreGraphicsState];
	}
	
	cellFrame.origin.x += 5;
	cellFrame.size.width -= 15;
	
	cellFrame = NSIntegralRect( cellFrame );
	
	strFrame = NSMakeRect( cellFrame.origin.x, cellFrame.origin.y, aSize.width, height );
	
	if ( NSWidth(strFrame) > NSWidth(cellFrame) - 1. ) {
		NSMutableDictionary *attribs = [[[[self attributedStringValue] attributesAtIndex:0 effectiveRange:NULL] mutableCopy] autorelease];
		if ( [[attribs objectForKey:NSParagraphStyleAttributeName] lineBreakMode] != NSLineBreakByTruncatingMiddle ) {
			NSMutableAttributedString *myStr = [[[self attributedStringValue] mutableCopy] autorelease];
			NSMutableParagraphStyle *aStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
			[aStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
			[attribs setObject:aStyle forKey:NSParagraphStyleAttributeName];
			[myStr setAttributes:attribs range:NSMakeRange(0, [myStr length])];
			[self setAttributedStringValue:myStr];
		}
	}
    
	if ( NSMidY(strFrame) != NSMidY(cellFrame) ) {
		float diff = ceilf( fabs( NSMidY(strFrame) - NSMidY(cellFrame) ) );
		cellFrame.origin.y += diff;
		cellFrame.size.height = height;
		cellFrame = NSIntegralRect( cellFrame );
	}

    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)selectWithFrame:(NSRect)editRect inView:(NSView *)controlView editor:(NSText *)fieldEditor delegate:(id)anObject start:(int)selStart length:(int)selLength
{
	NSAttributedString *myStr = [self attributedStringValue];
	NSSize aSize = [myStr size];
	NSMutableDictionary *attributes = nil;
	float height = ( (aSize.height < editRect.size.height) ? aSize.height : editRect.size.height );
	
	if ( displayImage != nil ) {
		NSSize imageSize = [displayImage size];
		NSRect imageFrame;
		
		NSDivideRect( editRect, &imageFrame, &editRect, 3 + imageSize.width, NSMinXEdge );
	}
	
	editRect.origin.x += 5;
	editRect.size.width -= 15;
	
	editRect = NSIntegralRect( editRect );

	if ( [myStr length] == 0 ) {
		attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:0.], NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		editRect.origin.y += (editRect.size.height / 4);
		editRect.size.height /= 2;
	} else {
		attributes = [[[myStr attributesAtIndex:0 effectiveRange:NULL] mutableCopy] autorelease];
		
		if ( aSize.width < NSWidth(editRect) - 1. ) {
			NSRect strFrame = NSMakeRect( editRect.origin.x, editRect.origin.y, aSize.width, height );
			if ( NSMidY(strFrame) != NSMidY(editRect) ) {
				float diff = ceilf( fabs( NSMidY(strFrame) - NSMidY(editRect) ) );
				editRect.origin.y += diff;
				editRect.size.height = height;
				editRect = NSIntegralRect( editRect );
			}
		}
	}

	[super selectWithFrame:editRect inView:controlView editor:fieldEditor delegate:anObject start:selStart length:selLength];
	
	[attributes setObject:[NSColor textColor] forKey:NSForegroundColorAttributeName];
	
	[(NSTextView *)fieldEditor setTypingAttributes:attributes];
	[fieldEditor setFont:[attributes objectForKey:NSFontAttributeName]];
	
	if ( [[(NSTextView *)fieldEditor textStorage] length] > 0 ) {
		[[(NSTextView *)fieldEditor textStorage] setAttributes:attributes range:NSMakeRange(0, [[(NSTextView *)fieldEditor textStorage] length])];
	}
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	NSAttributedString *myStr = [self attributedStringValue];
	NSSize aSize = [myStr size];
	NSMutableDictionary *attributes = nil;
	float height = ( (aSize.height < aRect.size.height) ? aSize.height : aRect.size.height );
	
	if ( displayImage != nil ) {
		NSSize imageSize = [displayImage size];
		NSRect imageFrame;
		
		NSDivideRect( aRect, &imageFrame, &aRect, 3 + imageSize.width, NSMinXEdge );
	}
	
	aRect.origin.x += 5;
	aRect.size.width -= 15;
	
	aRect = NSIntegralRect( aRect );

	if ( [myStr length] == 0 ) {
		attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:0.], NSFontAttributeName, [NSColor textColor], NSForegroundColorAttributeName, nil];
		aRect.origin.y += (aRect.size.height / 4);
		aRect.size.height /= 2;
	} else {
		attributes = [[[myStr attributesAtIndex:0 effectiveRange:NULL] mutableCopy] autorelease];
		
		if ( aSize.width < NSWidth(aRect) - 1. ) {
			NSRect strFrame = NSMakeRect( aRect.origin.x, aRect.origin.y, aSize.width, height );
			if ( NSMidY(strFrame) != NSMidY(aRect) ) {
				float diff = ceilf( fabs( NSMidY(strFrame) - NSMidY(aRect) ) );
				aRect.origin.y += diff;
				aRect.size.height = height;
				aRect = NSIntegralRect( aRect );
			}
		}
	}

	[super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
	
	[attributes setObject:[NSColor textColor] forKey:NSForegroundColorAttributeName];
	
	[(NSTextView *)textObj setTypingAttributes:attributes];
	[textObj setFont:[attributes objectForKey:NSFontAttributeName]];
	
	if ( [[(NSTextView *)textObj textStorage] length] > 0 ) {
		[[(NSTextView *)textObj textStorage] setAttributes:attributes range:NSMakeRange(0, [[(NSTextView *)textObj textStorage] length])];
	}
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	return nil;
}

- (void)setObjectValue:(id)anObj
{
	if ( [anObj isKindOfClass:[NSDictionary class]] ) {
		[self setDisplayImage:[anObj objectForKey:@"Image"]];
		[super setObjectValue:[anObj objectForKey:@"String"]];
		//[self setDisplayImage:[anObj objectForKey:@"icon"]];
		//[super setObjectValue:[anObj objectForKey:@"title"]];
		[originalObjectValue release];
		originalObjectValue = [anObj retain];
		return;
	} else if ( [anObj isKindOfClass:[NSAttributedString class]] ) {
		[super setObjectValue:anObj];
		return;
	}
	
	[originalObjectValue release];
	originalObjectValue = nil;
	
	[self setDisplayImage:nil];
	
	[super setObjectValue:anObj];
}

- (id)objectValue
{
	if ( originalObjectValue != nil ) {
		return [[originalObjectValue retain] autorelease];
	}
	
	return [super objectValue];
}

@end
