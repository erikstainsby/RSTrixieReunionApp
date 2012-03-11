//
//  NSView+RSPositionView.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-02-17.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "NSView+RSPositionView.h"

@implementation NSView (RSPositionView)

- (void) setFrameTopLeftPoint:(NSPoint)aPoint {
	NSRect frame = [self frame];
	float height = frame.size.height;
	frame.origin.y = aPoint.y - height;
	float deltaX = frame.origin.x - aPoint.x;
	frame.origin.x = frame.origin.x - deltaX;
	self.frame = frame;
}

@end
