//
//  RSWebView.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWebView.h"

@implementation RSWebView

@synthesize trackingRectTag;


- ( void) awakeFromNib {
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- ( void) updateTrackingAreas {
	[self removeTrackingRect:trackingRectTag];
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

@end
