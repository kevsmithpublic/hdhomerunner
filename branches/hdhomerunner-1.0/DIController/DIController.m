//
//  Controller.m
//  Dock Icon
//
//  Created by John Devor on 1/9/07.
//	http://johndevor.wordpress.com/2007/01/17/dock-badging-is-fun/
//

#import "DIController.h"
#import "NSBezierPath+Additions.h"

#define WIDTH_OFFSET 24
#define HEIGHT_OFFSET 10

static NSImage *originalIcon = nil;

@implementation DIController

/*- (void)awakeFromNib
{
	[window center];
}*/

- (void)updateApplicationIcon:(id)sender
{
	NSImage *appIcon;
	NSBezierPath *path;
	NSAttributedString *iconString;
	NSRect iconRect;
	
	if (!originalIcon)
		originalIcon = [[NSApp applicationIconImage] copy];
	appIcon = [originalIcon copy];
	
	[[NSApp applicationIconImage] copy];
	
	// Create a reusable attributes dictionary for our icon text.
	static NSDictionary *iconAttributes = nil;
	if (!iconAttributes) {
		iconAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:
			[NSColor whiteColor], NSForegroundColorAttributeName,
			[NSFont boldSystemFontOfSize:30], NSFontAttributeName,
			NULL] retain];
	}
	
	// Create the attributed string.
	iconString = [[[NSAttributedString alloc] initWithString:[sender stringValue]
												 attributes:iconAttributes] autorelease];
	
	// Determine the size of the text's rect.
	iconRect.size.width = [iconString size].width + WIDTH_OFFSET;
	iconRect.size.height = [iconString size].height + HEIGHT_OFFSET;
	if (iconRect.size.width < iconRect.size.height) 
		iconRect.size.width = iconRect.size.height;
	iconRect.origin.x = [appIcon size].width - iconRect.size.width - 5;
	iconRect.origin.y = [appIcon size].height - iconRect.size.height;
	
	/* Here's where all the drawing takes place. */
	[appIcon lockFocus];
	{
		// Draw the white background.
		[NSGraphicsContext saveGraphicsState];
		[[NSShadow shadowWithOffset:NSMakeSize(0, -2) blurRadius:4.0 color:[NSColor colorWithCalibratedWhite:0.0 alpha:0.8]] set];
		path = [NSBezierPath bezierPathWithRoundRectInRect:iconRect radius:iconRect.size.height / 2.0];
		[[NSColor whiteColor] set];
		[path fill];	
		[NSGraphicsContext restoreGraphicsState];
		
		// Draw the green background by taking an inset of the white background.
		iconRect = NSInsetRect(iconRect, 2, 2);
		path = [NSBezierPath bezierPathWithRoundRectInRect:iconRect radius:iconRect.size.height / 2.0];
		[[NSColor colorWithCalibratedRed:0.0 green:0.776 blue:0.0 alpha:1.0] set]; 		/* This is the green color */
		//[[NSColor colorWithCalibratedRed:0.11 green:0.435 blue:1.0 alpha:1.0] set];		/* This is the blue color */
		[path fill];
		
		// Drawing with the shadow enabled seems to make the string thinner, so we're drawing it twice. 
		[NSGraphicsContext saveGraphicsState];
		[[NSShadow shadowWithOffset:NSMakeSize(0, -2) blurRadius:1.0 color:[NSColor colorWithCalibratedWhite:0.00 alpha:0.65]] set];
		[iconString drawAtPoint:NSMakePoint((iconRect.size.width - [iconString size].width) / 2.0 + NSMinX(iconRect),
											(iconRect.size.height - [iconString size].height) / 2.0 + NSMinY(iconRect))];
		[NSGraphicsContext restoreGraphicsState];
		[iconString drawAtPoint:NSMakePoint((iconRect.size.width - [iconString size].width) / 2.0 + NSMinX(iconRect),
											(iconRect.size.height - [iconString size].height) / 2.0 + NSMinY(iconRect))];
	}
	[appIcon unlockFocus];
	
	// Update the application with the new icon.
	[NSApp setApplicationIconImage:appIcon];
	[appIcon release];
}

- (void)clearApplicationIcon:(id)sender
{
	[NSApp setApplicationIconImage:originalIcon];
}


@end
