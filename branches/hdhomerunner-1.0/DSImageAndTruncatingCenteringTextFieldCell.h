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

#import <Cocoa/Cocoa.h>

@interface DSImageAndTruncatingCenteringTextFieldCell : NSTextFieldCell {
	NSImage *displayImage;
	id originalObjectValue;
}

- (void)setDisplayImage:(NSImage *)anImage;
- (NSImage *)displayImage;

@end
