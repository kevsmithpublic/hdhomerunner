//
//  GBWindowController.m
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "GBWindowController.h"

/*#import "ChildNode.h"
#import "ImageAndTextCell.h"
#import "SeparatorCell.h"*/

// Default folder titles
#define DEVICES_NAME			@"DEVICES"
#define CHANNELS_NAME			@"CHANNELS"
#define GROUPS_NAME				@"GROUPS"

#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view

// -------------------------------------------------------------------------------
//	TreeAdditionObj
//
//	This object is used for passing data between the main and secondary thread
//	which populates the outline view.
// -------------------------------------------------------------------------------
/*@interface TreeAdditionObj : NSObject
{
	NSIndexPath *indexPath;
	NSString	*nodeURL;
	NSString	*nodeName;
	BOOL		selectItsParent;
}

- (NSIndexPath *)indexPath;
- (void)setIndexPath:(NSIndexPath *)newIndexPath;

- (NSString *)nodeURL;
- (void)setNodeURL:(NSString *)newURL;

- (NSString *)nodeName;
- (void)setNodeName:(NSString *)newName;

- (BOOL)selectItsParent;
- (void)setSelectItsParent:(BOOL)aState;
@end

@implementation TreeAdditionObj

// -------------------------------------------------------------------------------
- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select
{
	self = [super init];
	
	nodeName = [[NSString alloc] initWithString:name];
	nodeURL = [[NSString alloc] initWithString:url];
	selectItsParent = select;
	
	return self;
}

- (NSIndexPath *)indexPath{
	return indexPath;
}

- (void)setIndexPath:(NSIndexPath *)newIndexPath{
	if(indexPath != newIndexPath){
		[self willChangeValueForKey:@"indexPath"];
		[indexPath release];
		indexPath = newIndexPath;//[[NSIndexPath alloc] initWithIndex:newIndexPath];
		[self didChangeValueForKey:@"indexPath"];
	}
}

- (NSString *)nodeURL{
	return nodeURL;
}

- (void)setNodeURL:(NSString *)newURL{
	if(nodeURL != newURL){
		[self willChangeValueForKey:@"nodeURL"];
		[nodeURL release];
		nodeURL = [[NSString alloc] initWithString:newURL];
		[self didChangeValueForKey:@"nodeURL"];
	}
}

- (NSString *)nodeName{
	return nodeName;
}

- (void)setNodeName:(NSString *)newName{

}

- (BOOL)selectItsParent{
	return selectItsParent;
}

- (void)setSelectItsParent:(BOOL)aState{
	if(selectItsParent != aState){
		[self willChangeValueForKey:@"selectItsParent"];
		selectItsParent = aState;
		[self didChangeValueForKey:@"selectItsParent"];
	}
}

@end*/

@implementation GBWindowController
// -------------------------------------------------------------------------------
//	initWithWindow:window:
// -------------------------------------------------------------------------------
/*-(id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		contents = [[NSMutableArray alloc] init];
		
		// cache the reused icon images
		//folderImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)] retain];
		//[folderImage setSize:NSMakeSize(16,16)];
		
		//urlImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain];
		//[urlImage setSize:NSMakeSize(16,16)];
	}
	
	return self;
}*/

// -------------------------------------------------------------------------------
//	awakeFromNib:
// -------------------------------------------------------------------------------
/*- (void)awakeFromNib
{
	// load the icon view controller for later use
	//iconViewController = [[IconViewController alloc] initWithNibName:ICONVIEW_NIB_NAME bundle:nil];
	
	// load the file view controller for later use
	//fileViewController = [[FileViewController alloc] initWithNibName:FILEVIEW_NIB_NAME bundle:nil];
	
	// load the child edit view controller for later use
	//childEditController = [[ChildEditController alloc] initWithWindowNibName:CHILDEDIT_NAME];
	
	//[[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	//[[self window] setContentBorderThickness:30 forEdge:NSMinYEdge];
	
	// apply our custom ImageAndTextCell for rendering the first column's cells
	NSTableColumn *tableColumn = [outlineView tableColumnWithIdentifier:COLUMNID_NAME];
	ImageAndTextCell *imageAndTextCell = [[[ImageAndTextCell alloc] init] autorelease];
	[imageAndTextCell setEditable:YES];
	[tableColumn setDataCell:imageAndTextCell];
   
	separatorCell = [[SeparatorCell alloc] init];
    [separatorCell setEditable:NO];
	
	// build our default tree on a separate thread,
	// some portions are from disk which could get expensive depending on the size of the dictionary file:
	[NSThread detachNewThreadSelector:	@selector(populateOutlineContents:)
										toTarget:self		// we are the target
										withObject:nil];
	
	// add images to our add/remove buttons
	//NSImage *addImage = [NSImage imageNamed:NSImageNameAddTemplate];
	//[addFolderButton setImage:addImage];
	//NSImage *removeImage = [NSImage imageNamed:NSImageNameRemoveTemplate];
	//[removeButton setImage:removeImage];
	
	// insert an empty menu item at the beginning of the drown down button's menu and add its image
	//NSImage *actionImage = [NSImage imageNamed:NSImageNameActionTemplate];
	//[actionImage setSize:NSMakeSize(10,10)];
	
	//NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	//[[actionButton menu] insertItem:menuItem atIndex:0];
	//[menuItem setImage:actionImage];
	//[menuItem release];
	
	// truncate to the middle if the url is too long to fit
	//[[urlField cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];
	
	// scroll to the top in case the outline contents is very long
	[[[outlineView enclosingScrollView] verticalScroller] setFloatValue:0.0];
	[[[outlineView enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0,0)];
	
	// make our outline view appear with gradient selection, and behave like the Finder, iTunes, etc.
	[outlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
	
	// drag and drop support
	[outlineView registerForDraggedTypes:[NSArray arrayWithObjects:
											kNodesPBoardType,			// our internal drag type
											NSURLPboardType,			// single url from pasteboard
											NSFilenamesPboardType,		// from Safari or Finder
											NSFilesPromisePboardType,	// from Safari or Finder (multiple URLs)
											nil]];
											
	//[webView setUIDelegate:self];	// be the webView's delegate to capture NSResponder calls
}*/


// -------------------------------------------------------------------------------
//	selectParentFromSelection:
//
//	Take the currently selected node and select its parent.
// -------------------------------------------------------------------------------
/*- (void)selectParentFromSelection
{
	if ([[treeController selectedNodes] count] > 0)
	{
		NSTreeNode* firstSelectedNode = [[treeController selectedNodes] objectAtIndex:0];
		NSTreeNode* parentNode = [firstSelectedNode parentNode];
		if (parentNode)
		{
			// select the parent
			NSIndexPath* parentIndex = [parentNode indexPath];
			[treeController setSelectionIndexPath:parentIndex];
		}
		else
		{
			// no parent exists (we are at the top of tree), so make no selection in our outline
			NSArray* selectionIndexPaths = [treeController selectionIndexPaths];
			[treeController removeSelectionIndexPaths:selectionIndexPaths];
		}
	}
}

// -------------------------------------------------------------------------------
//	addChild:url:withName:
// -------------------------------------------------------------------------------
- (void)addChild:(NSString *)url withName:(NSString *)nameStr selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:url withName:nameStr selectItsParent:select];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddChild:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddChild:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// Add the Device section to the outlineview
- (void)addDevicesSection{
	// Insert the "Devices" group at the top of our tree
	[self addFolder:DEVICES_NAME];
	
	// Array of the tuners
	NSArray *array = [GBTunerController tuners];
	
	// Enumerator of the tuners
	NSEnumerator *enumerator = [array objectEnumerator];
	
	// A tuner
	GBTuner tuner;
	
	// Add each tuner to the devices section
	while((tuner = [enumerator nextObject])){
		// Add each tuner as a child with the description of the tuner as the name
		[self addChild:tuner withName:[tuner description] selectParent:YES];
	}
	
	[self selectParentFromSelection];
}

// Add the places section to the outlineview
/*- (void)addPlacesSection
{
	// add the "Places" section
	[self addFolder:PLACES_NAME];
	
	// add its children
	[self addChild:NSHomeDirectory() withName:nil selectParent:YES];	
	[self addChild:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"] withName:nil selectParent:YES];	
	[self addChild:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] withName:nil selectParent:YES];	
	[self addChild:@"/Applications" withName:nil selectParent:YES];

	[self selectParentFromSelection];
}

- (void)addChannelsSection{
	
}*/

#pragma mark - NSOutlineView delegate
// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
/*- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	// don't allow special group nodes (Devices and Places) to be selected
	BaseNode* node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

// -------------------------------------------------------------------------------
//	dataCellForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSCell* returnCell = [tableColumn dataCell];
	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are being asked for the cell for the single and only column
		BaseNode* node = [item representedObject];
		if ([node nodeIcon] == nil && [[node nodeTitle] length] == 0)
			returnCell = separatorCell;
	}
	
	return returnCell;
}

// -------------------------------------------------------------------------------
//	textShouldEndEditing:
// -------------------------------------------------------------------------------
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	if ([[fieldEditor string] length] == 0)
	{
		// don't allow empty node names
		return NO;
	}
	else
	{
		return YES;
	}
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	BOOL result = YES;
	
	item = [item representedObject];
	if ([self isSpecialGroup:item])
	{
		result = NO; // don't allow special group nodes to be renamed
	}
	else
	{
		if ([[item urlString] isAbsolutePath])
			result = NO;	// don't allow file system objects to be renamed
	}
	
	return result;
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	 
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
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
	}
}

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}

// -------------------------------------------------------------------------------
//	changeItemView:
// ------------------------------------------------------------------------------
- (void)changeItemView
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
}

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
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
	}
}

// ----------------------------------------------------------------------------------------
// outlineView:isGroupItem:item
// ----------------------------------------------------------------------------------------
-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item
{
	if ([self isSpecialGroup:[item representedObject]])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

// -------------------------------------------------------------------------------
//	isSpecialGroup:
// -------------------------------------------------------------------------------
- (BOOL)isSpecialGroup:(BaseNode *)groupNode
{ 
	return ([groupNode nodeIcon] == nil &&
			[[groupNode nodeTitle] isEqualToString:DEVICES_NAME] || [[groupNode nodeTitle] isEqualToString:PLACES_NAME]);
}*/

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
		return [item objectAtIndex:index];
		
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


#pragma mark - Cleanup

// Cleanup after ourselves
- (void)dealloc{
	[contents release];
	
	[super dealloc];
}


@end
