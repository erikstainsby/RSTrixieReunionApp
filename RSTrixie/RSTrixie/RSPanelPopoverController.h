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
@property (weak) IBOutlet NSTextField * caption;

- (IBAction) showPanelPopover:(id)sender;

@end
