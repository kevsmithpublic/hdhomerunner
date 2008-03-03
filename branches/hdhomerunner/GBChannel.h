// The MIT License
//
// Copyright (c) 2008 Gregory Barchard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  GBChannel.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBChannel : NSObject {
	NSMutableDictionary			*properties;		// The key value coded properties of the channel
}
- (id)initWithChannelNumber:(NSNumber *)aChannel program:(NSNumber *)aProgram andDescription:(NSString *)aDescription;

- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)newProperties;

- (NSString *)description;
- (void)setDescription:(NSString *)aDescription;

- (NSURL *)url;
- (void)setURL:(NSURL *)newURL;

- (NSNumber *)channelNumber;
- (void)setChannelNumber:(NSNumber *)aNumber;

- (NSNumber *)program;
- (void)setProgram:(NSNumber *)aProgram;

- (NSImage *)smallIcon;
- (NSImage *)icon;
- (void)setIcon:(NSImage *)newImage;

- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;

- (NSArray *)recordings;
- (int)numberOfRecordings;

- (BOOL)isEqual:(GBChannel *)aParent;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)dictionaryRepresentation;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

- (id)copyWithZone:(NSZone*)zone;
- (void)setNilValueForKey:(NSString*)key;
@end