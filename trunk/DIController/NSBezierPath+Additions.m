//
//  NSBezierPath+Additions.m
//  Dock Icon
//
//  Created by John Devor on 1/9/07.
//

#import "NSBezierPath+Additions.h"


@implementation NSBezierPath (Additions)

+ (NSBezierPath *)bezierPathWithRoundRectInRect:(NSRect)aRect radius:(float)radius
{
	NSBezierPath* path = [self bezierPath];
	radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
	NSRect rect = NSInsetRect(aRect, radius, radius);
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
	[path closePath];
	return path;
}

@end

@implementation NSShadow (Additions)

- (id)initWithShadowOffset:(NSSize)offset blurRadius:(float)radius color:(NSColor *)color
{
	if (self = [super init]) {
		[self setShadowOffset:offset];
		[self setShadowBlurRadius:radius];
		[self setShadowColor:color];
	}
	return self;
}

+ (NSShadow *)shadowWithOffset:(NSSize)offset blurRadius:(float)radius color:(NSColor *)color
{
	return [[[NSShadow alloc] initWithShadowOffset:offset blurRadius:radius color:color] autorelease];
}

@end
