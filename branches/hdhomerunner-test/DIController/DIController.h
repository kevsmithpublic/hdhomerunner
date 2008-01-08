//
//  Controller.h
//  Dock Icon
//
//  Created by John Devor on 1/9/07.
//	http://johndevor.wordpress.com/2007/01/17/dock-badging-is-fun/
//

#import <Cocoa/Cocoa.h>


@interface DIController : NSObject 
{
	//IBOutlet id textField;
	//IBOutlet id window;
}

- (void)updateApplicationIcon:(id)sender;
- (void)clearApplicationIcon:(id)sender;

@end
