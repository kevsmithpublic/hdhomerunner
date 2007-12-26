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
//  GBWindowController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBWindowController.h"

// Default folder titles
#define DEVICES_NAME			@"DEVICES"
#define CHANNELS_NAME			@"CHANNELS"
#define GROUPS_NAME				@"GROUPS"

#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view

@implementation GBWindowController

- (id)init{
	if(self == [super init]){
		contents = [[NSMutableArray alloc] init];
		
		[contents addObject:[[GBTunerController alloc] init]];
		[contents addObject:[[GBChannelController alloc] init]];
	}
	
	return self;
}

- (void)awakeFromNib{
	// This is required when subclassing NSWindowController.
	[self setWindowFrameAutosaveName:@"MainWindow"];
	
	// This will center the main window if there's no stored position for it.
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"NSWindow Frame MainWindow"] == nil){
		[[self window] center];
	}

	// Set the splitters' autosave names.
	[splitView setPositionAutosaveName:@"SourceSplitter"];
	[splitView setPositionAutosaveName:@"ListSplitter"];

	// Place the source list view in the left panel.
	[sourceView setFrameSize:[sourceViewPlaceholder frame].size];
	[sourceViewPlaceholder addSubview:sourceView];

	// Place the content view in the right panel.
	[contentView setFrameSize:[contentViewPlaceholder frame].size];
	[contentViewPlaceholder addSubview:contentView];
}

#pragma mark - Toolbar actions

// Play ToobarItem action
// Play the currently selected channel when the user clicks this item
- (IBAction)play:(id)sender{
	NSLog(@"play toolbar item selected");
}

// Next Toolbar action
// Move to the next channel when the user clicks this item
- (IBAction)next:(id)sender{
	NSLog(@"next toolbar item selected");
}

// Previous Toolbar action
// Move to the previous channel when the user clicks this item
- (IBAction)previous:(id)sender{
	NSLog(@"previous toolbar item selected");
}

// Get Info ToobarItem action
// Get info on the currently selected object when the user clicks this item
- (IBAction)getInfo:(id)sender{
	NSLog(@"info toolbar item selected");
}

// Refresh Device List ToobarItem action
// Manually refresh the list of devices when the user clicks this item
- (IBAction)refreshDevices:(id)sender{
	NSLog(@"refresh toolbar item selected");
}

// Open Preferences action
// Open the application preferences when the user clicks this item.
- (IBAction)openPreferences:(id)sender{
	NSLog(@"prefrences toolbar item selected");
}

// Record action
// Record the current channel when the user clicks this item
- (IBAction)record:(id)sender{
	NSLog(@"record toolbar item selected");
}

#pragma mark - NSOutlineView datasource methods

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item{
	NSLog(@"outlineView: child:%i ofItem:%@", index, item);

	// If the parent (item) is not nil then return the children of the parent at the specified index
	if(item){
		return [[item children] objectAtIndex:index];
		
	} else {
		// Else return the parent at the specified index
		return [contents objectAtIndex:index];;
	}
	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
	NSLog(@"outlineView: isItemExpandable:%@", [item class]);
	
	BOOL result = NO;
	
	// If the item is not null
	if(item){
	
		result = [item isExpandable];
	}
	
	
	return result;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
	NSLog(@"outlineView: numberOfChildrenofItem:%@", item);
	
	// Default number of Children is the number of items in the content object
	int result = [contents count];
	
	// If the item is not null and therefore not the content object
	if(item){
	
		// Set result to be the number of children that the specified parent has
		result = [item numberOfChildren];
	}
	
	return result;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
	NSLog(@"outlineView: objectValueForTableColumn:%i byItem:%@", [tableColumn identifier], item);

	// The object to return
	id result;
	
	// If the column requesting data is the name column
	if([[tableColumn identifier] compare:COLUMNID_NAME] == NSOrderedSame){

		result = [NSString stringWithString:[item title]];
	} else {
		
		// Else we should return the icon of the item
		result =  [[item icon] copy];
	}
	
	return result;
}

#pragma mark - NSOutlineView delegate methods

// Should the outlineview select the item?
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
	// Don't allow the main parents displayed be selected
	//return (![contents containsObject:item]);
	return (![item isExpandable]);
}

// Decide whether to allow the selection to change 
- (BOOL)selectionShouldChangeInOutlineView:(NSOutlineView *)outlineView{
	
	// Assume that the user entered a null value
	BOOL result = YES;
	
	NSLog(@"selectionShouldChange %@", [outlineView stringValue]);
	
	/*if ([[fieldEditor string] length] == 0)
	{
		// don't allow empty names
		return NO;
	}
	else
	{
		return YES;
	}*/
	
	return result;
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item{
	// Don't allow the main parents displayed to be edited or the imagecell
	return !(([contents containsObject:[item representedObject]]) || ([tableColumn identifier] != COLUMNID_NAME));
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item{	 
	/*if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are displaying the single and only column
		if ([cell isKindOfClass:[ImageAndTextCell class]])
		{
			item = [item representedObject];
			if (item)
			{
				if ([item isLeaf])
				{
					// does it have a URL string?
					NSString *urlStr = [item urlString];
					if (urlStr)
					{
						if ([item isLeaf])
						{
							NSImage *iconImage;
							if ([[item urlString] hasPrefix:HTTP_PREFIX])
								iconImage = urlImage;
							else
								iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
						else
						{
							NSImage* iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
					}
					else
					{
						// it's a separator, don't bother with the icon
					}
				}
				else
				{
					// check if it's a special folder (DEVICES or PLACES), we don't want it to have an icon
					if ([self isSpecialGroup:item])
					{
						[item setNodeIcon:nil];
					}
					else
					{
						// it's a folder, use the folderImage as its icon
						[item setNodeIcon:folderImage];
					}
				}
			}
			
			// set the cell's image
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}*/
}

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
/*- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}*/

// -------------------------------------------------------------------------------
//	changeItemView:
// ------------------------------------------------------------------------------
/*- (void)changeItemView
{
	NSArray		*selection = [treeController selectedObjects];	
	BaseNode	*node = [selection objectAtIndex:0];
	NSString	*urlStr = [node urlString];
	
	if (urlStr)
	{
		NSURL *targetURL = [NSURL fileURLWithPath:urlStr];
		
		if ([urlStr hasPrefix:HTTP_PREFIX])
		{
			// the url is a web-based url
			if (currentView != webView)
			{
				// change to web view
				[self removeSubview];
				currentView = nil;
				[placeHolderView addSubview:webView];
				currentView = webView;
			}
			
			// this will tell our WebUIDelegate not to retarget first responder since some web pages force
			// forus to their text fields - we want to keep our outline view in focus.
			retargetWebView = YES;	
			
			[webView setMainFrameURL:nil];		// reset the webview to an empty frame
			[webView setMainFrameURL:urlStr];	// re-target to the new url
		}
		else
		{
			// the url is file-system based (folder or file)
			if (currentView != [fileViewController view] || currentView != [iconViewController view])
			{
				// add a spinning progress gear in case populating the icon view takes too long
				NSRect bounds = [placeHolderView bounds];
				CGFloat x = (bounds.size.width-32)/2;
				CGFloat y = (bounds.size.height-32)/2;
				NSProgressIndicator* busyGear = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(x, y, 32, 32)];
				[busyGear setStyle:NSProgressIndicatorSpinningStyle];
				[busyGear startAnimation:self];
				[placeHolderView addSubview:busyGear];
				[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away

				// detect if the url is a directory
				Boolean isDirectory;
				FSRef ref;
				FSPathMakeRef((const UInt8 *)[urlStr fileSystemRepresentation], &ref, &isDirectory);
				
				if (isDirectory)
				{
					// avoid a flicker effect by not removing the icon view if it is already embedded
					if (!(currentView == [iconViewController view]))
					{
						// remove the old subview
						[self removeSubview];
						currentView = nil;
					}
					
					// change to icon view to display folder contents
					[placeHolderView addSubview:[iconViewController view]];
					currentView = [iconViewController view];
					
					// its a directory - show its contents using NSCollectionView
					iconViewController.url = targetURL;
				}
				else
				{
					// its a file, just show the item info

					// remove the old subview
					[self removeSubview];
					currentView = nil;
				
					// change to file view
					[placeHolderView addSubview:[fileViewController view]];
					currentView = [fileViewController view];
					
					// update the file's info
					fileViewController.url = targetURL;
				}
				
				[busyGear removeFromSuperview];
			}
		}
		
		NSRect newBounds;
		newBounds.origin.x = 0;
		newBounds.origin.y = 0;
		newBounds.size.width = [[currentView superview] frame].size.width;
		newBounds.size.height = [[currentView superview] frame].size.height;
		[currentView setFrame:[[currentView superview] frame]];
		
		// make sure our added subview is placed and resizes correctly
		[currentView setFrameOrigin:NSMakePoint(0,0)];
		[currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	}
	else
	{
		// there's no url associated with this node
		// so a container was selected - no view to display
		[self removeSubview];
		currentView = nil;
	}
}*/

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
	NSLog(@"selection did change notification");
	/*if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;

	// ask the tree controller for the current selection
	NSArray *selection = [treeController selectedObjects];
	if ([selection count] > 1)
	{
		// multiple selection - clear the right side view
		[self removeSubview];
		currentView = nil;
	}
	else
	{
		if ([selection count] == 1)
		{
			// single selection
			[self changeItemView];
		}
		else
		{
			// there is no current selection - no view to display
			[self removeSubview];
			currentView = nil;
		}
	}*/
}

#pragma mark - Import/Export Channels

// Take action based on importing channel menuitem being selected
-(IBAction)importChannels:(id)sender{
	// The panel to open
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	// The array of file types to filter 
	NSArray *fileTypes;

	// Only allow single files to be selected
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:NO];
	
	// If the sender is importhdhrcontrol
	if(sender == importhdhrcontrol){

		// Only allow single files to be selected
		[openPanel setAllowsMultipleSelection:NO];
		[openPanel setCanChooseDirectories:NO];
	
		// Set the file types to filter on to only plist
		fileTypes = [NSArray arrayWithObjects:@"plist", nil];
		
		// Set the title of the panel
		[openPanel setTitle:@"Import HDHRControl Channel File"];
	}
	
	// Open the panel
	[openPanel beginSheetForDirectory:nil
                           file:nil
                          types:fileTypes
                 modalForWindow:[self window]
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:sender];
	

}

-(IBAction)exportChannels:(id)sender{

	NSSavePanel *savePanel = [NSSavePanel savePanel];
	
	// Allow the user to create directories
	[savePanel setCanCreateDirectories:YES];

	// If the sender is to exporthdhrcontrol file
	if(sender == exporthdhrcontrol){
	
		// Set the file type of the file being saved
		[savePanel setRequiredFileType:@"plist"];
		
		// Set the title of the panel
		[savePanel setTitle:@"Export HDHRControl Channel File"];
	}
	
	// Open the panel
	[savePanel beginSheetForDirectory:nil
                           file:nil
                 modalForWindow:[self window]
                  modalDelegate:self
                 didEndSelector:@selector(filePanelDidEnd:
                                               returnCode:
                                              contextInfo:)
                    contextInfo:sender];
}

-(void)filePanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo{
	
	// If the OK button was selected (as opposed to Cancel)
	if(returnCode == NSOKButton){
		
		// If the sender was importhdhrcontrol
		if(contextInfo = importhdhrcontrol){
			
			// Init an array of objects from the specified file
			NSArray *anArray = [NSArray arrayWithContentsOfFile:[panel filename]];
			
			// Enumerator of the channels to import
			NSEnumerator *newchannel_enumerator = [anArray objectEnumerator];
			
			// Object to use during iteration
			NSDictionary *new_channel;
			
			// Loop over all imported channels
			while ((new_channel = [newchannel_enumerator nextObject])) {
			
				// All of the values in the new_object dictionary
				NSArray *values =	[NSArray arrayWithObjects:[new_channel objectForKey:@"Description"], 
									[new_channel objectForKey:@"Channel"],
									[new_channel objectForKey:@"Program"], nil];
				
				// The keys for new_object dictionary
				NSArray *keys = [NSArray arrayWithObjects:	@"description",
															@"channel",
															@"program", nil];
				
				// A new dictionary based on the translation from HDHRControl keys to hdhomerunner keys																						
				NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
				
				// Create a channel with the dictionar
				GBChannel *tmp = [[GBChannel alloc] initWithDictionary:dict];
				
				// Add the channel to the GBChannelController as a child
				[[contents objectAtIndex:1] addChild:tmp];
			}
		} else if(contextInfo = exporthdhrcontrol){
			// If the sender was exporthdhrcontrol
			
		}
	}
}


#pragma mark - Cleanup

// Cleanup after ourselves
- (void)dealloc{
	[contents release];
	
	[super dealloc];
}


@end
