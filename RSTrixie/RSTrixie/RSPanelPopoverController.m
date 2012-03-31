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
@synthesize box = _box;
@synthesize activePanelWidth;
@synthesize activePanelHeight;
@synthesize nextButton;
@synthesize currentClientPanel;

- (id)init  {
    self = [super init];
    if (self) {    }
    return self;
}

- (void) awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	currentClientPanel = nil;
}

- (void) showPanelPopover:(NSView*)locator activePanel:(NSView*)panel {
	
	[self setActivePanelWidth: panel.frame.size.width];
	[self setActivePanelHeight: panel.frame.size.height];
	
	if( currentClientPanel == nil) {
		[[self view] replaceSubview:[self box] with: panel];
		NSPoint pt = self.view.bounds.origin;
		pt.y += 22;
		[panel setFrameOrigin: pt];
	}
	else {
		[[self view] replaceSubview:currentClientPanel with: panel];
		[panel setFrameOrigin: self.view.bounds.origin];
	}
	currentClientPanel = panel;
	
	[[self popover] showRelativeToRect:[locator bounds] ofView:locator preferredEdge:NSMinYEdge];
}

- (IBAction) cancelPopoverSession:(id)sender {
	[[self popover] performClose:self];
}


@end
