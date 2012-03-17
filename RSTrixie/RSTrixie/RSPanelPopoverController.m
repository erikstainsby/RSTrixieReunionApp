//
//  RSPanelPopoverController.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-17.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPanelPopoverController.h"

@implementation RSPanelPopoverController

@synthesize popover = _popover;
@synthesize caption = _caption;


- (IBAction) showPanelPopover:(id)sender {
	
	[[self caption] setStringValue:@"Surprise! It worked!"];
	[_popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}


@end
