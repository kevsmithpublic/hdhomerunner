//
//  NSBezierPath+Additions.h
//  Dock Icon
//
//  Created by John Devor on 1/9/07.
//

#import <Cocoa/Cocoa.h>


@interface NSBezierPath (Additions)

+ (NSBezierPath *)bezierPathWithRoundRectInRect:(NSRect)aRect radius:(float)radius;

@end

@interface NSShadow (Additions)

- (id)initWithShadowOffset:(NSSize)offset blurRadius:(float)radius color:(NSColor *)color;

+ (NSShadow *)shadowWithOffset:(NSSize)offset blurRadius:(float)radius color:(NSColor *)color;

@end
