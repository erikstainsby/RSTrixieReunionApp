//
//  RSWindow.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWindow.h"

@implementation RSWindow

@synthesize mouseIsOverWebView;
@synthesize webview;

- (void) awakeFromNib {

}

- (BOOL) acceptsFirstResponder {
	return YES;
}
- (BOOL) acceptsMouseMovedEvents {
	return YES;
}

- (void) mouseDown:(NSEvent *)theEvent {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}
- (void) mouseUp:(NSEvent *)theEvent {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}

- (void) mouseEntered:(NSEvent *)theEvent {
	[self setMouseIsOverWebView:YES];
}
- (void) mouseExited:(NSEvent *)theEvent {
	[self setMouseIsOverWebView:NO];
}
 
- (void) sendEvent:(NSEvent *)theEvent {
	if([theEvent type] == NSLeftMouseDown && mouseIsOverWebView) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"WebView mouseDown");

		[[NSNotificationCenter defaultCenter] postNotificationName:nnRSWebViewLeftMouseDownEventNotification object:theEvent];
	}
	else if([theEvent type] == NSLeftMouseUp && mouseIsOverWebView) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"WebView mouseUp");
	}
	else {
		[super sendEvent: theEvent];
	}
}

@end
