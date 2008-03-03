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
//  GBTunerViewController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 1/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GBTunerViewController.h"


@implementation GBTunerViewController

// Initialize
- (id)init{

	// Call the super class's init
	if(self = [super init]){
		
		// Load the nib. If loading fails then release ourselves and return nil
		if (![NSBundle loadNibNamed: @"TunerView" owner: self]){
            
			// Release
			[self release];
			
			// Point to nil
            self = nil;
        }
		
		subviews = [[NSMutableArray alloc] initWithCapacity:0];
		[self addSubview:[GBTunerSubViewController controller]];
	}

	return self;
}

- (void)awakeFromNib{
	
	// Replace the placeholders with their respective views
	[self placeView:_title inView:titlePlaceholder];
	[self placeView:_caption inView:captionPlaceholder];
	
	[_icon setImageScaling:NSScaleProportionally];
	
	[self placeView:_icon inView:iconPlaceholder];
}

#pragma mark -
#pragma mark  Acessor Methods
#pragma mark -

// Set the tuner to the new tuner
- (void)setTuner:(GBTuner *)aTuner{
	
	// If the tuner is not nil and not the same as the existing tuner
	if((aTuner != nil) && ![tuner isEqual:aTuner]){
		
		// Set the subview to not observe changes for a new tuner
		[self unRegisterSubviewsForTuner:[self tuner]];
		
		// Unregister ourselves as an observer of the tuner
		[self unRegisterAsObserverForTuner:[self tuner]];
		
		// Key value coding
		[self willChangeValueForKey:@"tuner"];
		
		// Auto release the current tuner
		[tuner autorelease];
		
		// Free the tuner
		tuner = nil;
		
		// Assign tuner to the new tuner and retain it
		tuner = [aTuner retain];
		
		// Key value coding
		[self didChangeValueForKey:@"tuner"];
		
		// Set the subview to observe changes for a new tuner
		[self registerSubviewsForTuner:[self tuner]];
		
		// Register ourselves as an observer for the new tuner
		[self registerAsObserverForTuner:[self tuner]];
		
		// Reload the view 
		[self reloadView];
	}
}

// Return the tuner
- (GBTuner *)tuner{

	return tuner;
}

- (NSArray *)subviews{
	
	return subviews;
}

- (void)setSubviews:(NSArray *)array{
	
}

// Returm the play menu
- (NSMenuItem *)playMenu{

	return _play_menu;
}

// Set the play menu
- (void)setPlayMenu:(NSMenuItem *)menu{

	// If the menu isn't nil
	if(menu){
	
			// Notify we are about to change
		[self willChangeValueForKey:@"playmenu"];

		// Update the play menu
		[_play_menu autorelease];
		_play_menu = nil;
		_play_menu = menu;
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"playmenu"];
	}
}

// Returm the scan menu
- (NSMenuItem *)scanMenu{

	return _scan_menu;
}

// Set the play menu
- (void)setScanMenu:(NSMenu *)menu{

	// If the menu isn't nil
	if(menu){
	
			// Notify we are about to change
		[self willChangeValueForKey:@"scanmenu"];

		// Update the play menu
		//[[_scan_menu submenu] autorelease];
		[_scan_menu setMenu:menu];
		//_scan_menu = menu;
		
		// Notify everyone of the change
		[self didChangeValueForKey:@"scanmenu"];
	}
}

#pragma mark -
#pragma mark  Manage Menu Items
#pragma mark -

- (void)addPlayMenuItem:(NSMenuItem *)menuItem{
	
	// The menu to update
	NSMenu *menu = [[self playMenu] submenu]; 

	// An array of all the menu items in the menu
	NSArray *tmp = [menu itemArray];

	// An array of the channels from the menu items
	NSMutableArray	*array = [NSMutableArray array];

	// An enumerator to loop thru for the channels
	NSEnumerator *enumerator = [tmp objectEnumerator];

	// An item in the array
	NSMenuItem *item;
	
	// Loop over all the menu items
	while(item = [enumerator nextObject]){
		
		// Add the channels to the array
		[array addObject:[item representedObject]];
	}

	// If the channel isn't in the array already
	if(![array containsObject:[menuItem representedObject]]){

		// Add the menu item to the menu
		[[[self playMenu] submenu] addItem:menuItem];
	}

	// Release the menu item
	[menuItem release];
}

- (void)removePlayMenuItem:(NSMenuItem *)menuItem{
	
	// The menu to update
	NSMenu *menu = [[self playMenu] submenu]; 

	// An array of all the menu items in the menu
	NSArray *tmp = [menu itemArray];

	// An enumerator to loop thru for the channels
	NSEnumerator *enumerator = [tmp objectEnumerator];

	// An item in the array
	NSMenuItem *item;

	// Loop over all the menu items
	while(item = [enumerator nextObject]){
		
		// If the represented object of the item is the same as the one
		// that we are trying to remove
		if([[item representedObject] isEqual:[menuItem representedObject]]){
			
			// Remove the item from the array
			[[[self playMenu] submenu] removeItem:item];
		}
	}

	// Release the menu item
	[menuItem release];
}

#pragma mark -
#pragma mark  Register for KVO
#pragma mark -

// Register all subviews as observers of aTuner
- (void)registerSubviewsForTuner:(GBTuner *)aTuner{

	// The enumerator to loop over
	NSEnumerator *enumerator = [subviews objectEnumerator];
	
	// Each object in the enumerator
	GBTunerSubViewController *object;
	
	// Loop over all the views
	while ((object = [enumerator nextObject])) {
		
		// Register as an observer for the tuner
		[object registerAsObserverForTuner:aTuner];
	}
}

// Unregister all subviews as observers of aTuner
- (void)unRegisterSubviewsForTuner:(GBTuner *)aTuner{

	// The enumerator to loop over
	NSEnumerator *enumerator = [subviews objectEnumerator];
	
	// Each object in the enumerator
	GBTunerSubViewController *object;
	
	// Loop over all the views
	while ((object = [enumerator nextObject])) {
		
		// Unregister as an observer for the tuner
		[object unRegisterAsObserverForTuner:aTuner];
	}
}

#pragma mark -
#pragma mark  Manage the subviews
#pragma mark -

// Add a subview controller to the array
- (void)addSubview:(GBTunerSubViewController *)controller{
	
	// If it isn't already in the array
	if(![subviews containsObject:controller]){
		
		// Then add it
		[subviews addObject:controller];
	}
}

// Remove a subview controller to the array
- (void)removeSubview:(GBTunerSubViewController *)controller{
	
	// If the controller is in the array
	if([subviews containsObject:controller]){
	
		// Then remove it
		[subviews removeObject:controller];
	}
}

#pragma mark -
#pragma mark  Update the views
#pragma mark -

- (void)reloadView{
	
	// Update the fields appropriately
	[_title setStringValue:[[self tuner] title]];
	[_caption setStringValue:[[self tuner] caption]];
	[_icon setImage:[NSApp applicationIconImage]];
}

// Hide the subviews from being displayed
- (void)hideSubviews{
	
	// The enumerator to loop over
	NSEnumerator *enumerator = [[self subviews] objectEnumerator];
	
	// Each object in the enumerator
	GBTunerSubViewController *object;
	
	// Loop over all the views
	while ((object = [enumerator nextObject])) {
		
		// Hide the view
		[[object view] setHidden:YES];
	}
}

// Unhide the subviews from being displayed
- (void)unhideSubviews{
	
	// The enumerator to loop over
	NSEnumerator *enumerator = [[self subviews] objectEnumerator];
	
	// Each object in the enumerator
	GBTunerSubViewController *object;
	
	// Loop over all the views
	while ((object = [enumerator nextObject])) {
		
		// Hide the view
		[[object view] setHidden:NO];
	}
}

// Redraw the subviews if needed
- (void)redrawSubviews{
	
	// The enumerator to loop over
	NSEnumerator *enumerator = [subviews objectEnumerator];
	
	// Each object in the enumerator
	GBTunerSubViewController *object;
	
	// Loop over all the views
	while ((object = [enumerator nextObject])) {
		
		// Redraw the view
		[[object view] display];
	}
}

#pragma mark -
#pragma mark  Text field Delegate Methods
#pragma mark -

- (void)controlTextDidEndEditing:(NSNotification *)notification{
	
	// The textfield posting the notification
	NSTextField *textfield = [notification object];
	
	// Figure out which text field is posting the notification
	if(textfield == _title){
		
		// Update the title of the tuner
		[[self tuner] setTitle:[_title stringValue]];
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
#pragma mark  Comparison Methods
#pragma mark -

// Compare self and controller to see if they're equal
/*- (BOOL)isEqual:(GBTunerViewController *)controller{
	NSLog(@"class = %@", [controller class]);
	// Return they are equal if the tuners are equal
	return [[self tuner] isEqual:[controller tuner]];
}*/

#pragma mark -
#pragma mark  Key Value Observing
#pragma mark -

// Register for Key Value Coding of the tuner
// When the signal strength changes we should update the view
- (void)registerAsObserverForTuner:(GBTuner *)aTuner{
	
	[aTuner addObserver:self
			forKeyPath:@"title"
			options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
			context:NULL];
					
	[aTuner addObserver:self
			forKeyPath:@"caption"
			options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			context:NULL];
}

- (void)unRegisterAsObserverForTuner:(GBTuner *)aTuner{

    [aTuner removeObserver:self forKeyPath:@"title"];
	[aTuner removeObserver:self forKeyPath:@"caption"];
	//[aTuner removeObserver:self forKeyPath:@"channels"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
						ofObject:(id)object
                        change:(NSDictionary *)change
						context:(void *)context {
	
	// If the signal strength changed
	if ([keyPath isEqual:@"title"]) {
		
		// Update the title value
		[_title setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
    } else if([keyPath isEqual:@"caption"]) {

		// Update the caption
		[_caption setObjectValue:[change objectForKey:NSKeyValueChangeNewKey]];
	}
}

#pragma mark -
#pragma mark  IBActions
#pragma mark -

- (IBAction)largeType:(id)sender{
	
	// The enumerator to loop over
	NSEnumerator *enumerator = [[self subviews] objectEnumerator];
	
	// An object in the enumerator
	GBTunerSubViewController *controller;
	
	// Loop over the subviews
	while(controller = [enumerator nextObject]){
		
		// Tell the subviews to show their large type
		[controller displayLargeType];
	}
}

#pragma mark -
#pragma mark  Clean up
#pragma mark -

- (void)dealloc{

	[self unRegisterAsObserverForTuner:[self tuner]];

	[_title release];
	[_caption release];
	[_icon release];
	
	[tuner release];
	[subviews release];
	
	[super dealloc];
}

@end
