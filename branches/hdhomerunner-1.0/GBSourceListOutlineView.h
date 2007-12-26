//
//  GBSourceListOutlineView.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SourceListImageCell.h"
#import "SourceListTextCell.h"

#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif

@interface GBSourceListOutlineView : NSOutlineView {

}

@end
