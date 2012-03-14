//
//  RSWindow.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWindow.h"

@implementation RSWindow

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
	
}
- (void) mouseUp:(NSEvent *)theEvent {
	
}

- (void) mouseEntered:(NSEvent *)theEvent {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}
- (void) mouseExited:(NSEvent *)theEvent {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}

- (void) sendEvent:(NSEvent *)theEvent {
	if([theEvent type] == NSLeftMouseUp ) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"LEFT MOUSE UP");
	}
	else {
		[super sendEvent: theEvent];
	}
}

@end
