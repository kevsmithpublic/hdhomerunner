//
//  main.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 7/27/07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
typedef float CGFloat;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
typedef float CGFloat;
#endif*/

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
