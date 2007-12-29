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
//  GBChannelController.h
//  hdhomerunner
//
//  Created by Gregory Barchard on 12/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "GBController.h"
#import "GBChannel.h"

@interface GBChannelController : GBController {
		// The view
		IBOutlet		NSView			*mainView;

		// The webview to show the channel's URL
		IBOutlet		WebView			*webView;
		
		// The iconview to show the Channel's icon
		IBOutlet		NSImageView		*iconView;
		
		// The textfields to show the relevant info
		IBOutlet		NSTextField		*titleField;
}

- (NSView *)view;

@end
