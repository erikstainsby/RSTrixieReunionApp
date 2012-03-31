//
//  RSPanelPopoverController.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-17.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSPanelPopoverController : NSViewController < NSPopoverDelegate >

@property (weak) IBOutlet NSPopover * popover;
@property (weak) IBOutlet NSBox * box;
@property (assign) NSInteger activePanelWidth;
@property (assign) NSInteger activePanelHeight;
@property (retain) IBOutlet NSButton * nextButton;
@property (retain) id currentClientPanel;

- (void) showPanelPopover:(NSView*)locator activePanel:(NSView*)panel;
- (IBAction) cancelPopoverSession:(id)sender;

@end
