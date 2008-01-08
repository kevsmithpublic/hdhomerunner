//
//  GBParent.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// The parent object is the root object of the tree.
// It can contain an image next to it but this is usually nil.
// Parent objects contain a collection of children who themselves may be also be parents.

/*@interface GBParent : NSObject {
	// The image next to the branch (if any)
	NSImage					*icon;
	
	// The title of the branch
	NSString				*title;
	
	// The contents of the branch
	NSMutableArray			*children;
	
	BOOL					isChild;
	
	id						representedObject;
}*/

@protocol GBParent
- (id)initChild;

- (BOOL)isChild;
- (void)setIsChild:(BOOL)flag;

- (NSMutableArray *)children;
- (void)setChildren:(NSArray *)newContents;
- (int)numberOfChildren;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;

- (NSComparisonResult)compare:(<GBParent> *)aParent;
- (BOOL)isEqual:(<GBParent> *)aParent;

- (BOOL)isExpandable;
- (void)setIsExpandable:(BOOL)newState;
@end

