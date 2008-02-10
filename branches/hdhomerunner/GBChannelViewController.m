//    This file is part of hdhomerunner.

//    hdhomerunner is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    hdhomerunner is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//
//  GBChannelViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBChannelViewController.h"


@implementation GBChannelViewController

// Initialize
- (id)init{

	// Call the super class's init
	if(self = [super init]){
		
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed: @"ChannelView" owner: self]){
            
			// Release
			[self release];
			
			// Point to nil
            self = nil;
        }
	}

	return self;
}

- (void)awakeFromNib{
	
	// Let the image view adjust any image in it automatically
	[_imageView setImageScaling:NSScaleProportionally];
	
}

#pragma mark -
#pragma mark  Acessor Methods
#pragma mark -

// Set the channel to the new channel
- (void)setChannel:(GBChannel *)aChannel{
	
	// If the tuner is not nil and not the same as the existing tuner
	if((aChannel != nil) && ![channel isEqual:aChannel]){
		
		// Set the subview to not observe changes for a new tuner
		//[self unRegisterSubviewsForTuner:[self tuner]];
		
		// Key value coding
		[self willChangeValueForKey:@"channel"];
		
		// Auto release the current tuner
		[channel autorelease];
		
		// Free the tuner
		channel = nil;
		
		// Assign tuner to the new tuner and retain it
		channel = [aChannel retain];
		
		// Key value coding
		[self didChangeValueForKey:@"channel"];
		
		// Set the subview to observe changes for a new tuner
		//[self registerSubviewsForTuner:channel];
		
		// Reload the view 
		[self reloadView];
	}
}

// Return the tuner
- (GBChannel *)channel{

	return channel;
}

#pragma mark -
#pragma mark  Register for KVO
#pragma mark -

// Register for Key Value Coding of the tuner
// When the signal strength changes we should update the view
- (void)registerAsObserverForTuner:(GBChannel *)aChannel{
	
	[aChannel addObserver:self
			forKeyPath:@"description"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
					
	[aChannel addObserver:self
			forKeyPath:@"url"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];
			
	[aChannel addObserver:self
			forKeyPath:@"icon"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];
}

- (void)unRegisterAsObserverForTuner:(GBChannel *)aChannel{

    [aChannel removeObserver:self forKeyPath:@"description"];
	[aChannel removeObserver:self forKeyPath:@"url"];
	[aChannel removeObserver:self forKeyPath:@"icon"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath
						ofObject:(id)object
                        change:(NSDictionary *)change
						context:(void *)context {
	
	// Lock the view
	//[[[self view] superview] lockFocus];
	
	// If the signal strength changed
	if ([keyPath isEqual:@"description"]) {
		
		// Update the level indicator
		[_description setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
		
    } else if([keyPath isEqual:@"url"]) {

		// Update the level indicator
		[_url setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
	} else if([keyPath isEqual:@"icon"]) {

		// Update the level indicator
		[_imageView setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
	}
	
	// Unlock the view
	//[[[self view] superview] unlockFocus];
}


#pragma mark -
#pragma mark  Update the views
#pragma mark -

- (void)reloadView{
	
	// Update the fields appropriately
	[_description setObjectValue:[[self channel] description]];
	[_channelNumber setObjectValue:[[self channel] channelNumber]];
	[_program setObjectValue:[[self channel] program]];
	[_url setObjectValue:[[self channel] url]];
	[_imageView setObjectValue:[[self channel] icon]];
}

#pragma mark -
#pragma mark  Text field Delegate Methods
#pragma mark -

- (void)controlTextDidEndEditing:(NSNotification *)notification{
	
	// The textfield posting the notification
	NSTextField *textfield = [notification object];
	
	// Figure out which text field is posting the notification
	if(textfield == _url){
		
		// Update the url of the channel
		NSURL *url = [NSURL URLWithString:[self autoCompletedHTTPStringFromString:[_url stringValue]]];
		[[self channel] setURL:url];
	} else if(textfield == _description){
		
		// Update the description of the channel
		[[self channel] setDescription:[_description stringValue]];
	}
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
	
	// The result to return
	BOOL result = YES;
	
	// If the text is nil
	if([[fieldEditor string] isEqualToString:@""]){
		
		// Then the user shouldn't be allowed to finish editing
		result = NO;
	}
	
	return result;
}

#pragma mark -
#pragma mark  Image view Methods
#pragma mark -

- (IBAction)setIcon:(id)sender{
	
	// The image to save
	NSImage *image = [_imageView image];
	
	// Make sure the image isn't nil
	if (image){
	
		// Set the image's size
		//[image setSize:NSMakeSize(16.0f, 16.0f)];
	
		// Update the icon of the channel
		[[self channel] setIcon:image];
	}

}

#pragma mark -
#pragma mark  URL Methods
#pragma mark -

// Taken from URLFormatter.h
/* given a string that may be a http URL, try to massage it into an RFC-compliant http URL string */
- (NSString*)autoCompletedHTTPStringFromString:(NSString*)urlString
{	
	NSArray* stringParts = [urlString componentsSeparatedByString:@"/"];
	NSString* host = [stringParts objectAtIndex:0];
	
	// Added 01/05/07 by GB
	// Fix host if the string is already completely HTTP complete
	if([host isEqualToString:@"http:"]){
		host = [stringParts objectAtIndex:2];
	}
    
	if ([host rangeOfString:@"."].location == NSNotFound)
	{ 
		host = [NSString stringWithFormat:@"www.%@.com", host];
		urlString = [host stringByAppendingString:@"/"];
		
		NSArray* pathStrings = [stringParts subarrayWithRange:NSMakeRange(1, [stringParts count] - 1)];
		NSString* filePath = @"";
		if ([pathStrings count])
			filePath = [pathStrings componentsJoinedByString:@"/"];

		urlString = [urlString stringByAppendingString:filePath];
	}
	
	// see if the newly reconstructed string is a well formed URL

	// Added 01/05/07 by GB
	// Only append the HTTP if it isn't already there
	if([urlString rangeOfString:@"http://"].location == NSNotFound){
	
		urlString = [@"http://" stringByAppendingString:urlString];
	}

	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	return [[NSURL URLWithString:urlString] absoluteString];
}

#pragma mark -
#pragma mark  Comparison Methods
#pragma mark -

// Compare self and controller to see if they're equal
- (BOOL)isEqual:(GBChannelViewController *)controller{
	
	// Return they are equal if the channels are equal
	return [[self channel] isEqual:[controller channel]];
}

#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{

	[channel release];
	
	[super dealloc];
}

@end
